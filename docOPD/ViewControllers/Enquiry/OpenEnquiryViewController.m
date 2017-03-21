//
//  OpenEnquiryViewController.m
//  docOPD
//
//  Created by Virinchi Software on 1/30/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "OpenEnquiryViewController.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "HDNotificationView.h"
#import "termsViewController.h"
#import "HHAlertView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "CKViewController.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>


@interface OpenEnquiryViewController ()
@property NSArray *item;
@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;
@property (nonatomic, strong)NSMutableArray *chosenImages;
@end

@implementation OpenEnquiryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    [docOPDNetworkEngine sharedInstance].familyArrayData=[[NSMutableArray alloc]init];
    [[docOPDNetworkEngine sharedInstance].familyArrayData removeAllObjects];

    self.chosenImages =[[NSMutableArray alloc]init];
    [docOPDNetworkEngine sharedInstance].familyDataActive=NO;
    
    self.userImgView.layer.cornerRadius = 80/2;
    self.userImgView.layer.masksToBounds = YES;
    
    self.holderView.layer.cornerRadius = 88/2;
    self.holderView.layer.borderWidth = 1.0;
    self.holderView.layer.borderColor = [UIColor dOPDThemeColor].CGColor;

    self.writeTxtLeadingConst.constant=90;
    self.writeTxtWTConst.constant=self.view.frame.size.width-100;
    self.titleLbl.text=[NSString stringWithFormat:@"Enquiry for %@",self.titleName];
    
    
    if ([self.comeFrom isEqualToString:@"pro"]) {
       procName = self.titleName;
    }else if ([self.comeFrom isEqualToString:@"Spec"]){
       specialiesName = self.titleName;
    }
    self.TFEnqFor.text = self.titleName;
    [self setupTextField:self.TFEnqFor];
    [self setupTextField:self.TFMobile];
    [self setupTextField:self.TFEmail];
    [self setupTextField:self.TFFullName];
    keyboardHasAppeard = NO;
    
    self.TVEnquiry.delegate = self;
    self.TVEnquiry.text = @"Write something about your problem";
    self.TVEnquiry.textColor = [UIColor lightGrayColor];

    
    self.textViewEmpty=YES;
//    self.TVEnquiry.delegate = self;
//    [self setupTextView:self.TVEnquiry];
    
    userdef = userDefault;
    dataArr=[[NSMutableArray alloc]init];
    self.TFFullName.text = [userdef objectForKey:Username];
    self.TFMobile.text = [userdef objectForKey:Mobile];
    
    if([[userdef objectForKey:EmailID]isEqualToString:@"NA"]){
        self.TFEmail.text = @"";
    }else{
        self.TFEmail.text = [userdef objectForKey:EmailID];
    }
    self.TFEnqFor.enabled =NO;
    
