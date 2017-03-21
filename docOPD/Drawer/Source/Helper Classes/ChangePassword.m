//
//  ChangePassword.m
//  docOPD
//
//  Created by Virinchi Software on 11/5/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "ChangePassword.h"
#import "HHAlertView.h"
#import "ViewController.h"

typedef enum{
    kTAG_AlertWiFi=1,
}ALLTAGS;


@interface ChangePassword ()<HHAlertViewDelegate>

@end


@implementation ChangePassword


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self registerForKeyboardNotifications];
    keyboardHasAppeard = false;
    [[HHAlertView shared] setDelegate:self];
    [self ShowNormalTextfield:self.TFOldPwd];
    [self ShowNormalTextfield:self.TFNewPwd];
    [self ShowNormalTextfield:self.TFConfirmPwd];
    [self.TFOldPwd becomeFirstResponder];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"ChangePasswordScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


- (IBAction)SavePwd:(id)sender {
    [Localytics tagEvent:@"ChangePasswordSaveButtonClick"];
    if(!isBtnTapped)
    {
        BOOL isvalid=[self CheckForValidation];
        if (isvalid)
        {
            if ([AppDelegate MyappDelegate].isInternet)
            {
                isBtnTapped = YES;
                [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.0];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Either server is too busy or check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
                alert.tag = kTAG_AlertWiFi;
                isBtnTapped = false;
                [alert show];
                
            }
        }
    }

    
}
- (IBAction)CancelView:(id)sender {
[Localytics tagEvent:@"ChangePasswordMyProfileClick"];
    [self dismissViewControllerAnimated:YES completion:nil];

}


-(void)scrollResize{
    self.Scroller.contentSize = CGSizeMake(self.Scroller.frame.size.width, self.ContentView.frame.size.height);
}

