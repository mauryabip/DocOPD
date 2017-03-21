//
//  ViewController.m
//  docOPD
//
//  Created by Ashutosh Kumar on 7/31/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "VerifyUserVC.h"
#import "FindDocVC.h"
#import "HDNotificationView.h"
#import "HomeVC.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize TFMobile,TFPassword;
@synthesize txtActiveField;
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self setupErrorview];
    [self.navigationController setNavigationBarHidden:YES];
    userdef =userDefault;
    self.LoginBtn.layer.cornerRadius = 2.0;
    self.LoginBtn.layer.masksToBounds = YES;
    if ([[userdef objectForKey:isLogin]isEqualToString:@"Yes"]) {
//        NSLog(@"User logged in");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeVC *HomeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        [self.navigationController pushViewController:HomeVC animated:NO];
//        FindDocVC *findDoc = [storyboard instantiateViewControllerWithIdentifier:@"docOPD_FindDoc"];
//        [self.navigationController pushViewController:findDoc animated:NO];
  
    }else{
//        TFMobile.layer.borderWidth=1.0;
//        TFMobile.layer.borderColor = [UIColor dOPDTFBorderColor].CGColor;
//        TFPassword.layer.borderWidth=1.0;
//        TFPassword.layer.borderColor = [UIColor dOPDTFBorderColor].CGColor;
//        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
//        self.TFPassword.leftView = paddingView;
//        self.TFPassword.leftViewMode = UITextFieldViewModeAlways;
//        UIView *userNamepaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
//        self.TFMobile.leftView = userNamepaddingView;
//        self.TFMobile.leftViewMode = UITextFieldViewModeAlways;
        [self setupTextField:self.TFMobile];
        [self setupTextField:self.TFPassword];
        [self scrollResize];
        [self registerForKeyboardNotifications];
        keyboardHasAppeard = NO;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    LoginBtnTapped = false;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"LoginScreen"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hideKeyboard)];
    tap.numberOfTapsRequired = 1.0;
    [self.view addGestureRecognizer:tap];
    [Localytics tagEvent:@"LoginScreen"];
}

#pragma mark - userLogin
- (IBAction)UserLogin:(id)sender {
    [Localytics tagEvent:@"LoginButtonClick"];
    if(!LoginBtnTapped)
    {
        LoginBtnTapped = YES;
        BOOL isvalid=[self CheckForValidation];
        if (isvalid)
        {
            if ([AppDelegate MyappDelegate].isInternet)
            {
                LoginBtnTapped = YES;
                [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.0];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Either server is too busy or check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
                LoginBtnTapped = false;
                //            alert.tag = kTAGWiFiAlert;
                [alert show];
                
                
            }
        }else{
            LoginBtnTapped = false;
        }
    }
}

- (IBAction)ResetPassword:(id)sender {
    
}