//    self.BtnSubmit.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
//    self.BtnSubmit.layer.cornerRadius = 5.0;
//    self.BtnSubmit.layer.borderWidth = 1.0;
    
    UIView *bottomBorderForview = [[UIView alloc] initWithFrame:CGRectMake(0, self.ViewCountry.frame.size.height - 1.0f, self.ViewCountry.frame.size.width, 1)];
    bottomBorderForview.backgroundColor = [UIColor dOPDTFBorderColor];
    [self.ViewCountry addSubview:bottomBorderForview];
    
    CGRect rect = self.Contentview.frame;
    rect.size.height = self.TFEnqFor.frame.origin.y + self.TFEnqFor.frame.size.height+40;
    self.Contentview.frame = rect;
    self.Scroller.contentSize = CGSizeMake(self.Scroller.frame.size.width, self.Contentview.frame.size.height);
    
   // [self setupErrorview];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.Scroller addGestureRecognizer:recognizer];
    [Localytics tagEvent:@"Open enquiry"];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self registerForKeyboardNotifications];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    imgIDInfo = [[NSMutableArray alloc]init];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"OpenEnquiryScreen"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
      [Localytics tagEvent:@"OpenEnquiryScreen"];
    
    
    if (![docOPDNetworkEngine sharedInstance].familyDataActive) {
        NSString *imgNamestr =@"MyProfileImage.png";
        NSString*userImgFile = [[AppDelegate MyappDelegate].dataPath stringByAppendingPathComponent:imgNamestr];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:userImgFile];
        if (fileExists) {
            self.userImgView.image  = [self getImage:imgNamestr];
        }else{
            self.userImgView.image  = [UIImage imageNamed:@"user.png"];
        }
        self.userNameLbl.text=[userdef valueForKey:Username];
        name = [userdef objectForKey:Username];
        mobileNumber = [userdef objectForKey:Mobile];
        emailId = [userdef objectForKey:EmailID];
        userID=[userdef objectForKey:User_id];
    }
    else{
        self.userNameLbl.text=[[[docOPDNetworkEngine sharedInstance].familyArrayData valueForKey:@"RelationName"]objectAtIndex:0];
        NSString *path=[[[docOPDNetworkEngine sharedInstance].familyArrayData valueForKey:@"RelationImage"]objectAtIndex:0];
        if ([path isKindOfClass:[NSNull class]]) {
            self.userImgView.image=[UIImage imageNamed:@"user"];
        }
        else{
            [self.userImgView sd_setImageWithURL:[NSURL URLWithString:path]
                                placeholderImage:[UIImage imageNamed:@""]];
            
        }
        self.userImgView.contentMode = UIViewContentModeScaleAspectFit;
        self.userImgView.clipsToBounds = YES;
        name=[[[docOPDNetworkEngine sharedInstance].familyArrayData valueForKey:@"RelationName"]objectAtIndex:0];
        mobileNumber=[[[docOPDNetworkEngine sharedInstance].familyArrayData valueForKey:@"RelationMobileNumber"]objectAtIndex:0];
        emailId=[[[docOPDNetworkEngine sharedInstance].familyArrayData valueForKey:@"RelationEmailId"]objectAtIndex:0];
        userID=[[[docOPDNetworkEngine sharedInstance].familyArrayData valueForKey:@"RelationUserId"]objectAtIndex:0];
        
    }

    
    
}
- (UIImage*)getImage: (NSString*)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    NSMutableString *dataPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:@"Media"];
    NSString *getImagePath = [dataPath stringByAppendingPathComponent:filename];
    //    NSLog(@"Get image path: %@",getImagePath);
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
    
}
- (void)touch
{
    [self.TFEmail resignFirstResponder];
    [self.TFMobile resignFirstResponder];
    [self.TFFullName resignFirstResponder];
    
}

- (IBAction)didPressSubmit:(id)sender {
//    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"send" ofType:@"mp3"];
//    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
//    self.audioPlayer= [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
//    [self.audioPlayer play];
//
     [Localytics tagEvent:@"OpenEnquirySubmitButtonClick"];

    if (!isEnquiryClicked) {
        isEnquiryClicked = YES;
//        BOOL isvalid=[self CheckForValidation];
//        if (isvalid)
//        {
            if ([AppDelegate MyappDelegate].isInternet)
            {
                isEnquiryClicked = YES;
//                NSLog(@"Valid data");
                 [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:.000];
                
             
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Either server is too busy or check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
                [alert show];
                
            }
       // }
    }
   // [self ViewSlideDown:@"Something went wrong."];
   
    
}

- (IBAction)didPressDismissBtn:(id)sender {
    [Localytics tagEvent:@"OpenEnquirySurgeryDocClick"];
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag==999) {
            [subview removeFromSuperview];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TextField Setup

-(void)setupTextField: (UITextField*)textField{
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor dOPDTFBorderColor].CGColor;
    [textField.layer addSublayer:bottomBorder];
    
}


