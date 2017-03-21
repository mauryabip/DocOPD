//
//  RegisterVC.m
//  docOPD
//
//  Created by Ashutosh Kumar on 7/31/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "RegisterVC.h"
#import "VerifyUserVC.h"
#import "HDNotificationView.h"
typedef enum{
    kTAGWiFiAlert=10,
    kTAG_FullNameTF,
    kTAG_MobileTF,
    kTAG_EmailTF,
}ALLTAGS;

@interface RegisterVC ()

@end

@implementation RegisterVC
@synthesize TFFullName,TFEmail,TFMobile,TFpassword,BtnBack,BtnRegister;
@synthesize txtActiveField;
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self setupErrorview];
     [self.navigationController setNavigationBarHidden:YES];
//     NSLog(@"in reg View");
//    [self setpadding:TFFullName];
//    [self setpadding: TFEmail];
//    [self setpadding: TFMobile];
//    [self setpadding: TFpassword];
//    [self setBorderCorder:self.FullnameView];
//    [self setBorderCorder:self.EmailView];
    [self scrollResize];
    userdef = userDefault;
    [self registerForKeyboardNotifications];
    keyboardHasAppeard = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.BtnRegister.layer.cornerRadius = 2.0;
    self.BtnRegister.layer.masksToBounds = YES;

}


#pragma mark - TextField Setup

-(void)setpadding: (UITextField*)textField{
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
//    textField.leftView = paddingView;
//    textField.leftViewMode = UITextFieldViewModeAlways;
//    textField.layer.borderColor = [UIColor dOPDTFBorderColor].CGColor;
//    textField.layer.borderWidth = 1.0;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor dOPDTFBorderColor].CGColor;
    [textField.layer addSublayer:bottomBorder];

}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"SignUpScreen"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hideKeyboard)];
    tap.numberOfTapsRequired = 1.0;
    [self.view addGestureRecognizer:tap];
     [Localytics tagEvent:@"SignUpScreen"];
    
}



-(void)setBorderCorder: (UIView*)UIView{
    UIView.layer.borderColor = [UIColor dOPDTFBorderColor].CGColor;
    UIView.layer.borderWidth = 1.0;
    
}

#pragma mark - Go To Login view

