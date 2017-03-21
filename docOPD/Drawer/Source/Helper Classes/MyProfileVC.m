//
//  MyProfileVC.m
//  docOPD
//
//  Created by Virinchi Software on 11/4/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "MyProfileVC.h"
#import <QuartzCore/QuartzCore.h>
#import "ChangePassword.h"
#import "HHAlertView.h"
#import "ViewController.h"

@implementation MyProfileVC
@synthesize imgUser, viewImgBorder, LblMobile, ViewImgNameHolder,ViewVisible;
@synthesize delegate;
- (void)viewDidLoad
{
    [super viewDidLoad];
    isanythingChange = NO;
    imgUser.layer.cornerRadius = self.imgViewHTConst.constant/2;
    imgUser.layer.masksToBounds = YES;
    viewImgBorder.layer.cornerRadius = self.viewHTConst.constant/2;
    viewImgBorder.layer.borderWidth = 1.0;
    viewImgBorder.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
  //  ViewVisible.backgroundColor = [UIColor dOPDThemeColor];
    [self setupTextField:self.TFUserAddress];
    [self setupTextField:self.TFUserMobile];
    [self setupTextField:self.TFUserName];
    [self setupTextField:self.TFUserPassword];
    userDef = userDefault;
    self.TFUserName.text = [userDef objectForKey:Username];
    self.TFUserMobile.text = [userDef objectForKey:Mobile];
    self.TFUserPassword.text = @"********";

    self.TFUserAddress.text = [userDef objectForKey:EmailID];
    if(![userDef objectForKey:EmailID]){
        self.TFUserAddress.text = @"";
    }
    
    
    if(![userDef objectForKey:Gender]){
        self.TFUserGender.text = @"";
    }else{
       self.TFUserGender.text = [userDef objectForKey:Gender];
    }
    
    [self setupTextField:self.TFUserGender];
    
//    self.BtnUploadImg.layer.cornerRadius = self.imgViewHTConst.constant/2;
//    self.BtnUploadImg.layer.masksToBounds = YES;
    self.TFUserMobile.enabled = false;
  //  self.BtnUpdate.layer.cornerRadius = 7.0;
 //   self.BtnUploadImg.layer.masksToBounds = YES;
    
    
    self.LblSep.layer.shadowOpacity= 0.8;
    self.LblSep.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.LblSep.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    
    
   // self.imgUser.image = [self getImage:@"MyProfileImage.png"];
    NSString *imgNamestr =@"MyProfileImage.png";
    NSString*userImgFile = [[AppDelegate MyappDelegate].dataPath stringByAppendingPathComponent:imgNamestr];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:userImgFile];
    if (fileExists) {
        self.imgUser.image  = [self getImage:imgNamestr];
    }else{
        self.imgUser.image  = [UIImage imageNamed:@"user.png"];
    }
    
    
    
    
    [self registerForKeyboardNotifications];
    keyboardHasAppeard = NO;
    [self scrollResizer];
    self.automaticallyAdjustsScrollViewInsets = NO;

//
//    NSLog(@"Btn = %f, %f",self.BtnUpdate.frame.origin.y,self.BtnUpdate.frame.size.height);
//   NSLog(@"ViewVisible = %f, %f",self.ViewVisible.frame.origin.y,self.ViewVisible.frame.size.height);
//    
//    
//    CGRect newRect = self.ViewVisible.frame;
//    newRect.size.height = self.BtnUpdate.frame.origin.y + self.BtnUpdate.frame.size.height+5;
//    self.ViewVisible.frame = newRect;
//    
//    NSLog(@"R Btn = %f, %f",self.BtnUpdate.frame.origin.y,self.BtnUpdate.frame.size.height);
//    NSLog(@"R ViewVisible = %f, %f",self.ViewVisible.frame.origin.y,self.ViewVisible.frame.size.height);

    
  //  RNLongPressGestureRecognizer *longPress = [[RNLongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
   // [self.view addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    //UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    

//    [self scrollResizer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"MyProfileScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [Localytics tagEvent:@"MyProfileScreen"];
}