#pragma mark - TextView Delegate


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textViewEmpty) {
        [textView setInputAccessoryView:[self inputAccessoryViews]];
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
        //   [self getPaddedFrameForTextView];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.textViewEmpty = NO;
    } else {
        self.textViewEmpty = YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.textViewEmpty) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Write something about your problem";
    }
    
    return YES;
}



//- (void) textViewDidChange:(UITextView *)textView
//{
//    if(![textView hasText]) {
//        self.textViewEmpty = YES;
//        [textView addSubview:placeholderLabel];
//        [UIView animateWithDuration:0.15 animations:^{
//            placeholderLabel.alpha = 1.0;
//        }];
//    } else if ([[textView subviews] containsObject:placeholderLabel]) {
//        self.textViewEmpty = NO;
//        [UIView animateWithDuration:0.15 animations:^{
//            placeholderLabel.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            [placeholderLabel removeFromSuperview];
//        }];
//    }
//}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (![textView hasText]) {
        self.textViewEmpty = YES;
        [textView addSubview:placeholderLabel];
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 1.0;
        }];
    }else {
        self.textViewEmpty = NO;
    }
}



#pragma mark - UITextView
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.textViewEmpty) {
        //[textField setInputAccessoryView:[self inputAccessoryViews]];
        textField.textColor = [UIColor dOPDTextFontColor];
        //   [self getPaddedFrameForTextView];
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)setupTextView:(UITextView*)textview{
    // you might have to play around a little with numbers in CGRectMake method
    // they work fine with my settings
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, textview.frame.size.width - 10.0, 34.0)];
    [placeholderLabel setText:@"Write something about your problem"];
    // placeholderLabel is instance variable retained by view controller
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    placeholderLabel.font = [UIFont systemFontOfSize:13.0];
    
    // textView is UITextView object you want add placeholder text to
    [textview addSubview:placeholderLabel];
    
    
                                                   
    
}


#pragma mark - Service Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"" Message:@"Your enquiry is \nbeing submitting"];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kSetEnquiry], keyRequestType,nil];
    
    
    NSMutableString *imgids = [[NSMutableString alloc]init];
    if ([imgIDInfo count]) {
        
        for (int j=0; j<[imgIDInfo count]; j++)
        {
            NSString *strBar = [imgIDInfo objectAtIndex:j];
            [imgids appendString:[NSString stringWithFormat:@"%@",strBar]];
            if (j != [imgIDInfo count]-1)
            {
                [imgids appendString:[NSString stringWithFormat:@","]];
            }
        }
        
        //        NSLog(@"Str result: %@",imgids);
        
    }

    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:name?name:@"",FullName,mobileNumber?mobileNumber:@"",Mobile,emailId?emailId:@"",EmailID,self.hospID?self.hospID:@"",HospitalID,self.doctorID?self.doctorID:@"",DoctorID,self.specID?self.specID:@"",SpecialityId,self.procedureID?self.procedureID:@"",ProcedureID,self.TVEnquiry.text,userComment,specialiesName?specialiesName:@"",doctorSpec,procName?procName:@"",procedureName,userID,User_id,nil];
    
//    NSLog(@"dataDic for ApiCalling for enquiry: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kSetEnquiry;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
    
}
-(void)sendimgtoserver:(NSMutableDictionary*)Dictionary{
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kUploadEnquiryImage], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[Dictionary objectForKey:ImgName],ImgName,[Dictionary objectForKey:base64],base64,[NSString stringWithFormat:@"%@",enquiryID],EnquiryId,nil];
    
    //    NSLog(@"dataDic for sendimgtoserver img upload: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kUploadEnquiryImage;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
    //    NSLog(@"sendimgtoserver");
    
}

-(void)ApiCallingForImgUpload{
    [[AppDelegate MyappDelegate] showIndicator];
    [self sendimgtoserver:[imginfo objectAtIndex:count]];
    count++;
    //    NSLog(@"ApiCallingForImgUpload");
}

