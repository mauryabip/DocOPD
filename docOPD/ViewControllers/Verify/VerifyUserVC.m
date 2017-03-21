//
//  VerifyUserVC.m
//  docOPD
//
//  Created by Virinchi Software on 10/21/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "VerifyUserVC.h"
#import "FindDocVC.h"
#import "HDNotificationView.h"
#import "docOPDNetworkEngine.h"
typedef enum{
    kTag_AlertWiFi =1,
}ALLTAGS;

@interface VerifyUserVC ()

@end

@implementation VerifyUserVC
@synthesize txtActiveField,TFVerificationCode;
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self setupErrorview];
     [self.navigationController setNavigationBarHidden:YES];
    userdef = userDefault;
    [self setpadding:self.TFVerificationCode];
    [self registerForKeyboardNotifications];
    keyboardHasAppeard = NO;
    if (![self.PushThrough isEqualToString:@"FamilyVerification"]) {
        self.backToFamilyBtn.hidden=YES;
//        [self.BtnSignIn setHidden:false];
//        [self.imgBack setHidden:false];
    }
    else{
        [self getOTP];
    }
    
        [Localytics tagEvent:@"Verify user"];
}

-(void)getOTP{
    [[docOPDNetworkEngine sharedInstance]ReSendUserVerificationAPI:self.mobNumber withCallback:^(NSDictionary *responseData) {
        
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"VerifyUserScreen"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"VerifyUserScreen"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hideKeyboard)];
    tap.numberOfTapsRequired = 1.0;
    [self.view addGestureRecognizer:tap];
}

-(void)setpadding: (UITextField*)textField{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor dOPDTFBorderColor].CGColor;
    [textField.layer addSublayer:bottomBorder];
    
}
- (IBAction)didVerifyUser:(id)sender {
     [Localytics tagEvent:@"VerifyUserSubmitButtonClick"];
    if (!isBtnTapped)
    {
        isBtnTapped = YES;
        BOOL isvalid=[self CheckForValidation];
        if (isvalid)
        {
            if ([AppDelegate MyappDelegate].isInternet){
                if ([self.PushThrough isEqualToString:@"FamilyVerification"]){
                      [[AppDelegate MyappDelegate] showIndicator];
                    [[docOPDNetworkEngine sharedInstance]VerifyUserAPI:self.TFVerificationCode.text MobileId:self.mobNumber withCallback:^(NSDictionary *responseData) {
                        
                        [[AppDelegate MyappDelegate] hideIndicator];
                        NSDictionary *resposeCode=[responseData objectForKey:@"VerifyStatus"];
                        NSString *message=[resposeCode objectForKey:@"Message"];
                        status=[[resposeCode objectForKey:@"Status"] integerValue];
                        
                        if (status == 0)
                        {
                            isBtnTapped = false;
                            [self ViewSlideDown:message];
                        }
                        else if (status == 1){
                            [self success:AppName detailMessage:message];
                            [self performSelector:@selector(backToFamilyAction:) withObject:nil afterDelay:3.5];
                        }

                    }];
                    
                }
                else{
                    [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.0000];
 
                }
                
            }else
            {
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"docOPD" message:@"It seems like your internet connection is not active, Please check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
                alert.tag = kTag_AlertWiFi;
                isBtnTapped = false;
                [alert show];
            }
        }
    }
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

-(void)GotoFindDocView{
//     NSLog(@"GotoFindDocView");
    FindDocVC *findDoc = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_FindDoc"];
    [self.navigationController pushViewController:findDoc animated:YES];
}

-(void)DismissAndGoFindDoctor{
    FindDocVC *findDoc = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_FindDoc"];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(dismissAndPush:)]) {
            [self.delegate performSelector:@selector(dismissAndPush:) withObject:findDoc];
        }
    }];
}

//- (void)dismissAndPush:(UIViewController *)vc {
//    [self dismissViewControllerAnimated:NO completion:^{
//        NSMutableArray *mutableControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//        NSArray *controllers = [mutableControllers arrayByAddingObject:vc];
//        [self.navigationController setViewControllers:controllers animated:NO];
//    }];
//    
//}


- (void)dismissAndPush:(UIViewController *)vc {
    [Localytics tagEvent:@"VerifyUserLoginClick"];
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)GoToLogin:(id)sender {
     [Localytics tagEvent:@"VerifyUserLoginClick"];
    isBtnTapped = false;
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - API Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kUserVerifyRequest], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.TFVerificationCode.text,Verificationcode,nil];
    
//    NSLog(@"dataDic for verify user: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kUserVerifyRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
    
    
}

#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    
    [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
    
    
//    NSLog(@"user verify Controller requestFinished");
}

#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response

{
//    NSLog(@"response = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    NSDictionary *resposeCode=[response objectForKey:@"VerifyStatus"];
    NSString *message=[resposeCode objectForKey:@"Message"];
    status=[[resposeCode objectForKey:@"Status"] integerValue];
    
    if (status == 0)
    {
//        NSLog(@"On the verify user Vc");
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"docOPD" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        isBtnTapped = false;
        [self ViewSlideDown:message];
    }
    else if (status == 1){
        if ([self.PushThrough isEqualToString:@"Register"]) {
            [userdef setObject:@"Yes" forKey:isLogin];
            [self GotoFindDocView];
        }else if([self.PushThrough isEqualToString:@"Login"]){
            [userdef setObject:@"Yes" forKey:isLogin];
            [self DismissAndGoFindDoctor];
        }
    }
    
}

- (void) requestError
{
//    NSLog(@"verify user error");
    isBtnTapped = false;
    [[AppDelegate MyappDelegate] hideIndicator];
    [self ViewSlideDown:@"Something went wrong"];
}

#pragma mark - Validation Method
-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    //NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
    if([self.TFVerificationCode.text isEqualToString:@""] && [self.TFVerificationCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
    {
        valid = NO;
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter validation code" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        
//        [alert show];
        [self ViewSlideDown:@"Please enter validation code"];
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

- (IBAction)backToFamilyAction:(id)sender {
    [Localytics tagEvent:@"VerifyUserMyFamilyClick"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
