//
//  AboutViewController.m
//  docOPD
//
//  Created by Virinchi Software on 1/29/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "AboutViewController.h"
#import "termsViewController.h"
//#import "SVModalWebViewController.h"
//#import "SVWebViewController.h"
@interface AboutViewController ()
@property (strong, nonatomic) IBOutlet UILabel *LblAbout;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.LblAbout.text=[NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
  //  NSLog(@"ver %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);
  //  NSLog(@"ver %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);
    self.LblCopyRight.text = [NSString stringWithFormat:@"Copyright \u00A9 2016 docOPD Technologies Pvt. Ltd. \nAll rights reserved."];
    self.LblCopyRight.numberOfLines=0;
    [self.LblCopyRight sizeToFit];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"AboutUSScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"AboutUSScreen"];
}
// NSLog(@"ver low %@", [[NSBundle mainBundle] infoDictionary]);//CFBundleShortVersionString

- (IBAction)GoToBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)didPressBounceMenu:(id)sender {
    [Localytics tagEvent:@"AboutUSSideBarMenuClick"];
    static Menu menu = MenuLeft;
    menu = MenuLeft;
    [[SlideNavigationController sharedInstance] toggleMenu:menu withCompletion:nil];
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
     [Localytics tagEvent:@"AboutUSSideBarMenuClick"];
    return YES;
}
- (IBAction)didPressContactUs:(id)sender {
    [Localytics tagEvent:@"AboutUSContactUSClick"];
    termsViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_TnC"];
    tvc.headerTitleText = @"Contact Us";
    tvc.fullURL = [NSString stringWithFormat:serverUrl@"contact-us"];
//     tvc.fullURL = [NSString stringWithFormat:serverUrl@"terms-condition"];
    [self presentViewController:tvc animated:YES completion:nil];
}
- (IBAction)didPressTerms:(id)sender {
    [Localytics tagEvent:@"AboutUSTerm&ConditionClick"];
    termsViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_TnC"];
    tvc.headerTitleText = @"Terms and Conditions";
    tvc.fullURL = [NSString stringWithFormat:serverUrl@"terms-condition"];
    [self presentViewController:tvc animated:YES completion:nil];


//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:serverUrl@"terms-condition"]];
//    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
//    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
//    [self presentViewController:webViewController animated:YES completion:NULL];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