#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    if (currentRequestType==kUploadEnquiryImage) {
        [self performSelector:@selector(resultForImgUpload:) withObject:responseData afterDelay:.000];
    }
    else if (currentRequestType==kSetEnquiry){
        [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];

    }
    
//    NSLog(@"doc booking view controller requestFinished");
}
#pragma mark - result methods for resultForImgUpload service
- (void) resultForImgUpload:(NSDictionary *)response

{
    //    NSLog(@"response = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    NSDictionary *resposeCode=[response objectForKey:@"ImageUploadStatus"];
    //    NSString *message=[resposeCode objectForKey:@"Message"];
    
    status=[[resposeCode objectForKey:@"Status"] integerValue];
    if (status==1) {
        NSString *ImageId=[resposeCode objectForKey:@"ImageId"];
        [imgIDInfo addObject:ImageId];
    }
    
    if (count<self.chosenImages.count) {
        [self ApiCallingForImgUpload];
    }
    else{
        [[AppDelegate MyappDelegate] hideIndicator];
        AudioServicesPlaySystemSound(1001);//0x450
        [self ViewSlideDown:@"Thank you for submitting your enquiry, We will get back to you soon."];
        //        NSLog(@"All images id: %@",imgIDInfo);
       // [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.000];
    }
    
}



#pragma mark - result methods for booking enquiry service
- (void) result:(NSDictionary *)response

{
//    NSLog(@"response for doc enq = %@",response);
    
    NSDictionary *resposeCode=[response objectForKey:@"Enquiry Status"];
    NSString *message=[resposeCode objectForKey:@"Message"];
    status=[[resposeCode objectForKey:@"Status"] integerValue];
    
    if (status == 0)
    {
         [[AppDelegate MyappDelegate] hideIndicator];
//        NSLog(@"On the doc enquiry Vc");
        isEnquiryClicked = false;
        if (!message) {
            [self ViewSlideDown:@"Something went wrong"];
        }else{
            [self ViewSlideDown:message];
        }
        
    }
    
    else if (status == 1){
         enquiryID=[resposeCode objectForKey:@"EnquiryId"];
        if ([self.chosenImages count]){
            [self performSelector:@selector(ImgToBase64) withObject:nil afterDelay:0.0];
        }
        else{
            [[AppDelegate MyappDelegate] hideIndicator];
            AudioServicesPlaySystemSound(1001);//0x450
            [self ViewSlideDown:@"Thank you for submitting your enquiry, We will get back to you soon."];
        }
//        NSLog(@"status message = %@",message);
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"DocOPD" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        isEnquiryClicked = false;
//        [alert show];
       
      //  self.enquiryBtn.backgroundColor=[UIColor colorWithRed:5/255.0f green:173/255.0f blue:152/255.0f alpha:0.5];
        
    }
    else if (status == 2)
    {
         [[AppDelegate MyappDelegate] hideIndicator];
        isEnquiryClicked = false;
         [self errorWithTitle:@"" detailMessage:message];
    }
    else if (status == 3){
         [[AppDelegate MyappDelegate] hideIndicator];
        isEnquiryClicked = false;
        [self errorWithTitle:@"" detailMessage:message];
        
    }
}
- (void)errorWithTitle:(NSString*)title detailMessage:(NSString*)detail {
    [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:title detail:detail cancelButton:nil Okbutton:nil];
}

