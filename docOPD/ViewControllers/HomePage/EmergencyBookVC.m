//
//  EmergencyBookVC.m
//  docOPD
//
//  Created by Virinchi Software on 02/11/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "EmergencyBookVC.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "CKViewController.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "HHAlertView.h"
#import "HDNotificationView.h"
#import "termsViewController.h"

@interface EmergencyBookVC ()

@property NSArray *item;
@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;
@property (nonatomic, strong)NSMutableArray *chosenImages;

@end

@implementation EmergencyBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLbl.text=self.screenName;
    [docOPDNetworkEngine sharedInstance].familyArrayData=[[NSMutableArray alloc]init];
    [[docOPDNetworkEngine sharedInstance].familyArrayData removeAllObjects];
    self.textViewEmpty = true;
    userdef=userDefault;
    dataArr=[[NSMutableArray alloc]init];
    self.chosenImages =[[NSMutableArray alloc]init];
    [docOPDNetworkEngine sharedInstance].familyDataActive=NO;
    self.writeTxtLeadingConst.constant=90;
    self.writeTxtWTConst.constant=self.view.frame.size.width-100;
    
    self.userImgView.layer.cornerRadius = 80/2;
    self.userImgView.layer.masksToBounds = YES;
    
    self.borderView.layer.cornerRadius = 88/2;
    self.borderView.layer.borderWidth = 1.0;
    self.borderView.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    
    self.writeTXT.delegate = self;
    self.writeTXT.text = @"Write something about your problem";
    self.writeTXT.textColor = [UIColor lightGrayColor];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer];
    
    
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];//NSGregorianCalendar
    NSDate * currentDate = [NSDate date];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setHour: 1];
    NSDate * maxTime = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"hh:mm a"];
    self.dateLbl.text=[NSString stringWithFormat:@"Today, at %@",[formatter1 stringFromDate:maxTime]];
    
    NSDateFormatter *formatter2=[[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"dd-MM-yyyy hh:mm a"];
    dateString=[NSString stringWithFormat:@"%@",[formatter2 stringFromDate:maxTime]];

    // Do any additional setup after loading the view.
}
-(void)touch{
    [self.view endEditing:YES];
//    [self.writeTXT resignFirstResponder];
//    [self.addressTXT resignFirstResponder];
//    [self.pinTXT resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
   // imgIDInfo = [[NSMutableArray alloc]init];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"EmergencyBookingScreen"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"EmergencyBookingScreen"];
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
        gender=[userdef objectForKey:Gender];
        Age=[userdef objectForKey:UserDOB];
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
        gender=[[[docOPDNetworkEngine sharedInstance].familyArrayData valueForKey:@"RelationGender"]objectAtIndex:0];
        Age=[[[docOPDNetworkEngine sharedInstance].familyArrayData valueForKey:@"RelationDOB"]objectAtIndex:0];

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



#pragma mark - Lable Text Formating
-(void)TextFormating:(UILabel*)label{
    label.textColor = [UIColor dOPDTextFontColor];
    label.font = [UIFont systemFontOfSize:13];
}


-(void)pickDateMethod{
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDateAndTime;
    
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDate * currentDate = [NSDate date];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setHour: 1];
    NSDate * maxTime = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    [datePicker setMinimumDate: maxTime];
    
    
    [self.dateTXT setInputView:datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setTintColor:[UIColor dOPDThemeColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.dateTXT setInputAccessoryView:toolBar];
    
}
-(void)ShowSelectedDate
{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"hh:mm a"];
    NSDate * currentDate = [NSDate date];
    NSDateFormatter *currentformatter = [[NSDateFormatter alloc] init];
    [currentformatter setDateFormat:@"dd-MMM-yyyy"];
    
    NSDateFormatter *formatter2=[[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"dd-MM-yyyy hh:mm a"];
    dateString=[NSString stringWithFormat:@"%@",[formatter2 stringFromDate:datePicker.date]];
    
    NSString *currDate = [currentformatter stringFromDate:currentDate];
    if ([currDate isEqualToString:[formatter stringFromDate:datePicker.date]]) {
        self.dateLbl.text=[NSString stringWithFormat:@"Today, at %@",[formatter1 stringFromDate:datePicker.date]];
    }
    else
        self.dateLbl.text=[NSString stringWithFormat:@"%@, at %@",[formatter stringFromDate:datePicker.date],[formatter1 stringFromDate:datePicker.date]];
    // self.timeLbl.text=[NSString stringWithFormat:@"at %@",[formatter1 stringFromDate:datePicker.date]];
    [self.dateTXT resignFirstResponder];
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 250, 0.0);
//    self.scrollView.contentInset = contentInsets;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textViewEmpty) {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 250, 0.0);
        self.scrollView.contentInset = contentInsets;

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

#pragma mark UITextFieldDelegate methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField ==self.pinTXT)
    {
        NSUInteger newLength = [self.pinTXT.text length] + [string length] - range.length;
        return newLength <= 6;
    }
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    [textField resignFirstResponder];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField==self.dateTXT) {
        [self pickDateMethod];
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 216, 0.0);
    self.scrollView.contentInset = contentInsets;
    activeField = textField;
    self.navigationItem.rightBarButtonItem = nil;
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.scrollView.contentInset = contentInsets;
    
    activeField = nil;
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
  //  [self.writeTXT resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;

    [self.view endEditing:YES];
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

