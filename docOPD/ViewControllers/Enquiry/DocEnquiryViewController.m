//
//  DocEnquiryViewController.m
//  docOPD
//
//  Created by Virinchi Software on 11/10/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "DocEnquiryViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "UIFloatLabelTextField.h"
#import "HHAlertView.h"
#import "HDNotificationView.h"
#import "termsViewController.h"
#import "CKViewController.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>


typedef enum{
    kTAG_FullNameTF = 10,
    kTAG_MobileTF,
    kTAG_EmailTF,
    kTAG_AlertSuccess,
}ALL_TAGS;


@interface DocEnquiryViewController ()<UITextFieldDelegate>
{
    
    IBOutlet UIFloatLabelTextField *emailTextField;
    IBOutlet UIFloatLabelTextField *MobileNoTextField;
    IBOutlet UIFloatLabelTextField *firstNameTextField;
   
}
@property NSArray *item;
@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;
@property (nonatomic, strong)NSMutableArray *chosenImages;

@end

@implementation DocEnquiryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setupErrorview];
    self.ScrollView.scrollEnabled=YES;
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

    
    
    self.textViewEmpty = true;
    userdef = userDefault;
    dataArr=[[NSMutableArray alloc]init];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.Lbl1Num.layer.cornerRadius = self.Lbl1Num.frame.size.width/2;
    self.Lbl1Num.layer.masksToBounds = YES;
    
    self.Lbl2Num.layer.cornerRadius = self.Lbl2Num.frame.size.width/2;

    self.Lbl2Num.layer.masksToBounds = YES;
 
    self.TVComment.delegate = self;
    self.TVComment.text = @"Write something about your problem";
    self.TVComment.textColor = [UIColor lightGrayColor];

    [self TextFormating:self.LblHosAddress];
    
    
    docId =[self.doctorDic valueForKey:@"DoctorId"];
  
    self.LblDocDegree.text = [self.doctorDic valueForKey:@"DocDegree"];
    self.LblDocName.text = [self.doctorDic valueForKey:@"DocName"];
    self.LblDocSpec.text = [self.doctorDic valueForKey:@"DocSpec"];
   
    
    if ([self.comeFrom isEqualToString:@"profile"]) {
        hosAdd = [NSString stringWithFormat:@"%@",[self.hospitalDic valueForKey:@"HospitalAddressLine2"]];
    }else if([self.comeFrom isEqualToString:@"search"])
    {
       hosAdd = [NSString stringWithFormat:@"%@",[self.hospitalDic valueForKey:@"HospitalAddressline2"]];
    }
    else if([self.comeFrom isEqualToString:@"History"])
    {
        hosAdd = [NSString stringWithFormat:@"%@",[self.hospitalDic valueForKey:@"HospitalAddressLine2"]];
    }
    
    
    self.LblHosAddress.text =hosAdd;
    self.LblHosName.text = [self.hospitalDic valueForKey:@"HospitalName"];
    self.LblHosType.text = [self.hospitalDic valueForKey:@"HospitalType"];

//    NSLog(@"add %@",hosAdd);
    self.LblHosAddress.numberOfLines = 2;
    self.LblHosAddress.lineBreakMode = NSLineBreakByClipping;
   [self.LblHosAddress sizeToFit];
    