- (void) requestError
{
    isEnquiryClicked = false;
//    NSLog(@"doc enquiry  ViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
    [self ViewSlideDown:@"Something went wrong"];
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
    if ((nil != activeField) && (keyboardHasAppeard == NO))
        [self.Scroller scrollRectToVisible:[self getPaddedFrameForView:activeField] animated:YES];
    
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

- (void) getPaddedFrameForTextView:(float)kbsize
{
    
    CGFloat tempy = self.TVEnquiry.frame.size.height;
    CGFloat tempx = self.TVEnquiry.frame.size.width;
    
    CGRect zoomRect = CGRectMake((tempx/2)-160, (tempy/2)-240, self.Scroller.frame.size.width, self.Scroller.frame.size.height);
    //    [self.ScrollView scrollRectToVisible:zoomRect animated:YES];
    //    [self.ScrollView setContentOffset:CGPointMake(0, kbsize+tempy) animated:YES];
    self.Scroller.contentInset = UIEdgeInsetsMake(0, 0, kbsize, 0);
    self.Scroller.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kbsize, 0);
    [self.Scroller scrollRectToVisible:CGRectMake((tempx/2)-160,  self.TVEnquiry.frame.origin.y +  self.TVEnquiry.frame.size.height/2.0 - self.Scroller.frame.size.height/2.0, self.Scroller.frame.size.width, self.Scroller.frame.size.height) animated:YES];
    
    
    
    //
    //    CGFloat padding = 5;
    //    CGRect frame = view.frame;
    //    frame.size.height += 2 * padding;
    //    frame.origin.y -= padding;
    //
    //    return frame;
}

#pragma mark private methods
- (CGRect) getPaddedFrameForView:(UIView *) view
{
    CGFloat padding = 5;
    CGRect frame = view.frame;
    frame.size.height += 2 * padding;
    frame.origin.y -= padding;
    
    return frame;
}
-(void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
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
    [self.view endEditing:YES];
}

#pragma mark - Validation Method
-(BOOL)CheckForValidation
{
    BOOL valid=YES;
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
//    
//    //Mobile number validation
//    NSString *phoneRegex =@"^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$";// @"^[789]\\d{9}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//    
//
//    
//    if(([self.TFFullName.text isEqualToString:@""]&& [self.TFFullName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
//    {
//        valid = NO;
//        [self.TFFullName becomeFirstResponder];
////        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Full Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
////        [alert show];
//        [self ViewSlideDown:@"Please Enter Full Name"];
//    }
//    else if((![phoneTest evaluateWithObject:self.TFMobile.text]) || (self.TFMobile.text.length!=10) || ([self.TFMobile.text isEqualToString:@""]&& [self.TFMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
//    {
//        valid = NO;
//        [self.TFMobile becomeFirstResponder];
////        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Valid Mobile Number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
////        [alert show];
//         [self ViewSlideDown:@"Please Enter Valid Mobile Number"];
//    }
//    
//    
//    else if(self.TFEmail.text.length>0){
//        if(![emailTest evaluateWithObject:self.TFEmail.text]){
//            valid = NO;
//            //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Valid Email ID" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            //        [alert show];
//            [self ViewSlideDown:@"Please Enter Valid Email ID"];
//        }
//    }
//
//    else
//    if (self.textViewEmpty){
//        valid = NO;
////        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please write something about your problem" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
////        [alert show];
//         [self ViewSlideDown:@"Please write something about your problem"];
//    }
    
    return valid;
}



#pragma mark - Setup Error View
-(void)setupErrorview{
    errorView = [[UIView alloc]init];
    errorView.frame  = CGRectMake(0, -84, [UIScreen mainScreen].bounds.size.width,84);
    [self.view addSubview:errorView];
    errorView.tag = 999;
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, (errorView.frame.size.height-20)/2, 30, 30)];
    icon.image = [UIImage imageNamed:@"round-logo-icon.png"];
    [errorView addSubview:icon];
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
    
    
    if (status==1) {
       [self performSelector:@selector(dismissController) withObject:nil afterDelay:3.0];
    }

}
-(void)dismissController{
   [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)didPressTnC:(id)sender {
   // [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:serverUrl@"terms-condition"]]];
  //  [[AppDelegate MyappDelegate]openURL:[NSURL URLWithString:[NSString stringWithFormat:serverUrl@"terms-condition"]]];
    termsViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_TnC"];
    tvc.headerTitleText = @"Terms and Conditions";
    tvc.fullURL = [NSString stringWithFormat:serverUrl@"terms-condition"];
    [self presentViewController:tvc animated:YES completion:nil];
}



#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //workingFrame.origin.x = 0;
    
    // NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [self.chosenImages addObject:image];
                
            } else {
                //                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:AppName message:@"Please select only image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            //            NSLog(@"Uknown asset type");
        }
    }
    
    // self.chosenImages = images.mutableCopy;
    [self makeViewForSelectedImage];
}

