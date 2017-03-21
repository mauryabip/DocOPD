//
//  DocBookingViewController.m
//  docOPD
//
//  Created by Virinchi Software on 11/6/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//
typedef enum{
    kTAG_FullNameTF = 10,
    kTAG_MobileTF,
     kTAG_EmailTF,
    kTAG_AlertSuccess,
}ALL_TAGS;
#import "DocBookingViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "CKViewController.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "HHAlertView.h"
#import "HDNotificationView.h"
#import "termsViewController.h"
//#import "Base64.h"
//#import "ELCImagePickerDemoViewController.h"

@interface DocBookingViewController ()<UITextFieldDelegate,UITextViewDelegate>{

}
@property NSArray *item;
@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;
@property (nonatomic, strong)NSMutableArray *chosenImages;
@end

@implementation DocBookingViewController
@synthesize firstNameTextField, emailTextField, MobileNoTextField;
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self setupErrorview];
    
    self.writeLeadingConst.constant=90;
    self.writeWTConst.constant=self.view.frame.size.width-100;

    self.writeNoteTXT.delegate = self;
    self.writeNoteTXT.text = @"Write something about your problem";
    self.writeNoteTXT.textColor = [UIColor lightGrayColor];
    
     self.textViewEmpty = true;
    self.userImgView.layer.cornerRadius = 80/2;
    self.userImgView.layer.masksToBounds = YES;
    self.holderView.layer.cornerRadius = 88/2;
    self.holderView.layer.borderWidth = 1.0;
    self.holderView.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    
    [docOPDNetworkEngine sharedInstance].familyArrayData=[[NSMutableArray alloc]init];
    [[docOPDNetworkEngine sharedInstance].familyArrayData removeAllObjects];
    [docOPDNetworkEngine sharedInstance].familyDataActive=NO;
    
    isDateSelected = false;
    userdef = userDefault;
    dataArr=[[NSMutableArray alloc]init];
    self.chosenImages =[[NSMutableArray alloc]init];
    // self.item = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5"];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"UIFloatLabelTextField Example";
    self.Lbl1Num.layer.cornerRadius = self.Lbl1Num.frame.size.width/2;
//    NSLog(@"address lbl : %f",self.LblHosAddress.frame.origin.y);
    self.Lbl1Num.layer.masksToBounds = YES;
    self.Lbl2Num.layer.cornerRadius = self.Lbl2Num.frame.size.width/2;
    self.Lbl2Num.layer.masksToBounds = YES;
    self.Lbl3Num.layer.cornerRadius = self.Lbl3Num.frame.size.width/2;
    self.Lbl3Num.layer.masksToBounds = YES;
    self.LblHosAddress.numberOfLines = 0;
    self.LblDocDegree.text = docDegree;
    self.LblDocName.text = docname;
    self.LblDocSpec.text = docSpec;
    self.LblHosAddress.text = hosAdd;
    self.LblHosName.text = hosName;
    self.LblHosType.text = hosType;
//    NSLog(@"add %@",hosAdd);
    [self TextFormating:self.LblHosAddress];
    self.LblHosAddress.textAlignment = NSTextAlignmentLeft;
    self.LblHosAddress.lineBreakMode = NSLineBreakByWordWrapping;
    [self.LblHosAddress sizeToFit];