- (IBAction)EditName:(id)sender {
     [self EditInfo:self.TFUserName];
}
- (IBAction)EditPassword:(id)sender {
    [Localytics tagEvent:@"MyProfileChangePasswordClick"];
    ChangePassword *chpwd = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
    [self presentViewController:chpwd animated:YES completion:nil];
}
- (IBAction)EditMobile:(id)sender {
    [self EditInfo:self.TFUserMobile];
    if ([UIScreen mainScreen].bounds.size.width<=320)
    {
         [self.Scroll setContentOffset:CGPointMake(0, 100) animated:YES];
       // self.Scroll.contentSize = CGSizeMake(self.Scroll.frame.size.width, 300);
    }
}
- (IBAction)EditAddress:(id)sender {
    [self EditInfo:self.TFUserAddress];
    
    if ([UIScreen mainScreen].bounds.size.width<=320) {
    [self.Scroll setContentOffset:CGPointMake(0, 140) animated:YES];
        //self.Scroll.contentSize = CGSizeMake(self.Scroll.frame.size.width, 300);
    }
    else{
        [self.Scroll setContentOffset:CGPointMake(0, 100) animated:YES];
        //self.Scroll.contentSize = CGSizeMake(self.Scroll.frame.size.width, 100);
    }

}


-(void)TextFieldDisable:(UITextField*)textfield{
    
    textfield.enabled = false;
    
    textfield.layer.borderWidth = 0.0;
    
    textfield.layer.borderColor = [UIColor clearColor].CGColor;
    
    textfield.delegate = self;
    
}

-(void)EditInfo:(UITextField*)textfield{
    
    [self TextFieldDisable:lastTF];
    [self TextFieldEnable:textfield];

}

-(void)TextFieldEnable:(UITextField*)textfield{
    
    lastTF = textfield;
    textfield.enabled = true;
    textfield.layer.borderWidth = 1.0;
    textfield.layer.borderColor = [UIColor whiteColor].CGColor;
    [textfield becomeFirstResponder];
    activeTF = textfield;
    
}

- (IBAction)editImg:(id)sender {
    [Localytics tagEvent:@"MyProfileEditImageButtonClick"];

//    UIActionSheet *PopUp = [[UIActionSheet alloc]initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Gallery", nil];
//    PopUp.tag = 1;
//    [PopUp showInView:self.view];
    [txtActiveField resignFirstResponder];
    [self showGrid];
}


#pragma mark - didPressUpdateProfile
- (IBAction)UpdateProfile:(id)sender {
    [Localytics tagEvent:@"MyProfileUpdateButtonClick"];
    if (isanythingChange)
    {
        if (!isBtnTapped) {
            BOOL isvalid=[self CheckForValidation];
            if (isvalid)
            {
                if ([AppDelegate MyappDelegate].isInternet)
                {
                    isBtnTapped = YES;
//                    NSLog(@"Valid data");
                       [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:.000];
                    
                    //[self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.0];
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Either server is too busy or check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
                    [alert show];
                    
                }
            }
        }
    }
    
 
    
//    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                          message:@"API Not available"
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles: nil];
//    
//    [myAlertView show];
}


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}


- (IBAction)openSlider:(id)sender {
   // [self.delegate imageupdateforSlider];
    [Localytics tagEvent:@"MyProfileMyAccountClick"];
    [self.navigationController popViewControllerAnimated:YES];
//    static Menu menu = MenuLeft;
//    menu = MenuLeft;
//    [[SlideNavigationController sharedInstance] toggleMenu:menu withCompletion:nil];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
//    NSLog(@"Click on button index: %ld",(long)buttonIndex);
    
    switch (buttonIndex) {
            
        case 0:
            
//            NSLog(@"Click on button index: 0");
            
            break;
            
        case 1:
            
//            NSLog(@"Click on button index 1");
            
            break;
            
        case 2:
            
//            NSLog(@"Click on button index 2");
            
            break;
            
        default:
            
            break;
            
    }
 
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self.Scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
//    lastTF = activeTF;
//    
//    [self TextFieldDisable:textField];
    
    return YES;
    
}

