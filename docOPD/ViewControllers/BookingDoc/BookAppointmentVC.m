//
//  BookAppointmentVC.m
//  docOPD
//
//  Created by Ashutosh Kumar on 8/4/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "BookAppointmentVC.h"

@interface BookAppointmentVC ()

@end

@implementation BookAppointmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBezierPath * path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(10.0, 10.0)];
    [path addLineToPoint:CGPointMake(290.0, 10.0)];
    [path setLineWidth:8.0];
    CGFloat dashes[] = { path.lineWidth, path.lineWidth * 2 };
    [path setLineDash:dashes count:2 phase:0];
    [path setLineCapStyle:kCGLineCapRound];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(300, 20), false, 2);
    [path stroke];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.DocView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.DocView.layer.shadowOffset = CGSizeMake(0, 2);
    self.DocView.layer.shadowOpacity = 0.5;
    
    self.HospitalImage.layer.cornerRadius = self.HospitalImage.frame.size.width/2;
    self.HospitalImage.layer.masksToBounds = YES;
   
}
#pragma mark - SlideNavigationController Methods -
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"Doctor Booking"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
- (IBAction)BounceMenu:(id)sender {
    static Menu menu = MenuLeft;
    [[SlideNavigationController sharedInstance] toggleMenu:menu withCompletion:nil];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