//    CGRect ModAddRect = self.LblHosAddress.frame;
//    ModAddRect.origin.y = NewAddressRect.origin.y;
//    self.LblHosAddress.frame = ModAddRect;
    
    self.imgDoc.layer.cornerRadius = self.imgDoc.layer.frame.size.width/2;
    self.imgDoc.layer.masksToBounds = YES;
    [self.imgDoc sd_setImageWithURL:[NSURL URLWithString:[self.doctorDic valueForKey:@"DocPicURL"]] placeholderImage:[UIImage imageNamed:@"doctor-96.png"] options:SDWebImageRefreshCached];
   // [self displayImage:self.imgDoc withImage:self.imgDoc.image];
    
    self.ViewDocImgBorder.layer.cornerRadius = self.ViewDocImgBorder.layer.frame.size.width/2;
    self.ViewDocImgBorder.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    self.ViewDocImgBorder.layer.borderWidth = 2.0f;
    self.ImgHospital.layer.cornerRadius = self.ImgHospital.layer.frame.size.width/2;
    self.ImgHospital.layer.masksToBounds = YES;
    [self.ImgHospital sd_setImageWithURL:[NSURL URLWithString:[self.hospitalDic valueForKey:@"HosPicURL"]] placeholderImage:[UIImage imageNamed:@"def-hospital.png"] options:SDWebImageRefreshCached];
   // [self displayImage:self.ImgHospital withImage:self.ImgHospital.image];
    
    self.ViewHosImgBorder.layer.cornerRadius = self.ViewHosImgBorder.layer.frame.size.height/2;
    self.ViewHosImgBorder.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    self.ViewHosImgBorder.layer.borderWidth = 2.0f;
    
    [self TextFormating:self.LblDocDegree];
    [self TextFormating:self.LblDocSpec];
    [self TextFormating:self.LblHosType];
  
    self.LblDocName.textColor = [UIColor dOPDThemeColor];
    self.LblDocName.font = [UIFont boldSystemFontOfSize:15.0];
    
    self.LblHosName.textColor = [UIColor dOPDBlueColor];
    self.LblHosName.font = [UIFont boldSystemFontOfSize:13.0];
    
    
    [[UIFloatLabelTextField appearance] setBackgroundColor:[UIColor whiteColor]];
    
   // firstNameTextField = [UIFloatLabelTextField new];
   // [firstNameTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    //firstNameTextField.floatLabelActiveColor = [UIColor orangeColor];
    firstNameTextField.placeholder = @"Full Name";
    firstNameTextField.delegate = self;
    //firstNameTextField.frame = FNameRect;
    firstNameTextField.tag = kTAG_FullNameTF;
   // firstNameTextField.font = [UIFont systemFontOfSize:13.0];
    firstNameTextField.returnKeyType = UIReturnKeyNext;
    firstNameTextField.text= [userdef objectForKey:Username];
    //[self.viewinfoHolder addSubview:firstNameTextField];
    

    MobileNoTextField.delegate = self;
    MobileNoTextField.text = [userdef objectForKey:Mobile];
   // MobileNoTextField.font = [UIFont systemFontOfSize:13.0];
    MobileNoTextField.keyboardType = UIKeyboardTypeNumberPad;
    MobileNoTextField.tag = kTAG_MobileTF;
    MobileNoTextField.returnKeyType = UIReturnKeyNext;
    //[self.viewinfoHolder addSubview:MobileNoTextField];
    

    emailTextField.dismissKeyboardWhenClearingTextField = @YES;
  //  emailTextField.font = [UIFont systemFontOfSize:13.0];
   // emailTextField.frame = emailRect;
    emailTextField.delegate = self;
    emailTextField.tag = kTAG_EmailTF;
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    emailTextField.text = [userdef objectForKey:EmailID];
   // [self.viewinfoHolder addSubview:emailTextField];
    
    [self setupTextField:firstNameTextField];
    [self setupTextField:MobileNoTextField];
    [self setupTextField:emailTextField];
    
    if ([self.comeFrom isEqualToString:@"History"]) {
        emailTextField.text = [self.enquiryData valueForKey:@"UserEmailid"];
        MobileNoTextField.text = [self.enquiryData valueForKey:@"UserMobno"];
        firstNameTextField.text = [self.enquiryData valueForKey:@"UserName"];
        self.TVComment.text = [self.enquiryData valueForKey:@"UserComment"];
        [self.BtnBack setImage:[UIImage imageNamed:@"white-cancel.png"] forState:UIControlStateNormal];
        self.BtnBack.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.viewFooter.hidden = YES;
        [self.TVComment setEditable:NO];
        self.TVComment.scrollEnabled = YES;
        [emailTextField setEnabled:NO];
        [firstNameTextField setEnabled:NO];
        [MobileNoTextField setEnabled:NO];
    }
    
    UIView *bottomBorderForview = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewCountry.frame.size.height - 1.0f, self.viewCountry.frame.size.width, 1)];
    bottomBorderForview.backgroundColor = [UIColor dOPDTFBorderColor];
    [self.viewCountry addSubview:bottomBorderForview];
    
    
    
    CGRect infoVRect = self.viewinfoHolder.frame;
    infoVRect.size.height = emailTextField.frame.size.height+emailTextField.frame.origin.y+10;
    self.viewinfoHolder.frame = infoVRect;

    
