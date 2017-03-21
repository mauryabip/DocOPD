//
//  NewPasswordViewController.m
//  docOPD
//
//  Created by Virinchi Software on 10/21/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "ViewController.h"
#import "HDNotificationView.h"
typedef enum{
    kTAG_AlertSuccess =1,
    kTAG_AlertWiFi,
}ALLTAGS;


@interface NewPasswordViewController ()

@end

@implementation NewPasswordViewController
@synthesize txtActiveField;
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self setupErrorview];
     [self.navigationController setNavigationBarHidden:YES];
    [self setpadding:self.TFNewPwd];
    [self setpadding:self.TFConfirmPwd];
    [self registerForKeyboardNotifications];
    keyboardHasAppeard = false;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:(BOOL)animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.TFNewPwd becomeFirstResponder];
  
    [self.navigationController setNavigationBarHidden:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"NewPasswordSetScreen"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hideKeyboard)];
    tap.numberOfTapsRequired = 1.0;
    [self.view addGestureRecognizer:tap];
     [Localytics tagEvent:@"NewPasswordSetScreen"];

}


#pragma mark - TextField Setup
-(void)setpadding: (UITextField*)textField{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor dOPDTFBorderColor].CGColor;
    [textField.layer addSublayer:bottomBorder];
    
}
//-(void)setpadding: (UITextField*)textField{
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
//    textField.leftView = paddingView;
//    textField.leftViewMode = UITextFieldViewModeAlways;
//    textField.layer.borderColor = [UIColor dOPDTFBorderColor].CGColor;
//    textField.layer.borderWidth = 1.0;
//    textField.textColor = [UIColor dOPDThemeColor];
//}
- (IBAction)didClickChangePassword:(id)sender {
     [Localytics tagEvent:@"NewPasswordSetSubmitButtonClick"];
    if(!isBtnTapped)
    {
        isBtnTapped = YES;
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



#pragma mark - API Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kForgetResetPassword], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.TFNewPwd.text,Password,self.MobileNumberForChangePassword,Mobile,nil];
    
//    NSLog(@"dataDic for ForgetResetPassword : %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kForgetResetPassword;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
    
    
}

#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
//    NSLog(@"New Password Controller requestFinished");
}

#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response

{
//    NSLog(@"response = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
 //   NSDictionary *resposeCode=[response objectForKey:@"ResetPasswordStatus"];
    NSString *message=[response objectForKey:@"Message"];
    status=[[response objectForKey:@"Status"] integerValue];
    
    if (status == 0)
    {
//        NSLog(@"On the reset password  Vc");
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"docOPD" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        isBtnTapped = false;
        [alert show];
    }
    else if (status == 1){
//        NSLog(@"Status =1");
//        NSLog(@"msg %@",message);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"docOPD" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = kTAG_AlertSuccess;
        [alert show];
    }
}

- (void) requestError
{
//    NSLog(@"RegisterViewController error");
    isBtnTapped = false;
    [[AppDelegate MyappDelegate] hideIndicator];
    [self ViewSlideDown:@"Something went wrong"];
}


#pragma mark - AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==kTAG_AlertSuccess) {
         [Localytics tagEvent:@"NewPasswordSetLoginClick"];
        ViewController *Login = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_Login"];
        [self.navigationController pushViewController:Login animated:YES];
    }else if (alertView.tag == kTAG_AlertWiFi){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - Validation Method
-(BOOL)CheckForValidation
{
    
    BOOL valid=YES;
    //NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
    if([self.TFNewPwd.text isEqualToString:@""] && [self.TFNewPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
    {
        valid = NO;
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter new password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        
//        [alert show];
        [self ViewSlideDown:@"Please enter new password"];
    }
   else if([self.TFConfirmPwd.text isEqualToString:@""] && [self.TFConfirmPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
    {
        valid = NO;
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter confirm password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        
//        [alert show];
        [self ViewSlideDown:@"Please enter confirm password"];
    }
   else if(![self.TFConfirmPwd.text isEqualToString:self.TFNewPwd.text])
   {
       valid = NO;
       
//       UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"New Password and Confirm Password not matched" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//       
//       [alert show];
       [self ViewSlideDown:@"New Password and Confirm Password not matched"];
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


#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
   // [textField setInputAccessoryView:[self inputAccessoryViews]];
    txtActiveField= textField;
    
    if (keyboardHasAppeard)
        [self.Scroller scrollRectToVisible:[self getPaddedFrameForView:textField] animated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.Scroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
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
    self.Scroller.scrollIndicatorInsets = contentInsets;
    
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


#pragma mark - Setup Error View
-(void)setupErrorview{
    errorView = [[UIView alloc]init];
    errorView.frame  = CGRectMake(0, -84, [UIScreen mainScreen].bounds.size.width,84);
    [self.view addSubview:errorView];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, (errorView.frame.size.height-20)/2, 30, 30)];
    icon.image = [UIImage imageNamed:@"round-logo-icon.png"];
    [errorView addSubview:icon];
    //[self ViewSlideDown:@"Something went wrong"];
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

#pragma mark - gesture Recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    else
    {
        [self hideKeyboard];
        return YES;
    }
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
