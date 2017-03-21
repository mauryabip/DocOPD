//
//  SelectSpecializationVC.m
//  docOPD
//
//  Created by Virinchi Software on 29/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "SelectSpecializationVC.h"

@interface SelectSpecializationVC ()

@end

@implementation SelectSpecializationVC

- (void)viewDidLoad {
    [super viewDidLoad];
   // dataArr=[[NSMutableArray alloc]init];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"NormalSpecialist"];
    dataArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    
    NSData *data1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"Specialist"];
     //dataArr = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    
    for (NSMutableDictionary *temp in [NSKeyedUnarchiver unarchiveObjectWithData:data1]) {
      
            [dataArr addObject:temp];
    }
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"SelectSpecializationListScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"SelectSpecializationListScreen"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [dataArr count];
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    // NSLog(@"willDisplayCell - %ld",(long)indexPath.section);
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:247.0/255.0 blue:248.0/255.0 alpha:1.0];
    
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *selectImgView = (UIImageView *)[cell viewWithTag:222];
    selectImgView.image=[UIImage imageNamed:@"oval.png"];
    UILabel *SpecializationName = (UILabel *)[cell viewWithTag:100];
        SpecializationName.text= [[dataArr valueForKey:@"SpecialistName"]objectAtIndex:indexPath.row];
    
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *selectImgView = (UIImageView *)[cell viewWithTag:222];
    selectImgView.image=[UIImage imageNamed:@"ovalSelection.png"];
    [docOPDNetworkEngine sharedInstance].removeLoadFlag=YES;
    [docOPDNetworkEngine sharedInstance].SpecializationName =[[dataArr valueForKey:@"SpecialistName"]objectAtIndex:indexPath.row];
    [docOPDNetworkEngine sharedInstance].SpecializationID=[[dataArr valueForKey:@"SpecialistId"]objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)backAction:(id)sender {
   
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)resetAction:(id)sender {
    [docOPDNetworkEngine sharedInstance].removeLoadFlag=YES;
    [docOPDNetworkEngine sharedInstance].SpecializationID=@"";
    [docOPDNetworkEngine sharedInstance].SpecializationName =@"Specialization";
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