-(void)viewDidAppear:(BOOL)animated{
    [self registerForKeyboardNotifications];
}
#pragma mark Notification handlers
- (void)keyboardWasShown:(NSNotification*)notif
{
    NSDictionary* info = [notif userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // NSInteger oldKBSize =0;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
   
    if ((nil != activeField) && (keyboardHasAppeard == NO))
        [self.scrollView scrollRectToVisible:[self getPaddedFrameForView:activeField] animated:YES];
    
    else if(keyboardHasAppeard == NO){
        [self getPaddedFrameForTextView:kbSize.height];
    }
    
    
    keyboardHasAppeard = YES;
}
- (void) getPaddedFrameForTextView:(float)kbsize
{
    
    CGFloat tempy = self.writeTXT.frame.size.height;
    CGFloat tempx = self.writeTXT.frame.size.width;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, kbsize+100, 0);
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kbsize, 0);
    [self.scrollView scrollRectToVisible:CGRectMake((tempx/2)-160,  self.writeTXT.frame.origin.y +  self.writeTXT.frame.size.height/2.0 - self.scrollView.frame.size.height/2.0, self.scrollView.frame.size.width, 216) animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)notif
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [UIView commitAnimations];
    
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
    
    for (UIImageView *v in [self.imageHolderView subviews]) {
        [v removeFromSuperview];
    }
    
    CGRect workingFrame = CGRectMake(0, 4, 46 , 46);
    
    if (self.chosenImages.count==0) {
        self.writeTOPConst.constant=30;
        [self.view layoutIfNeeded];
    }
    
    for (int i=0; i<self.chosenImages.count; i++)
    {
        
        NSInteger countArr=self.chosenImages.count;
        if (countArr>=1) {
            self.writeTOPConst.constant=58;
            [self.view layoutIfNeeded];
        }
        
        
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.frame = workingFrame;
        imageview.image = [self.chosenImages objectAtIndex:i];
        [self.imageHolderView addSubview:imageview];
        
        [self displayImage:imageview withImage:imageview.image ImageCaption:@""];
        imageview.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
        imageview.layer.borderWidth = 0.5;
        
        UIButton* deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(workingFrame.origin.x+workingFrame.size.width-14, 0, 17, 17);
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"round-delete-button.png"] forState:UIControlStateNormal];
        deleteBtn.tag = i+999;
        [deleteBtn addTarget:self action:@selector(removeImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageHolderView addSubview:deleteBtn];
        
        
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



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

}



-(void)setupTextField: (UITextField*)textField{
    
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
    
    [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"icon.png"]
                                                title:AppName
                                              message:Message
                                           isAutoHide:YES
                                              onTouch:^{
                                                  
                                                  /// On touch handle. You can hide notification view or do something
                                                  [HDNotificationView hideNotificationViewOnComplete:nil];
                                              }];
    if (status==1) {
        [self performSelector:@selector(backAction:) withObject:nil afterDelay:3.0];
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
    
    // [self ImgToBase64:image];
    
}