-(void)scrollResize{
    CGRect newframe = self.ContentView.frame;
    newframe.size.height = self.footerView.frame.origin.y + self.footerView.frame.size.height+5;
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
    
  //  [textField setInputAccessoryView:[self inputAccessoryViews]];
    txtActiveField= textField;
    if (keyboardHasAppeard)
        [self.Scroller scrollRectToVisible:[self getPaddedFrameForView:textField] animated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.Scroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Validation Method
-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    //NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];

     if((self.TFMobile.text.length!=10) || ([self.TFMobile.text isEqualToString:@""]&& [self.TFMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Valid Mobile Number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [self ViewSlideDown:@"Please Enter Valid Mobile Number"];
    }
    
    else if([self.TFPassword.text isEqualToString:@""] && [self.TFPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
    {
        valid = NO;
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [self ViewSlideDown:@"Please Enter Password"];
    }
    return valid;
}




#pragma mark - TextField Setup

-(void)setupTextField: (UITextField*)textField{
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
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
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
    [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Signin" Message:@"Please wait"];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kLoginRequest], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.TFMobile.text,Mobile,self.TFPassword.text,Password,nil];
    
//    NSLog(@"dataDic for Login: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kLoginRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
    
    
}

#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    
    [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
    
    
//    NSLog(@"Login Controller requestFinished");
}


#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response

{
//     NSLog(@"response = %@",response);
    
    if (currentRequestType==kLoginRequest) {
        NSDictionary *resposeCode=[response objectForKey:@"SignInStatus"];
        NSString *message=[resposeCode objectForKey:@"Message"];
        status=[[resposeCode objectForKey:@"Status"] integerValue];
        
        if (status == 0 || status == 3)
        {
          [[AppDelegate MyappDelegate] hideIndicator];
            LoginBtnTapped = false;
             [self ViewSlideDown:message];
        }
        else if (status == 2){
          [[AppDelegate MyappDelegate] hideIndicator];
            LoginBtnTapped = false;
            if (!([resposeCode objectForKey:@"Email_id"])||[[resposeCode objectForKey:@"Email_id"]isEqualToString:@""]||[[resposeCode objectForKey:@"Email_id"]isEqualToString:@"<null>"]||!([NSString stringWithFormat:@"%@",[resposeCode objectForKey:@"Email_id"]].length) ||[resposeCode objectForKey:@"Email_id"] == (id)[NSNull null] )
            {
                [userdef setObject:@"" forKey:EmailID];
            }
            
            else{
                [userdef setObject:[resposeCode objectForKey:@"Email_id"] forKey:EmailID];
            }
            
            if ([[resposeCode objectForKey:@"Gender"]isKindOfClass:[NSNull class]]) {
                [userdef setObject:@"" forKey:Gender];
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
            
            if ([[resposeCode objectForKey:@"DateOfBirth"]isKindOfClass:[NSNull class]]) {
                [userdef setObject:@"" forKey:UserDOB];
                //                NSLog(@"Gender is null");
            }else{
                [userdef setObject:[resposeCode objectForKey:@"DateOfBirth"] forKey:UserDOB];
            }
            if ([[resposeCode objectForKey:@"ReferenceCode"]isKindOfClass:[NSNull class]]) {
                [userdef setObject:@"" forKey:ReferenceCode];
                //                NSLog(@"Gender is null");
            }else{
                [userdef setObject:[resposeCode objectForKey:@"ReferenceCode"] forKey:ReferenceCode];
            }

            [userdef setObject:[resposeCode objectForKey:@"IsReferenced"] forKey:@"IsReferenced"];//IsReferenced

            [userdef synchronize];
//            NSLog(@"mobile=%@,Authkey=%@,UserName=%@,Email=%@",[userdef objectForKey:Mobile],[userdef objectForKey:AuthKey],[userdef objectForKey:Username],[userdef objectForKey:EmailID]);
            
            VerifyUserVC *userVerify = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_verifyUser"];
            userVerify.PushThrough = @"Login";
            userVerify.delegate= self;
            [self presentViewController:userVerify animated:YES completion:nil];
            
        }
        else if (status == 1){
//            NSLog(@"Login status1 message = %@",message);
            if (!([resposeCode objectForKey:@"Email_id"])||[[resposeCode objectForKey:@"Email_id"]isEqualToString:@""]||[[resposeCode objectForKey:@"Email_id"]isEqualToString:@"<null>"]||!([NSString stringWithFormat:@"%@",[resposeCode objectForKey:@"Email_id"]].length) ||[resposeCode objectForKey:@"Email_id"] == (id)[NSNull null] )
            {
                [userdef setObject:@"" forKey:EmailID];
            }
            
            else{
                [userdef setObject:[resposeCode objectForKey:@"Email_id"] forKey:EmailID];
            }
            
            if ([[resposeCode objectForKey:@"Gender"]isKindOfClass:[NSNull class]]) {
                  [userdef setObject:@"" forKey:Gender];
//                NSLog(@"Gender is null");
            }else{
                 [userdef setObject:[resposeCode objectForKey:@"Gender"] forKey:Gender];
            }
            if ([[resposeCode objectForKey:@"DateOfBirth"]isKindOfClass:[NSNull class]]) {
                [userdef setObject:@"" forKey:UserDOB];
                //                NSLog(@"Gender is null");
            }else{
                [userdef setObject:[resposeCode objectForKey:@"DateOfBirth"] forKey:UserDOB];
            }
            if ([[resposeCode objectForKey:@"ReferenceCode"]isKindOfClass:[NSNull class]]) {
                [userdef setObject:@"" forKey:ReferenceCode];
                //                NSLog(@"Gender is null");
            }else{
                [userdef setObject:[resposeCode objectForKey:@"ReferenceCode"] forKey:ReferenceCode];
            }
            
            [userdef setObject:[resposeCode objectForKey:@"Auth_key"] forKey:AuthKey];
            [userdef setObject:[resposeCode objectForKey:@"Mobile_no"] forKey:Mobile];
            [userdef setObject:[resposeCode objectForKey:@"User_id"] forKey:User_id];
            [userdef setObject:[resposeCode objectForKey:@"User_name"] forKey:Username];
            [userdef setObject:[resposeCode objectForKey:@"User_pic_URL"] forKey:userProfileImgUrl];
           // [userdef setObject:[resposeCode objectForKey:@"ReferenceCode"] forKey:ReferenceCode];
            [userdef setObject:[resposeCode objectForKey:@"IsReferenced"] forKey:@"IsReferenced"];//IsReferenced
            [userdef setObject:@"0" forKey:FolderID];
            [userdef setObject:@"0" forKey:medicalImgID];
            [userdef setObject:@"Yes" forKey:isLogin];
             [userdef setValue:@"0" forKey:isAllImgdownload];
            [userdef synchronize];
            
            
            NSURL *url = [NSURL URLWithString:[resposeCode objectForKey:@"User_pic_URL"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *savedImagePath = [[[AppDelegate MyappDelegate]dataPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"MyProfileImage.png"]];
            mediaPath = [NSString stringWithFormat:@"MyProfileImage.png"];
            [data writeToFile:savedImagePath atomically:NO];
            
            [self getdata];
            
            
          //  [self performSelector:@selector(GetDoctorList) withObject:nil afterDelay:.000];
        }
    }else if (currentRequestType==kGetDocList){
        NSMutableArray *resposeCode=[response objectForKey:@"DoctorList"];
        [AppDelegate MyappDelegate].allHospList = resposeCode;
//        NSLog(@"response from appdelegate = %@",[AppDelegate MyappDelegate].allDocList);
        [self performSelector:@selector(GetHospitalList) withObject:nil afterDelay:.000];
    }else if (currentRequestType==kGetHospitalList){
        NSMutableArray *resposeCode=[response objectForKey:@"HospitalList"];
        [AppDelegate MyappDelegate].allHospList = resposeCode;
//        NSLog(@"response from appdelegate = %@",[AppDelegate MyappDelegate].allHospList);
        [self performSelector:@selector(GetProcedureList) withObject:nil afterDelay:.000];
    }else if (currentRequestType==kGetProcedureList){
         [[AppDelegate MyappDelegate] hideIndicator];
        NSMutableArray *resposeCode=[response objectForKey:@"ProcedureList"];
        [AppDelegate MyappDelegate].allProcedureList = resposeCode;
//        NSLog(@"response from appdelegate = %@",[AppDelegate MyappDelegate].allProcedureList);
       // FindDocVC *findDoc = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_FindDoc"];
        HomeVC *HomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
         [userdef setObject:@"Yes" forKey:isLogin];
        [self.navigationController pushViewController:HomeVC animated:NO];
       
       // [self.navigationController pushViewController:findDoc animated:YES];
    }

}

- (void) requestError
{
    LoginBtnTapped = false;
//    NSLog(@"Login ViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
    [self ViewSlideDown:@"Something went wrong"];
}


#pragma mark - DismissAndPush
- (void)dismissAndPush:(UIViewController *)vc {
//    NSLog(@"login view controller");
     [self.navigationController pushViewController:vc animated:YES];
//    [self dismissViewControllerAnimated:NO completion:^{
//        NSMutableArray *mutableControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//        NSArray *controllers = [mutableControllers arrayByAddingObject:vc];
//        //[self.navigationController setViewControllers:controllers animated:NO];
//         [self.navigationController pushViewController:vc animated:YES];
  //  }];
    
}

#pragma mark - API Calling To Get Search List

-(void)GetDoctorList{
    //    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetDocList], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userdef objectForKey:AuthKey],AuthKey,nil];
    
//    NSLog(@"dataDic for Reg: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetDocList;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
    
    
}


-(void)GetHospitalList{
    //    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetHospitalList], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userdef objectForKey:AuthKey],AuthKey,nil];
    
//    NSLog(@"dataDic for Reg: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetHospitalList;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
}


-(void)GetProcedureList{
    //    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetProcedureList], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userdef objectForKey:AuthKey],AuthKey,nil];
    
//    NSLog(@"dataDic for Reg: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetProcedureList;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
}

-(void)PushToNextView{
    HomeVC *HomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    [userdef setObject:@"Yes" forKey:isLogin];
    [self.navigationController pushViewController:HomeVC animated:NO];
//    FindDocVC *findDoc = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_FindDoc"];
//    [userdef setObject:@"Yes" forKey:isLogin];
//    [self.navigationController pushViewController:findDoc animated:YES];
}


//#pragma mark - WebService Calls Response
//
//- (void) requestFinished:(NSDictionary * )responseData
//{
//    [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
//    NSLog(@"splash Controller requestFinished for %d",currentRequestType);
//}

#pragma mark - result methods for login service
//- (void) result:(NSDictionary *)response
//
//{
//    //NSLog(@"response = %@",response);
//    
//    NSLog(@"splash status1 message");
//    
//    
//    if (currentRequestType==kGetDocList) {
//        NSMutableArray *resposeCode=[response objectForKey:@"DoctorList"];
//        [AppDelegate MyappDelegate].allDocList = resposeCode;
//        NSLog(@"response from appdelegate = %@",[AppDelegate MyappDelegate].allDocList);
//        [self performSelector:@selector(GetHospitalList) withObject:nil afterDelay:.000];
//    }else if (currentRequestType==kGetHospitalList){
//        NSMutableArray *resposeCode=[response objectForKey:@"HospitalList"];
//        [AppDelegate MyappDelegate].allHospList = resposeCode;
//        NSLog(@"response from appdelegate = %@",[AppDelegate MyappDelegate].allHospList);
//        [self performSelector:@selector(GetProcedureList) withObject:nil afterDelay:.000];
//    }else if (currentRequestType==kGetProcedureList){
//        NSMutableArray *resposeCode=[response objectForKey:@"ProcedureList"];
//        [AppDelegate MyappDelegate].allProcedureList = resposeCode;
//        NSLog(@"response from appdelegate = %@",[AppDelegate MyappDelegate].allProcedureList);
//        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(skipToGetData) userInfo:nil repeats:NO];
//    }
//}
//
//
//
//- (void) requestError
//{
//    NSLog(@"RegisterViewController error");
//    [[AppDelegate MyappDelegate] hideIndicator];
//    [self skipToGetData];
//}



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
  /*  [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        errorView.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,84);
        errorView.backgroundColor = [UIColor dOPDThemeColor];
        UILabel *msg = [[UILabel alloc]initWithFrame:CGRectMake(40, (errorView.frame.size.height-30)/2, errorView.frame.size.width-40, 40)];
        msg.tag = 99;
        msg.text = Message;
        msg.numberOfLines =2;
        msg.textColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        msg.font = [UIFont systemFontOfSize:14.0];
        [errorView addSubview:msg];
        
    } completion:^(BOOL finished) {
     
        [UIView animateWithDuration:.5 delay:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            errorView.frame  = CGRectMake(0, -84, [UIScreen mainScreen].bounds.size.width,84);
            
        } completion:^(BOOL finished) {
            LoginBtnTapped = NO;
            for (UIView *subview in [errorView subviews]) {
                if (subview.tag ==99) {
                    [subview removeFromSuperview];
                }
            }
        }];
        
    }];*/

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
-(void)getdata{
    NSLog(@"%@",[userdef valueForKey:AuthKey]);
    [[docOPDNetworkEngine sharedInstance]GetSpecialistListAPI:[userdef valueForKey:AuthKey] withCallback:^(NSDictionary *responseData) {
        
        NSArray *arr=[responseData objectForKey:@"Specialist"];
        [userdef setObject:[NSKeyedArchiver archivedDataWithRootObject:arr] forKey:@"Specialist"];
        
        NSArray *arr1=[responseData objectForKey:@"HomeImage"];
        [userdef setObject:[NSKeyedArchiver archivedDataWithRootObject:arr1] forKey:@"HomeImage"];
        
        NSArray *NormalSpecialist=[responseData objectForKey:@"NormalSpecialist"];
        [userdef setObject:[NSKeyedArchiver archivedDataWithRootObject:NormalSpecialist] forKey:@"NormalSpecialist"];
        
        NSArray *HomeHealthTitle=[responseData objectForKey:@"HomeHealthTitle"];
        [userdef setObject:[NSKeyedArchiver archivedDataWithRootObject:HomeHealthTitle] forKey:@"HomeHealthTitle"];
        
        NSArray *FreeHealthTitle=[responseData objectForKey:@"FreeHealthTitle"];
        [userdef setObject:[NSKeyedArchiver archivedDataWithRootObject:FreeHealthTitle] forKey:@"FreeHealthTitle"];
        
        NSArray *EmergencyTitle=[responseData objectForKey:@"EmergencyTitle"];
        [userdef setObject:[NSKeyedArchiver archivedDataWithRootObject:EmergencyTitle] forKey:@"EmergencyTitle"];
        
        [userdef  synchronize];
        [self getData];
       
        
    }];
}

-(void)getData{
    [[docOPDNetworkEngine sharedInstance]GetRelationAPI:[userdef valueForKey:User_id] withCallback:^(NSDictionary *responseData) {
        NSInteger STATUS=[[responseData objectForKey:@"Status"] intValue];
        if (STATUS==1) {
            NSArray *EmergencyTitle=[responseData objectForKey:@"RelationList"];
            [userdef setObject:[NSKeyedArchiver archivedDataWithRootObject:EmergencyTitle] forKey:@"RelationList"];
            
            [userdef  synchronize];
            [[AppDelegate MyappDelegate] hideIndicator];
            [self PushToNextView];
            
        }
        else{
            [[AppDelegate MyappDelegate] hideIndicator];
            [self PushToNextView];
        }
        
    }];
}



@end
