//
//  ReferVC.m
//  docOPD
//
//  Created by Virinchi Software on 05/11/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "ReferVC.h"

@interface ReferVC ()

@end

@implementation ReferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    userdef=userDefault;
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:recognizer];
    
    self.referralCodeTXT.text=[userdef objectForKey:ReferenceCode];

    // Do any additional setup after loading the view.
}
-(void)touch{
    [self.referTXT resignFirstResponder];
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
    [tracker set:kGAIScreenName value:@"ReferraCodeScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"ReferraCodeScreen"];
}

#pragma mark UITextFieldDelegate methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField ==self.referTXT)
    {
        NSUInteger newLength = [self.referTXT.text length] + [string length] - range.length;
        return newLength <= 6;
    }
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
}


- (IBAction)submitAction:(id)sender {
    [Localytics tagEvent:@"ReferraCodeSubmitClick"];
    BOOL isvalid=[self CheckForValidation];
    if (isvalid)
    {
        if ([AppDelegate MyappDelegate].isInternet)
        {
            [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:@"Referal code is \n submitting"];
            [[docOPDNetworkEngine sharedInstance]SetUserReferenceAPI:[userdef valueForKey:User_id] referenceCode:self.referTXT.text withCallback:^(NSDictionary *responseData) {
                NSArray *responce=[responseData objectForKey:@"Reference Status"];
                NSInteger referStatus=[[responce valueForKey:@"Status"] intValue];
                NSString* msg=[responce valueForKey:@"Message"];
                [[AppDelegate MyappDelegate] hideIndicator];
                
                if (referStatus==0) {
                    [self ViewSlideDown:msg];
                }
                else if (referStatus==1){
                    [self success:AppName detailMessage:@"successful"];
                    
                }
                else if (referStatus==2){
                    [self ViewSlideDown:msg];
                }
                else if (referStatus==3){
                    [self ViewSlideDown:msg];
                }
                /*
                 "Reference Status" =     {
                 Message = "Reference code is not valid";
                 Status = 0;
                 };
                 */
            }];
            
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Either server is too busy or check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
            [alert show];
            
        }
    }

}

- (IBAction)backAction:(id)sender {
     [Localytics tagEvent:@"ReferraCodeMyAccountClick"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareAction:(id)sender {
    [Localytics tagEvent:@"ReferraCodeShare1`Click"];
    NSString *textToShare = [NSString stringWithFormat:@"Checkout this amazing offer I found on docOPD portraying the best from his store.Enjoy! \n Use referral code '%@'",self.referralCodeTXT.text];
    NSURL *myWebsite = [NSURL URLWithString:@"http://www.docopd.com/"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage, UIActivityTypeMail,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    [self presentViewController:controller animated:YES completion:nil];
}


-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    if (([self.referTXT.text isEqualToString:@""]&& [self.referTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])){
        valid = NO;
        
        [self ViewSlideDown:@"Please enter referal code"];
    }
    
    return valid;
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
        
        [self.navigationController popViewControllerAnimated:YES];  
    }];
}
#pragma mark - No Network Slider

-(void)ViewSlideDown:(NSString*)Message{
    [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"icon.png"]
                                                title:AppName
                                              message:Message
                                           isAutoHide:YES
                                              onTouch:^{
                                                  
                                                  /// On touch handle. You can hide notification view or do something
                                                  [HDNotificationView hideNotificationViewOnComplete:nil];
                                              }];
    
}

@end