-(void)scrollResizer{
    
//    NSLog(@"scrollResizer Btn = %f, %f",self.BtnUpdate.frame.origin.y,self.BtnUpdate.frame.size.height);
//    NSLog(@"scrollResizer ViewVisible = %f, %f",self.ViewVisible.frame.origin.y,self.ViewVisible.frame.size.height);
    
    CGRect NewRect = self.ViewVisible.frame;
    NewRect.size.height = self.TFUserGender.frame.size.height + self.TFUserGender.frame.origin.y;
    self.ViewVisible.frame = NewRect;
    self.Scroll.contentSize = CGSizeMake(self.Scroll.frame.size.width, self.ViewVisible.frame.size.height+10);
    
//    NSLog(@"R scrollResizer Btn = %f, %f",self.BtnUpdate.frame.origin.y,self.BtnUpdate.frame.size.height);
//    NSLog(@"R scrollResizer ViewVisible = %f, %f",self.ViewVisible.frame.origin.y,self.ViewVisible.frame.size.height);
}

-(void) GoToEditImg{
    
//    ImgEditViewController*imgedit = [self.storyboard instantiateViewControllerWithIdentifier:@"imgedit"];
//    
//    imgedit.img = self.imgUser.image;
//    
//    [self.navigationController pushViewController:imgedit animated:YES];
    
}

#pragma mark - RNGRIDVIEW

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self showGridWithHeaderFromPoint:[longPress locationInView:self.ViewImgNameHolder]];
    }
}

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

- (void)showImagesOnly {
    NSInteger numberOfOptions = 5;
    NSArray *images = @[
                        [UIImage imageNamed:@"arrow"],
                        [UIImage imageNamed:@"attachment"],
                        [UIImage imageNamed:@"block"],
                        [UIImage imageNamed:@"bluetooth"],
                        [UIImage imageNamed:@"cube"],
                        [UIImage imageNamed:@"download"],
                        [UIImage imageNamed:@"enter"],
                        [UIImage imageNamed:@"file"],
                        [UIImage imageNamed:@"github"]
                        ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithImages:[images subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    [av showInViewController:self center:CGPointMake(self.ViewImgNameHolder.bounds.size.width/2.f, self.ViewImgNameHolder.bounds.size.height/2.f)];
}

- (void)showList {
    NSInteger numberOfOptions = 5;
    NSArray *options = @[
                         @"Next",
                         @"Attach",
                         @"Cancel",
                         @"Bluetooth",
                         @"Deliver",
                         @"Download",
                         @"Enter",
                         @"Source Code",
                         @"Github"
                         ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithTitles:[options subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.itemTextAlignment = NSTextAlignmentLeft;
    av.itemFont = [UIFont boldSystemFontOfSize:18];
    av.itemSize = CGSizeMake(150, 55);
    [av showInViewController:self center:CGPointMake(self.ViewImgNameHolder.bounds.size.width/2.f, self.ViewImgNameHolder.bounds.size.height/2.f)];
}

- (void)showGrid {
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
    av.blurExclusionPath = [UIBezierPath bezierPathWithOvalInRect:self.imgUser.frame];
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





-(void)imagePickFromGallery{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
    
    
}


-(void)imageCaptureByCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    self.imgUser.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
    }];

    [self ImgToBase64:image];

}



#pragma mark - u

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kUpdateUserProfile], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.TFUserName.text,Username,self.TFUserMobile.text,Mobile,self.TFUserAddress.text,EmailID,self.TFUserGender.text,Gender,nil];
    
//    NSLog(@"dataDic for update profile: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kUpdateUserProfile;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling for update profile");
    
    
}

#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    if (currentRequestType==kUpdateUserProfile) {
        [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
    }else if (currentRequestType == kUploadUserImage){
        [self performSelector:@selector(resultForImageUpload:) withObject:responseData afterDelay:.000];
    }
   
    
//    NSLog(@"update profile Controller requestFinished");
}


#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response

