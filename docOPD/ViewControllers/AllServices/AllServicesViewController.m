//
//  AllServicesViewController.m
//  docOPD
//
//  Created by Virinchi Software on 1/13/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "AllServicesViewController.h"
#import "AllServicesTableViewCell.h"
@interface AllServicesViewController ()

@end

@implementation AllServicesViewController
@synthesize ServicesArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.LblSeperator.backgroundColor = [UIColor dOPDTFBorderColor];
    self.LblDoctorName.text = self.DataFor;
    [Localytics tagEvent:@"All services"];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"All Services for %@",self.DataFor]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];


}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)DismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ServicesArr.count;
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllServicesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllServicesCell" forIndexPath:indexPath];
    cell.LblServicesName.text = [ServicesArr objectAtIndex:indexPath.row][@"ProcedureName"];
    cell.LblServicesName.font = [UIFont systemFontOfSize:15.0];
    cell.LblServicesName.textColor = [UIColor dOPDTextFontColor];
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