- (IBAction)bookAction:(id)sender {
    [Localytics tagEvent:@"EmergencyBookingSubmitClick"];
    if (!isBookNowClicked) {
        BOOL isvalid=[self CheckForValidation];
        if (isvalid)
        {
            if ([AppDelegate MyappDelegate].isInternet)
            {
                isBookNowClicked=YES;
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


- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Validation Method
-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    
    if(([self.dateLbl.text isEqualToString:@""]&& [self.dateLbl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Date and Time" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
//    else if (self.textViewEmpty){
//        valid = NO;
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please write something about your problem" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
//    
    
    return valid;
}

#pragma mark - API Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:@"Booking in progress..."];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kSetFreeHealthServices], keyRequestType,nil];
    
    
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
    NSDate *birthday =[[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss a";
    birthday = [ dateFormatter dateFromString:Age];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",name],FullName,[NSString stringWithFormat:@"%@",mobileNumber],Mobile,[NSString stringWithFormat:@"%@",emailId],EmailID,[NSString stringWithFormat:@"%@",self.addressTXT.text],@"location",[NSString stringWithFormat:@"%@",self.pinTXT.text],@"PinNumber",[NSString stringWithFormat:@"%@",self.titleName],@"TypeName",[NSString stringWithFormat:@"%ld",(long)age],@"Age",[NSString stringWithFormat:@"%@",gender],Gender,[NSString stringWithFormat:@"%@",dateString],BookingDate,[NSString stringWithFormat:@"%@",userID],User_id,[NSString stringWithFormat:@"%@",self.writeTXT.text],appointmentReason,@"",@"LabTitleId",nil];
    
    //    NSLog(@"dataDic for ApiCalling for booking: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kSetFreeHealthServices;//kSetFreeHealthServices
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
    //    NSLog(@"APICalling");
    
}

-(void)sendimgtoserver:(NSMutableDictionary*)Dictionary{
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kSetServiceImage], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[Dictionary objectForKey:ImgName],ImgName,[Dictionary objectForKey:base64],base64,serviceID,@"ServiceId",userID,User_id,nil];
    
    //    NSLog(@"dataDic for sendimgtoserver img upload: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kSetServiceImage;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
    //    NSLog(@"sendimgtoserver");
    
}

-(void)ApiCallingForImgUpload{
    //[[AppDelegate MyappDelegate] showIndicator];
    [self sendimgtoserver:[imginfo objectAtIndex:count]];
    count++;
    //    NSLog(@"ApiCallingForImgUpload");
}



#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    if (currentRequestType==kSetServiceImage) {
        [self performSelector:@selector(resultForImgUpload:) withObject:responseData afterDelay:.000];
    }
    else if (currentRequestType==kSetFreeHealthServices){
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
        [self success:AppName detailMessage:message];
        [self performSelector:@selector(backAction:) withObject:nil afterDelay:3.5];
        //        NSLog(@"All images id: %@",imgIDInfo);
        //[self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.000];
    }
    
}


#pragma mark - result methods for set booking service
- (void) result:(NSDictionary *)response

{
    //    NSLog(@"response for booking appoitment = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    // NSDictionary *resposeCode=[response objectForKey:@"Booking Status"];
    message=[response objectForKey:@"Message"];
    status=[[response objectForKey:@"Status"] integerValue];
    
    if (status == 0)
    {
        isBookNowClicked = false;
        [self errorWithTitle:AppName detailMessage:message];
        
    }
    
    else if (status == 1){
        
        serviceID=[response objectForKey:@"ServiceId"];
        if (self.chosenImages.count) {
            [self performSelector:@selector(ImgToBase64) withObject:nil afterDelay:0.0];
            
        }
        else{
            [self success:AppName detailMessage:message];
            [self performSelector:@selector(backAction:) withObject:nil afterDelay:3.5];
            
        }
        
    }
    
    else if (status == 3){
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
- (IBAction)mapViewAction:(id)sender {
    
    if ([self.Lat isKindOfClass:[NSNull class]] && [self.Lon isKindOfClass:[NSNull class]]) {
        self.Lat=@"28.5810336";
        self.Lon=@"77.3152115";
    }
    
    NSString *nativeMapScheme = @"maps.apple.com";
    NSString* url = [NSString stringWithFormat:@"http://%@/maps?q=%@,%@", nativeMapScheme, self.Lat, self.Lon];
    NSURL *URL = [NSURL URLWithString:url];
       [[UIApplication sharedApplication] openURL:URL];
}
@end