//    CGRect rect = self.Contentview.frame;
//    rect.size.height = self.viewinfoHolder.frame.origin.y + self.viewinfoHolder.frame.size.height+40;
//    self.Contentview.frame = rect;
//    
//    self.ScrollView.contentSize = CGSizeMake(self.ScrollView.frame.size.width, self.Contentview.frame.size.height);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        resulation = [[UIScreen mainScreen] bounds].size;
        
        if (resulation.height < 667) {
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 150, 0.0);
            self.ScrollView.contentInset = contentInsets;
        }
    }

   
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.ScrollView addGestureRecognizer:recognizer];
    
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    imgIDInfo = [[NSMutableArray alloc]init];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"DocEnquiryScreen"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
     [Localytics tagEvent:@"DocEnquiryScreen"];
    
    
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
        userID = [userdef objectForKey:User_id];
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


-(void)viewDidAppear:(BOOL)animated{
    [self registerForKeyboardNotifications];
}

- (void)touch
{
    [MobileNoTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    [firstNameTextField resignFirstResponder];
    
}

#pragma mark - UITextView//MobileNoTextField
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField ==MobileNoTextField)
    {
        NSUInteger newLength = [MobileNoTextField.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    
    return YES;
}


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

#pragma mark - UITextView


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.textViewEmpty) {
      //  [textField setInputAccessoryView:[self inputAccessoryViews]];
        textField.textColor = [UIColor blackColor];
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



#pragma mark - Lable Text Formating
-(void)TextFormating:(UILabel*)label{
    label.textColor = [UIColor dOPDTextFontColor];
    label.font = [UIFont systemFontOfSize:13];
}


#pragma mark Notification handlers
- (void)keyboardWasShown:(NSNotification*)notif
{
    NSDictionary* info = [notif userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // NSInteger oldKBSize =0;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.ScrollView.contentInset = contentInsets;
    self.ScrollView.scrollIndicatorInsets = contentInsets;
    
    //scrolling the active field to visible area
    if ((nil != activeField) && (keyboardHasAppeard == NO))//TVComment
        [self.ScrollView scrollRectToVisible:[self getPaddedFrameForView:activeField] animated:YES];
    else if(keyboardHasAppeard == NO){
        [self getPaddedFrameForTextView:kbSize.height];
//        NSLog(@"[self.ScrollView scrollRectToVisible:[self getPaddedFrameForTextView:self.TVComment] animated:YES]");
    }
    keyboardHasAppeard = YES;
}
- (IBAction)GoToBack:(id)sender {
    [Localytics tagEvent:@"DocEnquirySurgeryDocClick"];
    if ([self.comeFrom isEqualToString:@"History"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)notif
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.ScrollView.contentInset = UIEdgeInsetsZero;
    self.ScrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [UIView commitAnimations];
    
    keyboardHasAppeard = NO;
}

- (void) getPaddedFrameForTextView:(float)kbsize
{
   
    CGFloat tempy = self.TVComment.frame.size.height;
    CGFloat tempx = self.TVComment.frame.size.width;
    
    CGRect zoomRect = CGRectMake((tempx/2)-160, (tempy/2)-240, self.ScrollView.frame.size.width, self.ScrollView.frame.size.height);
//    [self.ScrollView scrollRectToVisible:zoomRect animated:YES];
//    [self.ScrollView setContentOffset:CGPointMake(0, kbsize+tempy) animated:YES];
    self.ScrollView.contentInset = UIEdgeInsetsMake(0, 0, kbsize, 0);
    self.ScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kbsize, 0);
    [self.ScrollView scrollRectToVisible:CGRectMake((tempx/2)-160,  self.TVComment.frame.origin.y +  self.TVComment.frame.size.height/2.0 - self.ScrollView.frame.size.height/2.0, self.ScrollView.frame.size.width, self.ScrollView.frame.size.height) animated:YES];
    
    
    
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
   // [self.view endEditing:YES];
    [self.TVComment resignFirstResponder];
    if (resulation.height < 667) {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 150, 0.0);
        self.ScrollView.contentInset = contentInsets;
    }

}

- (IBAction)didPressEnquiryButton:(id)sender {
  [Localytics tagEvent:@"DocEnquirySubmitButtonClick"];
    if (!isEnquiryClicked) {
//        BOOL isvalid=[self CheckForValidation];
//        if (isvalid)
//        {
            if ([AppDelegate MyappDelegate].isInternet)
            {
                isEnquiryClicked = YES;
//                NSLog(@"Valid data");
                [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.0];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Either server is too busy or check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
                [alert show];
                
            }
        //}
    }

    
    
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
//    if(([firstNameTextField.text isEqualToString:@""]&& [firstNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
//    {
//        valid = NO;
//        [firstNameTextField becomeFirstResponder];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Full Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
//    else if((![phoneTest evaluateWithObject:MobileNoTextField.text]) || (MobileNoTextField.text.length!=10) || ([MobileNoTextField.text isEqualToString:@""]&& [MobileNoTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]) )
//    {
//        valid = NO;
//        [MobileNoTextField becomeFirstResponder];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Valid Mobile Number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
//    
//    else if([emailTextField.text isEqualToString:@""] && [emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
//    {
//        valid = NO;
//        [emailTextField becomeFirstResponder];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Email ID" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        
//        [alert show];
//    }
//    else if(![emailTest evaluateWithObject:emailTextField.text]){
//        valid = NO;
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Valid Email ID" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
//    else
    
        if (self.textViewEmpty){
        valid = NO;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please write something about your problem" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    return valid;
}



#pragma mark - Service Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"" Message:@"Your query is \nbeing submitting"];
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

    
    NSString *hosid= [self.hospitalDic objectForKey:@"HospitalId"];
    NSString*docSpec = [self.doctorDic objectForKey:@"DocSpec"];
    if ([docSpec isEqualToString:@""]|| docSpec == nil || docSpec == (id)[NSNull null]) {
        docSpec = @"NA";
    }
    
    NSString*procName = [self.hospitalDic objectForKey:@"procedureName"];
    if ([procName isEqualToString:@""]|| procName == nil || procName == (id)[NSNull null]) {
        procName = @"NA";
    }
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:name?name:@"",FullName,mobileNumber?mobileNumber:@"",Mobile,emailId?emailId:@"",EmailID,hosid?hosid:@"",HospitalID,docId?docId:@"",DoctorID,self.TVComment.text?self.TVComment.text:@"",userComment,docSpec?docSpec:@"",doctorSpec,procName?procName:@"",procedureName,userID,User_id,nil];

    
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
        [self success:AppName detailMessage:messageSuccess];
        [self performSelector:@selector(GoToBack:) withObject:nil afterDelay:3.0];
       // AudioServicesPlaySystemSound(1001);//0x450
       // [self ViewSlideDown:@"Thank you for submitting your enquiry, We will get back to you soon."];
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
        //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"DocOPD" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        isEnquiryClicked = false;
        //[alert show];
        [self errorWithTitle:AppName detailMessage:message];
        
    }
    
    else if (status == 1){
        messageSuccess=[response objectForKey:@"Message"];

       
        enquiryID=[resposeCode objectForKey:@"EnquiryId"];
        if ([self.chosenImages count]){
            [self performSelector:@selector(ImgToBase64) withObject:nil afterDelay:0.0];
        }
        else{
            [[AppDelegate MyappDelegate] hideIndicator];
            [self success:AppName detailMessage:messageSuccess];
            [self performSelector:@selector(GoToBack:) withObject:nil afterDelay:3.0];

        }
        //alert.tag = kTAG_AlertSuccess;
        //[alert show];
       
        
    }
    else if (status == 3){
         [[AppDelegate MyappDelegate] hideIndicator];
        isEnquiryClicked = false;
        [self errorWithTitle:@"" detailMessage:message];
        
    }
}