{
//    NSLog(@"response = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
   // NSDictionary *resposeCode=[response objectForKey:@"UpdateProfile"];
    NSString *message=[response objectForKey:@"Message"];
    NSInteger status=[[response objectForKey:@"Status"]integerValue];
    //    status=[[resposeCode objectForKey:@"Status"] integerValue];
    //
    if (status == 0)
    {
//        NSLog(@"On the UpdateProfile status 0");
        [self errorWithTitle:@"Error" detailMessage:message];
        isBtnTapped= false;
        isanythingChange = false;
        
    }
    else if (status == 1){
//        NSLog(@"UpdateProfile status1 message = %@",message);
        [self success:@"Success" detailMessage:message];
        [userDef setObject:self.TFUserName.text forKey:Username];
        [userDef setObject:self.TFUserAddress.text forKey:EmailID];
        [userDef setObject:self.TFUserGender.text forKey:Gender];
        
        isanythingChange = false;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NotChange" object:nil];
    }
    else if (status == 10){
        [userDef setObject:@"No" forKey:isLogin];
        ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_Login"];
        [self.navigationController pushViewController:login animated:YES];
    }
    
}

#pragma mark - result methods for login service
- (void) resultForImageUpload:(NSDictionary *)response

{
//    NSLog(@"response resultForImageUpload = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    NSString *message=[response objectForKey:@"Message"];
    NSInteger status=[[response objectForKey:@"Status"]integerValue];
    //    status=[[resposeCode objectForKey:@"Status"] integerValue];
    //
    if (status == 0)
    {
//        NSLog(@"On the UpdateProfile status 0");
        [self errorWithTitle:@"Error" detailMessage:message];
        isBtnTapped= false;
        
    }
    else if (status == 1){
//        NSLog(@"UpdateProfile status1 message = %@",message);
        [userDef setObject:[response objectForKey:@"ImageURL"] forKey:userProfileImgUrl];
        
        NSURL *url = [NSURL URLWithString:[response objectForKey:@"ImageURL"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *savedImagePath = [[[AppDelegate MyappDelegate]dataPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"MyProfileImage.png"]];
        mediaPath = [NSString stringWithFormat:@"MyProfileImage.png"];
//        NSLog(@"Mediapath= %@",mediaPath);
//        NSLog(@"save path= %@",savedImagePath);
        [data writeToFile:savedImagePath atomically:NO];
        [self success:@"Success" detailMessage:message];
        isanythingChange = false;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NotChange" object:nil];
        
    }
    
}



- (void) requestError
{
    isBtnTapped = false;
//    NSLog(@"Login ViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
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



-(void)ImgToBase64:(UIImage*)image{
    NSString*base64str =  [self imageToNSString:image];
    [self sendimgtoserver:base64str];
    
}

-(void)sendimgtoserver:(NSString*)base64code{
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kUploadUserImage], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:base64code,base64,nil];
    
//    NSLog(@"dataDic for user img upload: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kUploadUserImage;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"sendimgtoserver in myprofile");
    
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



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    isBtnTapped= false;
    txtActiveField = textField;
    [textField setTintColor:[UIColor dOPDThemeColor]];
  
    return YES;
}
#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    oldValue = textField.text;
//    [textField setInputAccessoryView:[self inputAccessoryViews]];
    txtActiveField= textField;
    if (textField == self.TFUserPassword) {
        [textField resignFirstResponder];
        [self EditPassword:nil];
    }
    if (keyboardHasAppeard)
        [self.Scroll scrollRectToVisible:[self getPaddedFrameForView:textField] animated:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([oldValue isEqualToString:textField.text]) {
        if(isanythingChange){
            isanythingChange = true;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"somethingChange" object:nil];
        }else{
            isanythingChange = false;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NotChange" object:nil];
        }
    }else{
       isanythingChange = true;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"somethingChange" object:nil];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  [[NSNotificationCenter defaultCenter]postNotificationName:@"somethingChange" object:nil];
    return YES;
}
//-(BOOL) textFieldShouldReturn:(UITextField *)textField{
//    [self.Scroll setContentOffset:CGPointMake(0, 0) animated:YES];
//    [textField resignFirstResponder];
//    return YES;
//}
//