//    NSLog(@"address lbl : %f",self.LblHosAddress.frame.origin.y);
    self.imgDoc.layer.cornerRadius = self.imgDoc.layer.frame.size.width/2;
    self.imgDoc.layer.masksToBounds = YES;
    [self.imgDoc sd_setImageWithURL:[NSURL URLWithString:docImgUrl] placeholderImage:[UIImage imageNamed:@"doctor-96.png"] options:SDWebImageRefreshCached];
   // 
    
    self.ViewDocImgBorder.layer.cornerRadius = self.ViewDocImgBorder.layer.frame.size.width/2;
    self.ViewDocImgBorder.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    self.ViewDocImgBorder.layer.borderWidth = 2.0f;
    self.ImgHospital.layer.cornerRadius = self.ImgHospital.layer.frame.size.width/2;
    self.ImgHospital.layer.masksToBounds = YES;
    [self.ImgHospital sd_setImageWithURL:[NSURL URLWithString:HosImgURL] placeholderImage:[UIImage imageNamed:@"def-hospital.png"] options:SDWebImageRefreshCached];
  //  [self displayImage:self.ImgHospital withImage:self.ImgHospital.image];

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
    
    [self setupTextField:firstNameTextField];
    [self setupTextField:emailTextField];
    [self setupTextField:MobileNoTextField];
   
    
 
    
    [[UIFloatLabelTextField appearance] setBackgroundColor:[UIColor whiteColor]];
     firstNameTextField.delegate = self;
    firstNameTextField.tag = kTAG_FullNameTF;
    firstNameTextField.returnKeyType = UIReturnKeyNext;

    MobileNoTextField.delegate = self;
    MobileNoTextField.keyboardType = UIKeyboardTypeNumberPad;
    MobileNoTextField.tag = kTAG_MobileTF;
    MobileNoTextField.returnKeyType = UIReturnKeyNext;

    emailTextField.dismissKeyboardWhenClearingTextField = @YES;

    emailTextField.delegate = self;
    emailTextField.tag = kTAG_EmailTF;
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    CGRect infoVRect = self.viewinfoHolder.frame;
    infoVRect.size.height = self.LblNote.frame.size.height+self.LblNote.frame.origin.y;
    self.viewinfoHolder.frame = infoVRect;
    

    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.CountryView.frame.size.height - 1.0f, self.CountryView.frame.size.width, 1)];
    bottomBorder.backgroundColor = [UIColor dOPDTFBorderColor];
    [self.CountryView addSubview:bottomBorder];
    
    [self bottomBorderOnButton:self.BtnDate];
    [self bottomBorderOnButton:self.BtnTime];
    
    [self ScrollResize];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.Scroller addGestureRecognizer:recognizer];
    

}
-(void)viewDidAppear:(BOOL)animated{
    [self registerForKeyboardNotifications];
}

//-(void)viewWillAppear:(BOOL)animated{
//    
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    imgIDInfo = [[NSMutableArray alloc]init];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"DocBookingScreen"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"DocBookingScreen"];
    
    
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
    [self.MobileNoTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.firstNameTextField resignFirstResponder];
    
}




-(void)ScrollResize{
    /*
    CGRect ConVRect = self.ContentView.frame;
    ConVRect.size.height = self.viewinfoHolder.frame.size.height+self.viewinfoHolder.frame.origin.y;
    self.ContentView.frame = ConVRect;
    
    self.Scroller.contentSize = CGSizeMake(self.Scroller.frame.size.width, self.ContentView.frame.size.height);
     */
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 20, 0.0);
    self.Scroller.contentInset = contentInsets;

    
}