- (void) requestError
{
    isEnquiryClicked = false;
//    NSLog(@"doc enquiry  ViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
    [self ViewSlideDown:@"Something went wrong"];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==kTAG_AlertSuccess) {
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)didPressTnC:(id)sender {
    //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:serverUrl@"terms-condition"]]];
    termsViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_TnC"];
    [Localytics tagEvent:@"Terms condition"];
    tvc.headerTitleText = @"Terms and Conditions";
    tvc.fullURL = [NSString stringWithFormat:serverUrl@"terms-condition"];
    [self presentViewController:tvc animated:YES completion:nil];
}

#pragma mark - TextField Setup

-(void)setupTextField: (UITextField*)textField{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor dOPDTFBorderColor].CGColor;
    [textField.layer addSublayer:bottomBorder];
    
}


#pragma mark - Setup Error View
-(void)setupErrorview{
    errorView = [[UIView alloc]init];
    errorView.frame  = CGRectMake(0, -84, [UIScreen mainScreen].bounds.size.width,84);
    [self.view addSubview:errorView];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, (errorView.frame.size.height-20)/2, 30, 30)];
    icon.image = [UIImage imageNamed:@"round-logo-icon.png"];
    [errorView addSubview:icon];
}

#pragma mark - No Network Slider

-(void)ViewSlideDown:(NSString*)Message{
  /*  [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        errorView.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,84);
        errorView.backgroundColor = [UIColor dOPDThemeColor];
        UILabel *msg = [[UILabel alloc]initWithFrame:CGRectMake(40, (errorView.frame.size.height-30)/2, errorView.frame.size.width-40, 40)];
        msg.text = Message;
        //        msg.textAlignment = NSTextAlignmentCenter;
        msg.numberOfLines =2;
        msg.tag= 99;
        //        msg.lineBreakMode = NSLineBreakByWordWrapping;
        //        [msg sizeToFit];
        msg.textColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        msg.font = [UIFont systemFontOfSize:14.0];
        [errorView addSubview:msg];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 delay:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            errorView.frame  = CGRectMake(0, -84, [UIScreen mainScreen].bounds.size.width,84);
            
        } completion:^(BOOL finished) {
            for (UIView *subview in [errorView subviews]) {
                if (subview.tag ==99) {
                    [subview removeFromSuperview];
                }
            }
            if (status==1) {
                [self dismissViewControllerAnimated:YES completion:nil];
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
    
    if (status==1) {
        [self performSelector:@selector(dismissController) withObject:nil afterDelay:3.0];
    }
    
}
-(void)dismissController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)errorWithTitle:(NSString*)title detailMessage:(NSString*)detail {
    [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:title detail:detail cancelButton:nil Okbutton:nil];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    
    CGRect workingFrame = CGRectMake(0, 4, 46 , 46);
    
    if (self.chosenImages.count==0) {
        self.writeTTOPConst.constant=25;
        [self.view layoutIfNeeded];
    }
    
    for (int i=0; i<self.chosenImages.count; i++)
    {
        
        NSInteger countArr=self.chosenImages.count;
        if (countArr>=1) {
            self.writeTTOPConst.constant=57;
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
        deleteBtn.frame = CGRectMake(workingFrame.origin.x+workingFrame.size.width-14, 0, 17, 17);
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
        // [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.0];
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
    [self.TVComment resignFirstResponder];
    if (resulation.height < 667) {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 150, 0.0);
        self.ScrollView.contentInset = contentInsets;
    }

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
    
    // [self ImgToBase64:image];
    
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