#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self ShowNormalTextfield:textField];
//    [textField setInputAccessoryView:[self inputAccessoryViews]];
    txtActiveField= textField;
    if (keyboardHasAppeard)
        [self.Scroller scrollRectToVisible:[self getPaddedFrameForView:textField] animated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.Scroller setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

#pragma mark - Validation Method
-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    if(([self.TFOldPwd.text isEqualToString:@""]&& [self.TFOldPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self errorWithTitle:@"Error" detailMessage:@"Please Enter Current Password"];
        [self ShowErrorTextfield:self.TFOldPwd];
    }
    
    else if([self.TFNewPwd.text isEqualToString:@""] && [self.TFNewPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
    {
        valid = NO;
        [self errorWithTitle:@"Error" detailMessage:@"Please Enter New Password"];
         [self ShowErrorTextfield:self.TFNewPwd];
        
    }
    
    else if([self.TFConfirmPwd.text isEqualToString:@""] && [self.TFConfirmPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
    {
        valid = NO;
        [self errorWithTitle:@"Error" detailMessage:@"Please Enter Confirm Password"];
        [self ShowErrorTextfield:self.TFConfirmPwd];
        
    }
    else if(![self.TFConfirmPwd.text isEqualToString:self.TFNewPwd.text])
    {
        valid = NO;
        [self errorWithTitle:@"Error" detailMessage:@"New Password and Confirm Password not matched"];
        [self ShowErrorTextfield:self.TFConfirmPwd];
        [self ShowErrorTextfield:self.TFConfirmPwd];

        
    }

    return valid;
}




#pragma mark - inputAccessoryViews & Delegate

- (UIView *)inputAccessoryViews {
    
    CGRect accessFrame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 40.0);
    inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
    inputAccessoryView.backgroundColor = [UIColor lightGrayColor];
    Done = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    Done.frame = CGRectMake([UIScreen mainScreen].bounds.size.width -[UIScreen mainScreen].bounds.size.width/4 , 5.0, [UIScreen mainScreen].bounds.size.width/5, 30.0);
    Done.layer.cornerRadius = 5.0f;
    Done.layer.masksToBounds = YES;
    [Done setTitle: @"Done" forState:UIControlStateNormal];
    [Done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Done setBackgroundColor:[UIColor dOPDThemeColor]];
    Done.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [Done addTarget:self action:@selector(DoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:Done];
    
    return inputAccessoryView;
}

-(void)DoneButtonClick{
    [txtActiveField resignFirstResponder];
    [self.Scroller setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark - GetPaddedFrameForView

- (CGRect) getPaddedFrameForView:(UIView *) view
{
    CGFloat padding = 5;
    CGRect frame = view.frame;
    frame.size.height += 2 * padding;
    frame.origin.y -= padding;
    return frame;
}


#pragma mark - Keyboard Notification

-(void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark Notification handlers
- (void)keyboardWasShown:(NSNotification*)notif
{
    NSDictionary* info = [notif userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.Scroller.contentInset = contentInsets;
    self.Scroller
    .scrollIndicatorInsets = contentInsets;
    
    //scrolling the active field to visible area
    if ((nil != txtActiveField) && (keyboardHasAppeard == NO))
        [self.Scroller scrollRectToVisible:[self getPaddedFrameForView:txtActiveField] animated:YES];
    
    keyboardHasAppeard = YES;
}

- (void)keyboardWillBeHidden:(NSNotification*)notif
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.Scroller.contentInset = UIEdgeInsetsZero;
    self.Scroller.scrollIndicatorInsets = UIEdgeInsetsZero;
    [UIView commitAnimations];
    
    keyboardHasAppeard = NO;
}




#pragma mark - API Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kResetPassword], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.TFNewPwd.text,Password,self.TFOldPwd.text,OldPassword,nil];
    
 //   NSLog(@"dataDic for RestPassword: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kResetPassword;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
 //   NSLog(@"APICalling for RestPassword");
    
    
}

#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    
    [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
    
  //  NSLog(@"change Password Controller requestFinished");
}


#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response

{
  //  NSLog(@"response = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    NSDictionary *resposeCode=[response objectForKey:@"ResetPasswordStatus"];
    NSString *message=[resposeCode objectForKey:@"Message"];
    NSInteger status=[[resposeCode objectForKey:@"Status"]integerValue];
//    status=[[resposeCode objectForKey:@"Status"] integerValue];
    
    if (status == 0)
    {
   //     NSLog(@"On the login Vc status 0");
         [self errorWithTitle:@"Error" detailMessage:message];
        isBtnTapped= false;
 
    }
    else if (status == 1){
  //      NSLog(@"reset password status1 message = %@",message);
        [self success:@"Success" detailMessage:message];
        [self performSelector:@selector(CancelView:) withObject:nil afterDelay:3.0];
    }
    else if (status == 10){
         userdef =userDefault;
        [userdef setObject:@"No" forKey:isLogin];
        ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_Login"];
        [self.navigationController pushViewController:login animated:YES];
    }

    
}

- (void) requestError
{
    isBtnTapped = false;
  //  NSLog(@"Login ViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
}




#pragma mark - AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (alertView.tag == kTAG_AlertWiFi){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)success:(NSString*)title detailMessage:(NSString*)detail {
    [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:title detail:detail cancelButton:nil Okbutton:nil block:^(HHAlertButton buttonindex) {
        if (buttonindex == HHAlertButtonOk) {
            [txtActiveField resignFirstResponder];
  //          NSLog(@"ok Button is seleced use block");
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        else
        {
        //    NSLog(@"cancel Button is seleced use block");
            
        }
    }];
}
- (void)warning:(id)sender {
    [HHAlertView showAlertWithStyle:HHAlertStyleWarning inView:self.view Title:@"Warning" detail:@"Are you sure?" cancelButton:@"No" Okbutton:@"Sure"];
}
- (void)errorWithTitle:(NSString*)title detailMessage:(NSString*)detail {
    [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:title detail:detail cancelButton:nil Okbutton:nil];
}

- (void)didClickButtonAnIndex:(HHAlertButton)button
{
    if (button == HHAlertButtonOk) {
  //      NSLog(@"ok Button is seleced use delegate");
    }
    else
    {
  //      NSLog(@"cancel Button is seleced use delegate");
        
    }
}


-(void)ShowErrorTextfield:(UITextField*)textField{
 //  textField.layer.borderColor = [UIColor clearColor].CGColor;
    textField.layer.borderColor = [UIColor redColor].CGColor;
    textField.layer.borderWidth=1.0;
   textField.layer.shadowColor =[UIColor redColor].CGColor;
   textField.layer.shadowOffset = CGSizeMake(0.5, 0.5);
   textField.layer.shadowOpacity = 0.1;
}

-(void)ShowNormalTextfield:(UITextField*)textField{
//    textField.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
//    textField.layer.borderWidth=1.0;
//    textField.layer.shadowColor =[UIColor redColor].CGColor;
//    textField.layer.shadowOffset = CGSizeMake(0.5, 0.5);
//    textField.layer.shadowOpacity = 0.1;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor dOPDTFBorderColor].CGColor;
    [textField.layer addSublayer:bottomBorder];
}

-(void)hideKeyboard{
    [self textFieldShouldReturn:txtActiveField];
    [self.Scroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