-(void)makeViewForSelectedImage{
    
    for (UIImageView *v in [self.viewImageHolder subviews]) {
        [v removeFromSuperview];
    }
    
    CGRect workingFrame = CGRectMake(0, 0, 45 , 45);
    
    if (self.chosenImages.count==0) {
        self.writeTOPConst.constant=19;
      //  self.writeTxtLeadingConst.constant=95;
       // self.writeTxtWTConst.constant=self.view.frame.size.width-100;
        [self.view layoutIfNeeded];
    }
    
    for (int i=0; i<self.chosenImages.count; i++)
    {
        
        NSInteger countArr=self.chosenImages.count;
        if (countArr>=1) {
           self.writeTOPConst.constant=51;
            [self.view layoutIfNeeded];
        }
        
        
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.frame = workingFrame;
        imageview.image = [self.chosenImages objectAtIndex:i];
        [self.viewImageHolder addSubview:imageview];
        
        [self displayImage:imageview withImage:imageview.image ImageCaption:@""];
        imageview.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
        imageview.layer.borderWidth = 0.5;
        
        UIButton* deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(workingFrame.origin.x+workingFrame.size.width-14,-2, 17, 17);
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"round-delete-button.png"] forState:UIControlStateNormal];
        deleteBtn.tag = i+999;
        [deleteBtn addTarget:self action:@selector(removeImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewImageHolder addSubview:deleteBtn];
        
        
        workingFrame.origin.x = workingFrame.origin.x + 50;
        
    }
    
}



-(void)removeImage:(UIButton*)sender{
    //    NSLog(@"%ld image tap",(long)sender.tag);
    [self.chosenImages removeObjectAtIndex:sender.tag-999];
    [self makeViewForSelectedImage];
}


- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)ImgToBase64{
    imginfo = [[NSMutableArray alloc]init];
    if ([self.chosenImages count])
    {
        for (int i=0; i<self.chosenImages.count; i++) {
            
            
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            NSString*base64str =  [self imageToNSString:[self.chosenImages objectAtIndex:i]];
            [dic setObject:base64str forKey:base64];
            [dic setObject:[NSString stringWithFormat:@"%@.png",[self timeInMiliSeconds] ]forKey:ImgName] ;
            [imginfo addObject:dic];
        }
        //    [self ApiCallingForImgUpload];
           [self performSelector:@selector(ApiCallingForImgUpload) withObject:nil afterDelay:0.0];
        
    }else{
         //[self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.0];
    }
    
    
}




- (NSString *) timeInMiliSeconds
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *currdate = [dateFormatter stringFromDate:date];
    
    NSDate *newdate = [dateFormatter dateFromString:currdate];
    
    NSString * timeInMS = [NSString stringWithFormat:@"%lld", [@(floor([newdate timeIntervalSince1970] * 1000)) longLongValue]];
    
    return timeInMS;
}



- (NSString *)imageToNSString:(UIImage *)image
{
    
    CGRect rect;
    if (image.size.height>=480)
    {
        float ratio = image.size.height/480;
        rect = CGRectMake(0,0,image.size.width/ratio,image.size.height/ratio);
        UIGraphicsBeginImageContext( rect.size );
        [image drawInRect:rect];
        UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageDataForResize = UIImageJPEGRepresentation(picture1,0.1);
        UIImage *img=[UIImage imageWithData:imageDataForResize];
        image = img;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
    
    NSString *base64EncodedString = [imageData base64EncodedStringWithOptions:0];
    return base64EncodedString;
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}



-(void)bottomBorderOnButton:(UIButton*)btn{
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height - 1.0f, btn.frame.size.width, 1)];
    bottomBorder.backgroundColor = [UIColor dOPDTFBorderColor];
    [btn addSubview:bottomBorder];
}



