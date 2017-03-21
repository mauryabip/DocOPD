//
//  MyFamilyVC.m
//  docOPD
//
//  Created by Virinchi Software on 26/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "MyFamilyVC.h"
#import "VerifyUserVC.h"

@interface MyFamilyVC ()

@end

@implementation MyFamilyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        CGSize resulation = [[UIScreen mainScreen] bounds].size;
        
        if (resulation.height <= 568) {
            // 4 inch display - iPhone 5
            NSLog(@"Device is an iPhone 5/S/C");
            self.tipsImgView.image=[UIImage imageNamed:@"family_5.png"];
        }
        
        else if (resulation.height == 667) {
            // 4.7 inch display - iPhone 6
            NSLog(@"Device is an iPhone 6");//splashPhone6
            self.tipsImgView.image=[UIImage imageNamed:@"family_6.png"];
        }
        
        else if (resulation.height >= 736) {
            // 5.5 inch display - iPhone 6 Plus
            NSLog(@"Device is an iPhone 6 Plus");
            self.tipsImgView.image=[UIImage imageNamed:@"family_6s.png"];
            
        }
    }

    
    
    self.tipsImgView.hidden=YES;
    self.tipsBtn.hidden=YES;
    //self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //self.tableView.editing=YES;
    userdef = userDefault;
     dataArray=[[NSMutableArray alloc]init];
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
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"RelationList"];
    dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.tableView reloadData];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"MyFamilyScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"MyFamilyScreen"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
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
    
    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:1000];
    imgView.layer.cornerRadius=40/2;
    imgView.layer.masksToBounds=YES;
    
    UIView *borderView = (UIView *)[cell viewWithTag:1112];
    borderView.layer.cornerRadius = 48/2;
    borderView.layer.borderWidth = 1.0;
    borderView.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    
    UILabel *familyName = (UILabel *)[cell viewWithTag:100];
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


    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:70.0f];
    cell.delegate = self;
    
    return cell;
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor redColor] title:@"Delete"];
    
    return rightUtilityButtons;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [Localytics tagEvent:@"Edit Family"];
   BOOL verified= [[[dataArray valueForKey:@"IsRelationVerified"]objectAtIndex:indexPath.row] boolValue];
    if (verified) {
        [Localytics tagEvent:[NSString stringWithFormat:@"MyFamilyEditFamilyClick"]];

        
        AddFamilyVC* vc = [self.storyboard instantiateViewControllerWithIdentifier: @"AddFamilyVC"];
        vc.familyDataArr=[dataArray objectAtIndex:indexPath.row];
        vc.controllerName=@"deatils";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
       [Localytics tagEvent:[NSString stringWithFormat:@"MyFamilyVerificationUserClick"]];
        VerifyUserVC *userVerify = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_verifyUser"];
        userVerify.PushThrough = @"FamilyVerification";
        userVerify.delegate=self;
        userVerify.mobNumber=[[dataArray valueForKey:@"RelationMobileNumber"]objectAtIndex:indexPath.row];
         userVerify.relationUserId=[[dataArray valueForKey:@"RelationUserId"]objectAtIndex:indexPath.row];
        
        //RelationMobileNumber = 9873643192;
        [self presentViewController:userVerify animated:YES completion:nil];
    }
    
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            //            NSLog(@"utility buttons closed");
            break;
        case 1:
            //            NSLog(@"left utility buttons open");
            break;
        case 2:
            //            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}



- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    
    switch (index) {
        case 0:
        {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [[docOPDNetworkEngine sharedInstance]RemoveRelationAPI:[[dataArray valueForKey:@"RelationId"]objectAtIndex:indexPath.row] UserId:[userdef valueForKey:User_id] withCallback:^(NSDictionary *responseData) {
                NSArray *data=[responseData objectForKey:@"Relation Status"];
                NSInteger status=[[data valueForKey:@"Status"] intValue];
                if (status==7) {
                    [self errorWithTitle:@"Error Alert!" detailMessage:[data valueForKey:@"Message"]];
                }
                else{
                    [Localytics tagEvent:[NSString stringWithFormat:@"MyFamilyDeleteButtonClick"]];
                    [dataArray removeObjectAtIndex:index];
                    [userdef setObject:[NSKeyedArchiver archivedDataWithRootObject:dataArray] forKey:@"RelationList"];
                    [userdef  synchronize];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self success:@"Success!" detailMessage:@"Family has beed deleted successfully"];
                    if ([dataArray count]==0) {
                        self.tipsImgView.hidden=NO;
                        self.tipsBtn.hidden=NO;
                    }
                }
                
            }];
        }
       
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


- (void)errorWithTitle:(NSString*)title detailMessage:(NSString*)detail {
    [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:title detail:detail cancelButton:nil Okbutton:nil];
}

- (void)success:(NSString*)title detailMessage:(NSString*)detail {
    [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:title detail:detail cancelButton:nil Okbutton:nil block:^(HHAlertButton buttonindex) {
        if (buttonindex == HHAlertButtonOk) {
            //            NSLog(@"ok Button is seleced use block");
            
        }
        else
        {
            //            NSLog(@"cancel Button is seleced use block");
            
        }
    }];
}

- (IBAction)backAction:(id)sender {
    [Localytics tagEvent:[NSString stringWithFormat:@"MyFamilyMyAccountClick"]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addFamilyAction:(id)sender {
   [Localytics tagEvent:[NSString stringWithFormat:@"MyFamilyAddFamilyClick"]];
    AddFamilyVC* vc = [self.storyboard instantiateViewControllerWithIdentifier: @"AddFamilyVC"];
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)tipsAction:(id)sender {
    self.tipsImgView.hidden=YES;
    self.tipsBtn.hidden=YES;
}
@end