- (IBAction)GoToBack:(id)sender {
    [Localytics tagEvent:@"DocBookingSurgeryDocClick"];
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - UIResponder
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    if(![touch.view isMemberOfClass:[UITextField class]]) {
//        [touch.view endEditing:YES];
//    }
//}



- (IBAction)changeFamilyAction:(id)sender {
    [Localytics tagEvent:@"DocBookingSelectFamilyClick"];
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

-(void)DoctorDataName:(NSString*)Name DocSpecility:(NSString*)Speciality DoctorDegree:(NSString*)Degree DocImg:(NSString*)imgURL{
    docname = Name;
    docSpec = Speciality;
    docDegree = Degree;
    docImgUrl = imgURL;
}
-(void)HospitalDataName:(NSString*)Name HospitalType:(NSString*)type HospitalAddress:(NSString*)address HospitalImg:(NSString*)imgURL{
    hosName = Name;
    hosType = type;
    hosAdd = address;
    HosImgURL = imgURL;
}

#pragma mark - Lable Text Formating
-(void)TextFormating:(UILabel*)label{
    label.textColor = [UIColor dOPDTextFontColor];
    label.font = [UIFont systemFontOfSize:13];
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


#pragma mark Notification handlers
- (void)keyboardWasShown:(NSNotification*)notif
{
    NSDictionary* info = [notif userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
   // NSInteger oldKBSize =0;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.Scroller.contentInset = contentInsets;
    self.Scroller.scrollIndicatorInsets = contentInsets;
 
 //  if (!keyboardHasAppeard || oldKBSize) {
        CGRect rectFoot = self.viewFooter.frame;
        rectFoot.origin.y = [UIScreen mainScreen].bounds.size.height-kbSize.height-rectFoot.size.height;
        self.viewFooter.frame = rectFoot;
 //   }
  //  oldKBSize = kbSize.height;
    //scrolling the active field to visible area
    if ((nil != activeField) && (keyboardHasAppeard == NO))
        [self.Scroller scrollRectToVisible:[self getPaddedFrameForView:activeField] animated:YES];
    
    else if(keyboardHasAppeard == NO){
        [self getPaddedFrameForTextView:kbSize.height];
    }
    
    
    keyboardHasAppeard = YES;
}
- (void) getPaddedFrameForTextView:(float)kbsize
{
    
    CGFloat tempy = self.writeNoteTXT.frame.size.height;
    CGFloat tempx = self.writeNoteTXT.frame.size.width;
    
    self.Scroller.contentInset = UIEdgeInsetsMake(0, 0, kbsize, 0);
   // self.Scroller.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kbsize, 0);
    [self.Scroller scrollRectToVisible:CGRectMake((tempx/2)-160,  self.writeNoteTXT.frame.origin.y +  self.writeNoteTXT.frame.size.height/2.0 - self.Scroller.frame.size.height/2.0, self.Scroller.frame.size.width, self.Scroller.frame.size.height) animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)notif
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.Scroller.contentInset = UIEdgeInsetsZero;
    self.Scroller.scrollIndicatorInsets = UIEdgeInsetsZero;
    [UIView commitAnimations];
    
    if (keyboardHasAppeard) {
        CGRect rectFoot = self.viewFooter.frame;
        rectFoot.origin.y = [UIScreen mainScreen].bounds.size.height-rectFoot.size.height;
        self.viewFooter.frame = rectFoot;
    }
    
    keyboardHasAppeard = NO;
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




- (NSAttributedString *)DYAlertPickView:(DYAlertPickView *)pickerView
                            titleForRow:(NSInteger)row{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.item[row]];
    return str;
}
- (NSInteger)numberOfRowsInDYAlertPickerView:(DYAlertPickView *)pickerView {
    
    return self.item.count;
}
- (void)DYAlertPickView:(DYAlertPickView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
  
//    NSLog(@"%@ didConfirm", self.item[row]);
    
    [self.BtnTime setImage:nil forState:UIControlStateNormal];
    [self.BtnTime setTitle:self.item[row] forState:UIControlStateNormal];
    self.BtnTime.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.BtnTime.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.BtnTime setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    
    
}

- (void)DYAlertPickerViewDidClickCancelButton:(DYAlertPickView *)pickerView {
//    NSLog(@"Canceled");
}

- (void)DYAlertPickerViewDidClickSwitchButton:(DYAlertPickView *)pickerView switchButton:(UISwitch *)switchButton {
//    NSLog(@"switch:%@",(switchButton.isOn?@"On":@"Off"));
}


- (BOOL)DYAlertPickerViewStateOfSwitchButton {
    return YES;
}

- (IBAction)showAlertPickerView:(id)sender {
    
    if (isDateSelected) {
        
        self.item = [[NSArray alloc]init];
        NSString *time;
        if ([self.comeFrom isEqualToString:@"search"]) {
            time =[self.HospitalData valueForKey:[NSString stringWithFormat:@"Doc%@",[self GetDocAvailiblityForDay:weekday]]];
            if (!time) {
                time =[self.HospitalData valueForKey:[NSString stringWithFormat:@"%@",[self GetDocAvailiblityForDay:weekday]]];
            }
        }else if ([self.comeFrom isEqualToString:@"profile"])
        {
            time = [self.HospitalData valueForKey:[self GetDocAvailiblityForDay:weekday]];
        }
        NSRange range = [time rangeOfString:@","];
        if (range.location != NSNotFound)
        {
//           NSLog(@"found");
            self.item =[time componentsSeparatedByString:@","];

//            NSLog(@"Item array %@",self.item);
        }else{
            self.item = @[time];
        }

        DYAlertPickView *picker = [[DYAlertPickView alloc] initWithHeaderTitle:@"Choose Time" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm" switchButtonTitle:@"Don't ask me"];
        picker.delegate = self;
        picker.dataSource = self;
        [picker showAndSelectedIndex:0];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select a date first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
  
}

-(NSString*)stringForSelection:(DYAlertPickView*)pickerView stringForMatch:(NSInteger )row{
    NSString*selectedTime=self.BtnTime.titleLabel.text;
    return selectedTime;
    //[self.BtnTime setTitle:self.item[row];
}

- (IBAction)didPressChooseDate:(id)sender {
    [Localytics tagEvent:@"DocBookingDateChooseClick"];
    [self.BtnTime setTitle:@"Select Time"forState:UIControlStateNormal];
    [self.BtnTime.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    CKViewController *calendarview = [self.storyboard instantiateViewControllerWithIdentifier:@"calendar"];
    calendarview.delegate = self;
    calendarview.doctorname = docname;
    NSString *knownObject = @"Not Available";
    NSArray *temp = [self.HospitalData allKeysForObject:knownObject];
     NSLog(@"self.HospitalData  %@  %@",self.HospitalData,calendarview.NADay);
    calendarview.NADay = temp;
   
    [self presentViewController:calendarview animated:YES completion:nil];
    
}

-(void)selectedDate:(NSString*)Date weekDay:(NSInteger)Day{
//    NSLog(@"Thanks, your Selected date is : %@",Date);
    if (Date != nil) {
        isDateSelected = true;
//        NSLog(@"Enter in set date");
        //self.BtnDate.imageView.image = nil;
        //[self.BtnDate setImage:nil forState:UIControlStateNormal];
        [self.BtnDate setTitle:[NSString stringWithFormat:@"%@",Date] forState:UIControlStateNormal];
        self.BtnDate.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.BtnDate.titleLabel.textAlignment = NSTextAlignmentLeft;
       // [self.BtnDate setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        weekday = Day;
    }else {
//        NSLog(@"Date is null");
        isDateSelected =false;
    }
    if ([[self getDoctorAvailabletime]count]==1) {
            [self.BtnTime setTitle:[self.item objectAtIndex:0]forState:UIControlStateNormal];
    }
}

-(NSArray*)getDoctorAvailabletime{
    self.item = [[NSArray alloc]init];
    NSString *time;
    if ([self.comeFrom isEqualToString:@"search"]) {
        time =[self.HospitalData valueForKey:[NSString stringWithFormat:@"Doc%@",[self GetDocAvailiblityForDay:weekday]]];
        if (!time) {
            time =[self.HospitalData valueForKey:[NSString stringWithFormat:@"%@",[self GetDocAvailiblityForDay:weekday]]];
        }
    }else if ([self.comeFrom isEqualToString:@"profile"])
    {
        time = [self.HospitalData valueForKey:[self GetDocAvailiblityForDay:weekday]];
    }
    NSRange range = [time rangeOfString:@","];
    if (range.location != NSNotFound)
    {
//        NSLog(@"found");
        self.item =[time componentsSeparatedByString:@","];
        
//        NSLog(@"Item array %@",self.item);
    }else{
        self.item = @[time];
    }
    
    return self.item;
}



-(NSString*)GetDocAvailiblityForDay:(NSInteger)Weekday{
    
        NSString *Day;
        switch (Weekday) {
            case 1:
                Day = @"Sunday";
                break;
                
            case 2:
                Day = @"Monday";
                break;
                
            case 3:
                Day = @"Tuesday";
                break;
                
            case 4:
                Day = @"Wednesday";
                break;
                
            case 5:
                Day = @"Thursday";
                break;
                
            case 6:
                Day = @"Friday";
                break;
                
            case 7:
                Day = @"Saturday";
                break;
                
            default:
//                NSLog(@"Invalid Day");
                break;
        }
        return Day;

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


- (IBAction)didPressBookNow:(id)sender {
     [Localytics tagEvent:@"DocBookingSubmitButtonClick"];
    NSLog(@"BtnDate   %@",self.BtnDate.titleLabel.text);
     NSString *avail=[self.HospitalData objectForKey:@"Availibity"];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc]init];
    [dateformater setDateFormat:@"dd MMM YYYY"];
    NSString *date_String=[dateformater stringFromDate:[NSDate date]];
    
    NSComparisonResult result;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    
    result = [date_String compare:self.BtnDate.titleLabel.text]; // comparing two dates
    
    if(result==NSOrderedAscending)
        NSLog(@"today is less");
    else if(result==NSOrderedDescending)
        NSLog(@"newDate is less");
    else
        NSLog(@"Both dates are same");
    if ([avail isEqualToString:@"Close Today"] &&(result==NSOrderedSame)) {
        [self errorWithTitle:@"" detailMessage:@"Doctor is not available"];
    }
    else{
        if (!isBookNowClicked) {
            BOOL isvalid=[self CheckForValidation];
            if (isvalid)
            {
                if ([AppDelegate MyappDelegate].isInternet)
                {
                    isBookNowClicked = YES;
                    //                NSLog(@"Valid data");
                   // [self performSelector:@selector(ImgToBase64) withObject:nil afterDelay:0.0];
                    
                    [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.0];
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Either server is too busy or check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
                    [alert show];
                    
                }
            }
        }

    }
}


#pragma mark - Validation Method
-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
    
    //Mobile number validation
    NSString *phoneRegex =@"^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$";// @"^[789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    

    
    if(([self.BtnDate.titleLabel.text isEqualToString:@"Select Date"]&& [self.BtnDate.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Select Appointment Date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    else if(([self.BtnTime.titleLabel.text isEqualToString:@"Select Time"]&& [self.BtnTime.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Select Appointment Time" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
//    else if(([firstNameTextField.text isEqualToString:@""]&& [firstNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
//    {
//        valid = NO;
//        [firstNameTextField becomeFirstResponder];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Full Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
//    else if((![phoneTest evaluateWithObject:MobileNoTextField.text]) ||(MobileNoTextField.text.length!=10) || ([MobileNoTextField.text isEqualToString:@""]&& [MobileNoTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
//    {
//        valid = NO;
//        [MobileNoTextField becomeFirstResponder];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Valid Mobile Number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
    
//    else if([emailTextField.text isEqualToString:@""] && [emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
//    {
//        valid = NO;
//        [emailTextField becomeFirstResponder];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Email ID" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        
//        [alert show];
//    }
   else if ([emailTextField.text length]>0) {
       if(![emailTest evaluateWithObject:emailTextField.text]){
           valid = NO;
           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Valid Email ID" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
           [alert show];
       }
    }
    
    else if([self.writeNoteTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] && [self.writeNoteTXT.text isEqualToString:@"Write something about your problem"])
    {
           valid = NO;
           [self.writeNoteTXT becomeFirstResponder];
           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Write something about your problem" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
           
           [alert show];
        
    }
   
    
    return valid;
}



#pragma mark - API Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:@"Booking in progress..."];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kSetBooking], keyRequestType,nil];
    NSString *hosid= [self.HospitalData objectForKey:@"HospitalId"];
    
    NSString * dateString = self.BtnDate.titleLabel.text;
//    NSLog(@"Btn date: %@",dateString);
    dateString =[dateString stringByReplacingOccurrencesOfString:@"On " withString:@""];
//     NSLog(@"Booking date: %@",dateString);
    NSDateFormatter * myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"dd MMM yyyy"];
    NSDate * dateFromString = [myDateFormatter dateFromString:dateString];
    [myDateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *newDateString = [myDateFormatter stringFromDate:dateFromString];
//    NSLog(@"choosen date: %@",newDateString);
    dateString = [myDateFormatter stringFromDate:dateFromString];
//    NSLog(@"choosen date: %@",dateString);
    

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
    
//    NSMutableString *imgids= [[NSMutableString alloc]init];
//    for (NSObject * obj in imgIDInfo)
//    {
//        [imgids appendString:[obj description]];
//    }
    

    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",name],FullName,[NSString stringWithFormat:@"%@",mobileNumber],Mobile,[NSString stringWithFormat:@"%@",emailId],EmailID,[NSString stringWithFormat:@"%@",hosid],HospitalID,[NSString stringWithFormat:@"%@",dateString],BookingDate,[NSString stringWithFormat:@"%@",self.BtnTime.titleLabel.text],BookingTime,[NSString stringWithFormat:@"%@",self.docid],DoctorID,[NSString stringWithFormat:@"%@",imgids],imgIDS,[NSString stringWithFormat:@"%@",self.writeNoteTXT.text],appointmentReason,userID,User_id,nil];
    
//    NSLog(@"dataDic for ApiCalling for booking: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kSetBooking;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
    
}

-(void)sendimgtoserver:(NSMutableDictionary*)Dictionary{
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ksetImageBooking], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[Dictionary objectForKey:ImgName],ImgName,[Dictionary objectForKey:base64],base64,[NSString stringWithFormat:@"%@",bookingId],Booking_Id,nil];
    
//    NSLog(@"dataDic for sendimgtoserver img upload: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = ksetImageBooking;
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
    if (currentRequestType==ksetImageBooking) {
        [self performSelector:@selector(resultForImgUpload:) withObject:responseData afterDelay:.000];
    }
    else if (currentRequestType==kSetBooking){
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
        [self performSelector:@selector(GoToBack:) withObject:nil afterDelay:3.5];
//        NSLog(@"All images id: %@",imgIDInfo);
       // [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.000];
    }
    
}


#pragma mark - result methods for set booking service
- (void) result:(NSDictionary *)response

{
//    NSLog(@"response for booking appoitment = %@",response);
    
   // NSDictionary *resposeCode=[response objectForKey:@"Booking Status"];
    NSString *message=[response objectForKey:@"Message"];
    status=[[response objectForKey:@"Status"] integerValue];
    
    if (status == 0)
    {
        [[AppDelegate MyappDelegate] hideIndicator];

        isBookNowClicked = false;
        [self errorWithTitle:AppName detailMessage:message];
        
    }
    
    else if (status == 1){
        
       //"Booking Id" = 540;
         messageSuccess=[response objectForKey:@"Message"];
        bookingId=[response objectForKey:@"Booking Id"];
        if (self.chosenImages.count) {
            [self performSelector:@selector(ImgToBase64) withObject:nil afterDelay:0.0];
            
        }
        else{
            [[AppDelegate MyappDelegate] hideIndicator];
            [self success:AppName detailMessage:messageSuccess];
            [self performSelector:@selector(GoToBack:) withObject:nil afterDelay:3.5];
            
        }

        //isBookNowClicked = false;

       
        
    }
    
    else if (status == 3){
        [[AppDelegate MyappDelegate] hideIndicator];
        isBookNowClicked = false;
       
        [self warning:AppName detailMessage:message];
        
    }
    
    
}

- (void) requestError
{
    isBookNowClicked = false;
//    NSLog(@"booking ViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
     [self ViewSlideDown:@"Something went wrong"];
}


- (IBAction)launchController
{
    [activeField resignFirstResponder];
    [self showGrid];
    
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
       self.writeTOPConst.constant=25;
        [self.view layoutIfNeeded];
    }


    
    for (int i=0; i<self.chosenImages.count; i++)
    {
        NSInteger countArr=self.chosenImages.count;
        if (countArr>=1) {
            self.writeTOPConst.constant=53;
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
        deleteBtn.frame = CGRectMake(workingFrame.origin.x+workingFrame.size.width-14, -2, 17, 17);
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
      [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.0];
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
    if (alertView.tag==kTAG_AlertSuccess) {
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - TextField Setup
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField ==self.MobileNoTextField)
    {
        NSUInteger newLength = [self.MobileNoTextField.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    
    return YES;
}


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

-(void)bottomBorderOnButton:(UIButton*)btn{
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height - 1.0f, btn.frame.size.width, 1)];
    bottomBorder.backgroundColor = [UIColor dOPDTFBorderColor];
    [btn addSubview:bottomBorder];
}
- (IBAction)didPressTnC:(id)sender {
   // [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:serverUrl@"terms-condition"]]];
   // [[AppDelegate MyappDelegate]openURL:[NSURL URLWithString:[NSString stringWithFormat:serverUrl@"terms-condition"]]];
    termsViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_TnC"];
    tvc.headerTitleText = @"Terms and Conditions";
    tvc.fullURL = [NSString stringWithFormat:serverUrl@"terms-condition"];
    [self presentViewController:tvc animated:YES completion:nil];
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
 /*   [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
            for (UIView *subview in [errorView subviews]) {
                if (subview.tag ==99) {
                    [subview removeFromSuperview];
                }
            }

            if (status==1) {
                [self.navigationController popViewControllerAnimated:YES];
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
        [self performSelector:@selector(GoToBack:) withObject:nil afterDelay:3.0];
    }
    
    
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

//- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
//    if (longPress.state == UIGestureRecognizerStateBegan) {
//        [self showGridWithHeaderFromPoint:[longPress locationInView:self.ViewImgNameHolder]];
//    }
//}

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
//
//- (void)showImagesOnly {
//    NSInteger numberOfOptions = 5;
//    NSArray *images = @[
//                        [UIImage imageNamed:@"arrow"],
//                        [UIImage imageNamed:@"attachment"],
//                        [UIImage imageNamed:@"block"],
//                        [UIImage imageNamed:@"bluetooth"],
//                        [UIImage imageNamed:@"cube"],
//                        [UIImage imageNamed:@"download"],
//                        [UIImage imageNamed:@"enter"],
//                        [UIImage imageNamed:@"file"],
//                        [UIImage imageNamed:@"github"]
//                        ];
//    RNGridMenu *av = [[RNGridMenu alloc] initWithImages:[images subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
//    av.delegate = self;
//    [av showInViewController:self center:CGPointMake(self.ViewImgNameHolder.bounds.size.width/2.f, self.ViewImgNameHolder.bounds.size.height/2.f)];
//}

//- (void)showList {
//    NSInteger numberOfOptions = 5;
//    NSArray *options = @[
//                         @"Next",
//                         @"Attach",
//                         @"Cancel",
//                         @"Bluetooth",
//                         @"Deliver",
//                         @"Download",
//                         @"Enter",
//                         @"Source Code",
//                         @"Github"
//                         ];
//    RNGridMenu *av = [[RNGridMenu alloc] initWithTitles:[options subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
//    av.delegate = self;
//    //    av.itemTextAlignment = NSTextAlignmentLeft;
//    av.itemFont = [UIFont boldSystemFontOfSize:18];
//    av.itemSize = CGSizeMake(150, 55);
//    [av showInViewController:self center:CGPointMake(self.ViewImgNameHolder.bounds.size.width/2.f, self.ViewImgNameHolder.bounds.size.height/2.f)];
//}

- (void)showGrid {
    [self.writeNoteTXT resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 20, 0.0);
    self.Scroller.contentInset = contentInsets;
    
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



/*

- (void)showGridWithHeaderFromPoint:(CGPoint)point {
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"Attach"],
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"Bluetooth"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"Deliver"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"Download"],
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"Source Code"],
                       [RNGridMenuItem emptyItem]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.bounces = NO;
    av.animationDuration = 0.2;
    //av.blurExclusionPath = [UIBezierPath bezierPathWithOvalInRect:self.imgUser.frame];
    av.backgroundPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.f, 0.f, av.itemSize.width*3, av.itemSize.height*3)];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    header.text = @"Example Header";
    header.font = [UIFont boldSystemFontOfSize:18];
    header.backgroundColor = [UIColor clearColor];
    header.textColor = [UIColor whiteColor];
    header.textAlignment = NSTextAlignmentCenter;
    // av.headerView = header;
    
    [av showInViewController:self center:point];
}


*/


-(void)imagePickFromGallery{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 2-[self.chosenImages count]; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imagePickerController.delegate = self;
//    [self presentViewController:imagePickerController animated:YES completion:nil];
    
    
    
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
#pragma mark - UITextView

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




- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.textViewEmpty) {
        //  [textField setInputAccessoryView:[self inputAccessoryViews]];
        textField.textColor = [UIColor blackColor];
        //   [self getPaddedFrameForTextView];
    }
    
    return YES;
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
    [self.writeNoteTXT resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 20, 0.0);
    self.Scroller.contentInset = contentInsets;
    
    [self.view endEditing:YES];
}



@end
