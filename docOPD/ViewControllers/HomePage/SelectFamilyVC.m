//
//  SelectFamilyVC.m
//  docOPD
//
//  Created by Virinchi Software on 27/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "SelectFamilyVC.h"

@interface SelectFamilyVC ()

@end

@implementation SelectFamilyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.changeFamilyBtn setImage:[UIImage imageNamed:@"ok_gray.png"] forState:UIControlStateNormal];
    userdef = userDefault;
    
    // [self getData];
    dataArray=[[NSMutableArray alloc]init];
    dataArray=[NSMutableArray arrayWithArray:self.familyData];
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
    [tracker set:kGAIScreenName value:@"SelectFamilyScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"SelectFamilyScreen"];
}

-(void)getData{
    [[docOPDNetworkEngine sharedInstance]GetRelationAPI:[userdef valueForKey:User_id] withCallback:^(NSDictionary *responseData) {
        NSInteger status=[[responseData objectForKey:@"Status"] intValue];
        if (status==1) {
            dataArray =[NSMutableArray arrayWithArray:[responseData objectForKey:@"RelationList"]];
            [self.tableView reloadData];
        }
        else{
            self.tableView.hidden=YES;
        }
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[docOPDNetworkEngine sharedInstance].familyArrayData count]>0) {
        return [dataArray count]+1;
    }
    else
        return [dataArray count];
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIView *borderView = (UIView *)[cell viewWithTag:1112];
    borderView.layer.cornerRadius = 48/2;
    borderView.layer.borderWidth = 1.0;
    borderView.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    UIImageView *selectImgView = (UIImageView *)[cell viewWithTag:222];
    selectImgView.image=[UIImage imageNamed:@"oval.png"];
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:1000];//ovalSelection
    imgView.layer.cornerRadius=40/2;
    imgView.layer.masksToBounds=YES;
    UILabel *familyName = (UILabel *)[cell viewWithTag:100];
    if ([[docOPDNetworkEngine sharedInstance].familyArrayData count]>0) {
        if (indexPath.row==0) {
            NSString *imgNamestr =@"MyProfileImage.png";
            NSString*userImgFile = [[AppDelegate MyappDelegate].dataPath stringByAppendingPathComponent:imgNamestr];
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:userImgFile];
            if (fileExists) {
                imgView.image  = [self getImage:imgNamestr];
            }else{
                imgView.image  = [UIImage imageNamed:@"user.png"];
            }
            familyName.text=[userdef valueForKey:Username];
        }
        else{
            NSString *path=[[dataArray valueForKey:@"RelationImage"]objectAtIndex:indexPath.row-1];
            if ([path isKindOfClass:[NSNull class]]) {
                imgView.image=[UIImage imageNamed:@"user"];
            }
            else{
                [imgView sd_setImageWithURL:[NSURL URLWithString:path]
                           placeholderImage:[UIImage imageNamed:@""]];
                
            }
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.clipsToBounds = YES;
            
            familyName.text= familyName.text=[[dataArray valueForKey:@"RelationName"]objectAtIndex:indexPath.row-1];
        }
        
    }
    else{
        NSString *path=[[dataArray valueForKey:@"RelationImage"]objectAtIndex:indexPath.row];
        if ([path isKindOfClass:[NSNull class]]) {
            imgView.image=[UIImage imageNamed:@"user"];
        }
        else{
            [imgView sd_setImageWithURL:[NSURL URLWithString:path]
                       placeholderImage:[UIImage imageNamed:@""]];
            
        }
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;
        
        familyName.text= familyName.text=[[dataArray valueForKey:@"RelationName"]objectAtIndex:indexPath.row];
    }

    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *selectImgView = (UIImageView *)[cell viewWithTag:222];
    selectImgView.image=[UIImage imageNamed:@"ovalSelection.png"];
    [self.changeFamilyBtn setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
    if ([[docOPDNetworkEngine sharedInstance].familyArrayData count]>0){
        if (indexPath.row==0) {
            //[[docOPDNetworkEngine sharedInstance].familyArrayData removeAllObjects];
            [docOPDNetworkEngine sharedInstance].familyDataActive=NO;
        }
        else{
            [[docOPDNetworkEngine sharedInstance].familyArrayData removeAllObjects];
            [docOPDNetworkEngine sharedInstance].familyDataActive=YES;
            id object = [dataArray objectAtIndex:indexPath.row-1];
            [[docOPDNetworkEngine sharedInstance].familyArrayData addObject:object];
        }
    }
    else{
        [[docOPDNetworkEngine sharedInstance].familyArrayData removeAllObjects];
        [docOPDNetworkEngine sharedInstance].familyDataActive=YES;
        id object = [dataArray objectAtIndex:indexPath.row];
        [[docOPDNetworkEngine sharedInstance].familyArrayData addObject:object];
    }
    

}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *selectImgView = (UIImageView *)[cell viewWithTag:222];
    selectImgView.image=[UIImage imageNamed:@"oval.png"];
    [[docOPDNetworkEngine sharedInstance].familyArrayData removeAllObjects];
}


- (IBAction)backAction:(id)sender {
    if ([[docOPDNetworkEngine sharedInstance].familyArrayData count]>0){
        [docOPDNetworkEngine sharedInstance].familyDataActive=YES;
    }
    else{
        [[docOPDNetworkEngine sharedInstance].familyArrayData removeAllObjects];
        [docOPDNetworkEngine sharedInstance].familyDataActive=NO;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)changeFamilyAction:(id)sender {
    if ([[docOPDNetworkEngine sharedInstance].familyArrayData count]>0 && [docOPDNetworkEngine sharedInstance].familyDataActive==YES) {
        [docOPDNetworkEngine sharedInstance].familyDataActive=YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if ([docOPDNetworkEngine sharedInstance].familyDataActive==NO){
        [[docOPDNetworkEngine sharedInstance].familyArrayData removeAllObjects];
        [docOPDNetworkEngine sharedInstance].familyDataActive=NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Select a Family Member" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (UIImage*)getImage: (NSString*)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    NSMutableString *dataPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:@"Media"];
    NSString *getImagePath = [dataPath stringByAppendingPathComponent:filename];
    //    NSLog(@"Get image path: %@",getImagePath);
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
    
}
@end