- (IBAction)GoBack:(id)sender {
     [Localytics tagEvent:@"SignUpLoginClick"];
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Scroll Resizer
-(void)scrollResize{
    CGRect newframe = self.ContentView.frame;
    newframe.size.height = self.BtnTnc.frame.origin.y + self.BtnTnc.frame.size.height+5;
    self.ContentView.frame = newframe;
    self.Scroller.contentSize = CGSizeMake(self.Scroller.frame.size.width, self.ContentView.frame.size.height);
}



#pragma mark - TextField Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField ==self.TFMobile)
    {
        NSUInteger newLength = [self.TFMobile.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
   // [textField setInputAccessoryView:[self inputAccessoryViews]];
    txtActiveField= textField;
    
    if (keyboardHasAppeard)
        [self.Scroller scrollRectToVisible:[self getPaddedFrameForView:textField] animated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
     [self.Scroller setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}


#pragma mark - RegisterWithDocOPD

- (IBAction)didRegisterWithDocOPD:(id)sender {
     [Localytics tagEvent:@"SignUpSubmitClick"];
    if (!isRegisterClicked) {
        BOOL isvalid=[self CheckForValidation];
        if (isvalid)
        {
            if ([AppDelegate MyappDelegate].isInternet)
            {
                isRegisterClicked = YES;
                [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.0];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Either server is too busy or check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
                [alert show];
                
            }
        }else{
            isRegisterClicked = false;
        }
    }
}


#pragma mark - API Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please wait" Message:@"Signing Up"];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kSignUpRequest], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.TFFullName.text,FullName,self.TFpassword.text,Password,self.TFEmail.text,EmailID,self.TFMobile.text,Mobile,nil];

//    NSLog(@"dataDic for Reg: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kSignUpRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
    
    
}

#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
//    NSLog(@"Register Controller requestFinished");
}

#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response

{
//    NSLog(@"response = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    NSDictionary *resposeCode=[response objectForKey:@"SignUpStatus"];
    NSString *message=[resposeCode objectForKey:@"Message"];
    status=[[resposeCode objectForKey:@"Status"] integerValue];
    
    if (status == 0)
    {
//        NSLog(@"On the Register Vc");
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"docOPD" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        isRegisterClicked = false;
        [alert show];
    }
    else if (status == 1){
//        NSLog(@"Registeration status1 message = %@",message);
        if (!([resposeCode objectForKey:@"Email_id"])||[[resposeCode objectForKey:@"Email_id"]isEqualToString:@""])
        {
            [userdef setObject:@"" forKey:EmailID];
        }
        
        else{
            [userdef setObject:[resposeCode objectForKey:@"Email_id"] forKey:EmailID];
        }
        
        if ([[resposeCode objectForKey:@"Gender"]isKindOfClass:[NSNull class]]) {
            [userdef setObject:@"" forKey:Gender];
//            NSLog(@"Gender is null");
        }else{
            [userdef setObject:[resposeCode objectForKey:@"Gender"] forKey:Gender];
        }

        
        [userdef setObject:[resposeCode objectForKey:@"Auth_key"] forKey:AuthKey];
        [userdef setObject:[resposeCode objectForKey:@"Mobile_no"] forKey:Mobile];
        [userdef setObject:[resposeCode objectForKey:@"User_id"] forKey:User_id];
        [userdef setObject:[resposeCode objectForKey:@"User_name"] forKey:Username];
        [userdef setObject:@"0" forKey:FolderID];
        [userdef setObject:@"0" forKey:medicalImgID];
         [userdef setValue:@"0" forKey:isAllImgdownload];
        [userdef synchronize];
//        NSLog(@"mobile=%@,Authkey=%@,UserName=%@,Email=%@",[userdef objectForKey:Mobile],[userdef objectForKey:AuthKey],[userdef objectForKey:Username],[userdef objectForKey:EmailID]);
        VerifyUserVC *userVerify = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_verifyUser"];
        userVerify.PushThrough = @"Register";
        [self.navigationController pushViewController:userVerify animated:YES];
 
    }
    
}

- (void) requestError
{
//    NSLog(@"RegisterViewController error");
    isRegisterClicked = false;
    [[AppDelegate MyappDelegate] hideIndicator];
    [self ViewSlideDown:@"Something went wrong"];
}

#pragma mark - Validation Method
-(BOOL)CheckForValidation
{
    isRegisterClicked = YES;
    BOOL valid=YES;
        //NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
    if([self.TFFullName.text isEqualToString:@""] && [self.TFFullName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
    {
        valid = NO;
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Full Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        
//        [alert show];
        [self ViewSlideDown:@"Please Enter Full Name"];
        
    }
    
    else if((self.TFMobile.text.length!=10) || ([self.TFMobile.text isEqualToString:@""]&& [self.TFMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Valid Mobile Number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [self ViewSlideDown:@"Please Enter Valid Mobile Number"];
    }
    
    else if([self.TFpassword.text isEqualToString:@""] && [self.TFpassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
    {
        valid = NO;
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        
//        [alert show];
        
        [self ViewSlideDown:@"Please Enter Password"];
    }
    
    else if(self.TFEmail.text.length>0)
    {
        if (![self validateEmail:self.TFEmail.text]) {
            valid = NO;
            
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Valid Email ID" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [self ViewSlideDown:@"Please Enter Valid Email ID"];
        }
        
    }
    

    return valid;
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
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
   /* [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        errorView.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,84);
        errorView.backgroundColor = [UIColor dOPDThemeColor];
        UILabel *msg = [[UILabel alloc]initWithFrame:CGRectMake(40, (errorView.frame.size.height-30)/2, errorView.frame.size.width-40, 40)];
        msg.text = Message;
        msg.tag = 99;
        //        msg.textAlignment = NSTextAlignmentCenter;
        msg.numberOfLines =2;
        //        msg.lineBreakMode = NSLineBreakByWordWrapping;
        //        [msg sizeToFit];
        msg.textColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        msg.font = [UIFont systemFontOfSize:14.0];
        [errorView addSubview:msg];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 delay:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            errorView.frame  = CGRectMake(0, -84, [UIScreen mainScreen].bounds.size.width,84);
            
        } completion:^(BOOL finished) {
            isRegisterClicked = NO;
            for (UIView *subview in [errorView subviews]) {
                if (subview.tag ==99) {
                    [subview removeFromSuperview];
                }
            }
        }];
        
    }];*/


    /// Show notification view
    [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"icon.png"]
                                                title:AppName
                                              message:Message
                                           isAutoHide:YES
                                              onTouch:^{
                                                  
                                                  /// On touch handle. You can hide notification view or do something
                                                  [HDNotificationView hideNotificationViewOnComplete:nil];
                                              }];



}

- (IBAction)didPressTerms:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:serverUrl@"terms-condition"]]];
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
