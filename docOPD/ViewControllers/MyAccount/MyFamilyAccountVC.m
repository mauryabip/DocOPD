//
//  MyFamilyAccountVC.m
//  docOPD
//
//  Created by Virinchi Software on 24/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "MyFamilyAccountVC.h"
#import "ViewController.h"
#import "ReferVC.h"

@interface MyFamilyAccountVC ()

@end

@implementation MyFamilyAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    userDef = userDefault;
    self.userImgView.layer.cornerRadius = 82/2;
    self.userImgView.layer.masksToBounds = YES;
    self.borderView.layer.cornerRadius = 90/2;
    self.borderView.layer.borderWidth = 1.0;
    self.borderView.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    
    self.userName.text = [userDef objectForKey:Username];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.BounceMenu];
    
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"MyAccountScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"MyAccountScreen"];
    
    NSString *imgNamestr =@"MyProfileImage.png";
    NSString*userImgFile = [[AppDelegate MyappDelegate].dataPath stringByAppendingPathComponent:imgNamestr];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:userImgFile];
    if (fileExists) {
        self.userImgView.image  = [self getImage:imgNamestr];
    }else{
        self.userImgView.image  = [UIImage imageNamed:@"user.png"];
    }

}
- (UIImage*)getImage: (NSString*)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    dataPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:@"Media"];
    NSString *getImagePath = [dataPath stringByAppendingPathComponent:filename];
    //    NSLog(@"Get image path: %@",getImagePath);
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
    
}
#pragma mark - SlideNavigationController Methods -


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (IBAction)settingAction:(id)sender {
    [Localytics tagEvent:@"MyAccountSettingButtonClick"];
    NSString *version=[NSString stringWithFormat:@"docOPD : %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:version message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *rateApp = [UIAlertAction actionWithTitle:@"Rate the App" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self rateApp];
    }];
    UIAlertAction *referral = [UIAlertAction actionWithTitle:@"Referral code" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [self performSelector:@selector(referAction:) withObject:nil afterDelay:0.000];
    }];
    //Referral code
    UIAlertAction *terms = [UIAlertAction actionWithTitle:@"Terms and Conditions" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self didPressTerms];
        
    }];
    UIAlertAction *contact = [UIAlertAction actionWithTitle:@"Contact Support" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self didPressContactUs];
        
    }];
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         //alert.view.tintColor = [UIColor redColor];
        [self logOut];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
        
    }];
    
    
    [alert addAction:rateApp];
    [alert addAction:referral];
    [alert addAction:terms];
    [alert addAction:contact];
    [alert addAction:logout];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
 
    
//    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:version delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
//                            @"Rate the App",
//                            @"Terms and Conditions",
//                            @"Contact Support",
//                            @"Log Out",
//                            nil];
//    popup.tag = 1;
    
//        SEL selector = NSSelectorFromString(@"_alertController");
//        if ([popup respondsToSelector:selector])
//        {
//            UIAlertController *alertController = [popup valueForKey:@"_alertController"];
//            if ([alertController isKindOfClass:[UIAlertController class]])
//            {
//                alertController.view.tintColor = [UIColor redColor];
//            }
//        }
//        else
//        {
//            // use other methods for iOS 7 or older.
//        }

    //    [popup showInView:self.view];
}


//- (void) changeTextColorForUIActionSheet:(UIActionSheet*)actionSheet {
//    UIColor *tintColor = [UIColor redColor];
//    
//    NSArray *actionSheetButtons = actionSheet.subviews;
//        UIView *view = (UIView*)[actionSheetButtons objectAtIndex:3];
//        if([view isKindOfClass:[UIButton class]]){
//            UIButton *btn = (UIButton*)view;
//            [btn setTitleColor:tintColor forState:UIControlStateNormal];
//            
//    }
//}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self rateApp];
                    break;
                case 1:
                    [self didPressTerms];
                    break;
                case 2:
                    [self didPressContactUs];
                    break;
                case 3:
                    [self logOut];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
-(void)rateApp{
    [Localytics tagEvent:@"MyAccountRatingClick"];
    NSString * appId = @"1112918998";
    NSString * theUrl = [NSString  stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",appId];
    if ([[UIDevice currentDevice].systemVersion integerValue] > 6)
        theUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theUrl]];
}
-(void)logOut{
     [Localytics tagEvent:@"MyAccountLogOutClick"];
    [docOPDNetworkEngine sharedInstance].medicalRecordsByDateFlag=YES;
    NSString *imgNamestr =@"MyProfileImage.png";
    NSString*userImgFile = [[AppDelegate MyappDelegate].dataPath stringByAppendingPathComponent:imgNamestr];
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:userImgFile error:&error];
    if (success) {
        
    }
    
    [userDef setObject:@"No" forKey:@"IsReferenced"];
    [userDef setObject:@"No" forKey:isLogin];
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

    
    ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_Login"];
    [self.navigationController pushViewController:login animated:YES];
}
- (void)didPressContactUs {
    [Localytics tagEvent:@"MyAccountContactSupportClick"];
    [self callSupportAPI];
    NSString *call=[NSString stringWithFormat:@"tel:%@",[userDef objectForKey:ContactSupport]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:call]];
}
- (void)didPressTerms {
    [Localytics tagEvent:@"MyAccountTerms&ConditionClick"];
    termsViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_TnC"];
    tvc.headerTitleText = @"Terms and Conditions";
    tvc.fullURL = [NSString stringWithFormat:serverUrl@"terms-condition"];
    [self presentViewController:tvc animated:YES completion:nil];
    
    
}

-(void)callSupportAPI{
    [[docOPDNetworkEngine sharedInstance]SetCallSupportAPI:[userDef objectForKey:User_id] TitleName:@"Call Support" withCallback:^(NSDictionary *responseData) {
        
    }];
}

- (IBAction)BounceMenu:(id)sender {
    [Localytics tagEvent:@"MyAccountSideMenuClick"];
    static Menu menu = MenuLeft;
    menu = MenuLeft;
    [[SlideNavigationController sharedInstance] toggleMenu:menu withCompletion:nil];
}

- (IBAction)openMyAccountAction:(id)sender {
    [Localytics tagEvent:@"MyAccountMyProfileClick"];
    ProfileDetailViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier: @"MyAccountVC"];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (IBAction)myFamilyAction:(id)sender {
    [Localytics tagEvent:@"MyAccountMyFamilyClick"];
    MyFamilyVC* vc = [self.storyboard instantiateViewControllerWithIdentifier: @"MyFamilyVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)membershipAction:(id)sender {
    [Localytics tagEvent:@"MyAccountMyMembershipClick"];
  
}

- (IBAction)referAction:(id)sender {
    
    [Localytics tagEvent:@"MyAccountRefferalClick"];
    ReferVC* ReferVC = [self.storyboard instantiateViewControllerWithIdentifier: @"ReferVC"];
    [self.navigationController pushViewController:ReferVC animated:YES];
}
@end