- (void)warning:(NSString*)title detailMessage:(NSString*)detail {
    [HHAlertView showAlertWithStyle:HHAlertStyleWarning inView:self.view Title:title detail:detail cancelButton:nil Okbutton:nil block:^(HHAlertButton buttonindex) {
        if (buttonindex == HHAlertButtonOk) {
            //            NSLog(@"ok Button is seleced use block");
            
        }
        else
        {
            //            NSLog(@"cancel Button is seleced use block");
            
        }
    }];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



#pragma mark - RNGRIDVIEW


#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    //    NSLog(@"Dismissed with item %d: %@", itemIndex, item.title);
    
    switch (itemIndex) {
        case 0:
            //            NSLog(@"case 0, Gallery, Opening gallery");
            [self imagePickFromGallery];
            break;
            
        case 1:
            //            NSLog(@"case 1");
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:@"Device has no camera"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles: nil];
                
                [myAlertView show];
            }else{
                [self imageCaptureByCamera];
            }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - Private

- (void)showGrid {
    //    [self.writeTXT resignFirstResponder];
    //    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 250, 0.0);
    //    self.Scroller.contentInset = contentInsets;
    NSInteger numberOfOptions = 2;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"photos"] title:@"Gallery"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera"] title:@"Camera"],
                       // [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"block"] title:@"Cancel"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}



-(void)imagePickFromGallery{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 2-[self.chosenImages count]; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
    
    
}


-(void)imageCaptureByCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if ([self.chosenImages count]==2) {
        [self errorWithTitle:@"" detailMessage:@"Only 2 images can add"];
    }
    else
        [self.chosenImages addObject:image];
    
    [self makeViewForSelectedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
    //[self ImgToBase64:image];
    
}
#pragma mark- Image Display
- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image  {
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setupImageViewer];
    imageView.clipsToBounds = YES;
}

- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image ImageCaption:(NSString*)caption  {
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    if ([caption isKindOfClass:[NSNull class]]) {
        caption = @"";
    }
    [imageView setupImageViewerWithText:caption?caption:@" "];
}

- (IBAction)attachmentAction:(id)sender {
    [activeField resignFirstResponder];
    [self showGrid];
}

- (IBAction)changeFamilyAction:(id)sender {
    [Localytics tagEvent:@"Family List"];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"RelationList"];
    dataArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if ([dataArr count]) {
        SelectFamilyVC *SelectFamilyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFamilyVC"];
        
        SelectFamilyVC.familyData=dataArr;
        [self presentViewController:SelectFamilyVC animated:YES completion:nil];
        
    }
    else{
        
        [Localytics tagEvent:@"Add Family"];
        AddFamilyVC* vc = [self.storyboard instantiateViewControllerWithIdentifier: @"AddFamilyVC"];
        [self.navigationController pushViewController:vc animated:YES];
        
//        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:AppName message:[NSString stringWithFormat:@"Please add family member" ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
    }

}
-(void)getData{
    [[docOPDNetworkEngine sharedInstance]GetRelationAPI:[userdef valueForKey:User_id] withCallback:^(NSDictionary *responseData) {
        NSInteger STATUS=[[responseData objectForKey:@"Status"] intValue];
        if (STATUS==1) {
            //dataArray =[NSMutableArray arrayWithArray:[responseData objectForKey:@"RelationList"]];
            SelectFamilyVC *SelectFamilyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFamilyVC"];
            SelectFamilyVC.familyData=[responseData objectForKey:@"RelationList"];
            [self presentViewController:SelectFamilyVC animated:YES completion:nil];
            
        }
        else{
        }
        
    }];
}

@end