#pragma mark - Validation Method
-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
    
    if(([self.TFUserName.text isEqualToString:@""]&& [self.TFUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.TFUserName becomeFirstResponder];
        [self errorWithTitle:@"Error" detailMessage:@"Please Enter User Name"];
//        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter User Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
    }
    else if((self.TFUserMobile.text.length!=10) || ([self.TFUserMobile.text isEqualToString:@""]&& [self.TFUserMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.TFUserMobile becomeFirstResponder];
        [self errorWithTitle:@"Error" detailMessage:@"Please Enter Valid Mobile Number"];

    }
    
    else if([self.TFUserAddress.text isEqualToString:@""] && [self.TFUserAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
    {
        valid = NO;
        [self.TFUserAddress becomeFirstResponder];
        [self errorWithTitle:@"Error" detailMessage:@"Please Enter Email ID"];

    }
    
    if (self.TFUserAddress.text.length>0) {
        if ([self.TFUserAddress.text isEqualToString:@"NA"]) {
            valid = YES;
        }
        else if(![emailTest evaluateWithObject:self.TFUserAddress.text]){
            valid = NO;
            [self errorWithTitle:@"Error" detailMessage:@"Please Enter Valid Email ID"];
      
        }
    }
    
    return valid;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    else
    {
      //  [self hideKeyboard];
        return YES;
    }
}



-(void)hideKeyboard{
    [self textFieldShouldReturn:txtActiveField];
    [self.Scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];
}

- (UIImage*)getImage: (NSString*)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    dataPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:@"Media"];
    NSString *getImagePath = [dataPath stringByAppendingPathComponent:filename];
//    NSLog(@"Get image path: %@",getImagePath);
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
    
}
- (IBAction)didPressGender:(id)sender {
    NSString *gender = self.TFUserGender.text.lowercaseString;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Gender" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *male = [UIAlertAction actionWithTitle:@"Male" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.TFUserGender.text = @"Male";
        if (![gender isEqualToString:@"male"]) {
            isanythingChange =true;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"somethingChange" object:nil];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *female = [UIAlertAction actionWithTitle:@"Female" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.TFUserGender.text = @"Female";
        if (![gender isEqualToString:@"female"]) {
            isanythingChange =true;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"somethingChange" object:nil];
        }
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        self.TFUserGender.text = @"Cancel";
//        if (![gender isEqualToString:@"female"]) {
//            isanythingChange =true;
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"somethingChange" object:nil];
//        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    
    [alert addAction:male];
    [alert addAction:female];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
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
    [self.Scroll setContentOffset:CGPointMake(0, 0) animated:YES];
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ActiveButtonColor:)
                                                 name:@"somethingChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deactiveButtonColor:)
                                                 name:@"NotChange" object:nil];
    
}

#pragma mark Notification handlers
- (void)keyboardWasShown:(NSNotification*)notif
{
    NSDictionary* info = [notif userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.Scroll.contentInset = contentInsets;
    self.Scroll.scrollIndicatorInsets = contentInsets;
    
    //scrolling the active field to visible area
    if ((nil != txtActiveField) && (keyboardHasAppeard == NO))
        [self.Scroll scrollRectToVisible:[self getPaddedFrameForView:txtActiveField] animated:YES];
    
    keyboardHasAppeard = YES;
}

- (void)keyboardWillBeHidden:(NSNotification*)notif
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.Scroll.contentInset = UIEdgeInsetsZero;
    self.Scroll.scrollIndicatorInsets = UIEdgeInsetsZero;
    [UIView commitAnimations];
    
    keyboardHasAppeard = NO;
}
-(void)ActiveButtonColor:(NSNotification*)notif{
    [self.BtnUpdate setBackgroundColor:[UIColor dOPDThemeColor]];
}
-(void)deactiveButtonColor:(NSNotification*)notif{
    [self.BtnUpdate setBackgroundColor:[UIColor colorWithRed:95.0/255.0 green:210.0/255.0 blue:195.0/255.0 alpha:1.0]];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
