//
//  EmergencyListVC.m
//  docOPD
//
//  Created by Virinchi Software on 02/11/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "EmergencyListVC.h"
#import "EmergencyBookVC.h"

@interface EmergencyListVC ()

@end

@implementation EmergencyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    userDef=userDefault;
    
    self.titleLbl.text=self.name;
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"EmeregencyScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"EmeregencyScreen"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.Data count];
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
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:111];
    UILabel *heading = (UILabel *)[cell viewWithTag:100];
    UILabel *desc = (UILabel *)[cell viewWithTag:101];
        imgView.image=[UIImage imageNamed:@"homehealthLeft"];
        heading.text=[[self.Data valueForKey:@"Title"]objectAtIndex:indexPath.row];
        desc.text=[[self.Data valueForKey:@"Description"]objectAtIndex:indexPath.row];;
       cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [Localytics tagEvent:[NSString stringWithFormat:@"Emeregency%@Click",[[self.Data valueForKey:@"Title"]objectAtIndex:indexPath.row]]];
    EmergencyBookVC* EmergencyBookVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmergencyBookVC"];
    EmergencyBookVC.titleName=@"Emergency";//Emergency
    EmergencyBookVC.Lat=[[self.Data valueForKey:@"Lat"]objectAtIndex:indexPath.row];
    EmergencyBookVC.Lon=[[self.Data valueForKey:@"Lon"]objectAtIndex:indexPath.row];
    EmergencyBookVC.screenName=[[self.Data valueForKey:@"Title"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:EmergencyBookVC animated:YES];
}


- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callAction:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
     [Localytics tagEvent:[NSString stringWithFormat:@"Emeregency%@CallButtonClick",[[self.Data valueForKey:@"Title"]objectAtIndex:indexPath.row]]];
    
    NSString *number=[[self.Data valueForKey:@"ContactNumber"]objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"tel:%@",number]]];
    
     [self callSupportAPI:[[self.Data valueForKey:@"Title"]objectAtIndex:indexPath.row]];

}

-(void)callSupportAPI:(NSString*)Name{
    [[docOPDNetworkEngine sharedInstance]SetCallSupportAPI:[userDef objectForKey:User_id] TitleName:Name withCallback:^(NSDictionary *responseData) {
        
    }];
}

@end
