//
//  AddFamilyVC.m
//  docOPD
//
//  Created by Virinchi Software on 26/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "AddFamilyVC.h"
#import <QuartzCore/QuartzCore.h>
#import "HHAlertView.h"
#import "ViewController.h"

@interface AddFamilyVC ()

@end

@implementation AddFamilyVC

@synthesize imgUser, viewImgBorder, ViewImgNameHolder,ViewVisible;
@synthesize delegate;
- (void)viewDidLoad
{
    [super viewDidLoad];
    base64str=@"";
    relationArray=[[NSArray alloc]initWithObjects:@"Father",@"Mother",@"Brother",@"sister",@"Son",@"Daughter",@"Uncle",@"Aunt",@"Cousin",@"Brother in Law", @"Daughter in Law" @"Father in Law", @"Grand Daughter", @"Grand Father", @"Grand Mother",@"Grand Son", @"Husband",@"Wife", @"Mother in Law", @"Nephew", @"Niece", @"Sister in Law", nil];
    
    self.tableView.hidden=YES;
    imgUser.layer.cornerRadius = 80/2;
    imgUser.layer.masksToBounds = YES;
    viewImgBorder.layer.cornerRadius = 88/2;
    viewImgBorder.layer.borderWidth = 1.0;
    viewImgBorder.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    
    userDef = userDefault;
    
    [self registerForKeyboardNotifications];
    keyboardHasAppeard = NO;
   // [self scrollResizer];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    isanythingChange = NO;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    //UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    if ([self.controllerName isEqualToString:@"deatils"]) {
       // NSLog(@"%@",self.familyDataArr);
        [self.addFamilyBtn setTitle:@"Update Family" forState:UIControlStateNormal];
        NSArray *stringArray = [[self.familyDataArr valueForKey:@"RelationName"] componentsSeparatedByString:@" "];
        self.TFUserName.text=[stringArray objectAtIndex:0];
       // self.TFUserlastname.text=[stringArray objectAtIndex:1];
        self.TFUserMobile.text=[self.familyDataArr valueForKey:@"RelationMobileNumber"];
        self.TFUserAddress.text=[self.familyDataArr valueForKey:@"RelationEmailId"];
        self.relationshipTXT.text=[self.familyDataArr valueForKey:@"Relation"];
        self.TFUserGender.text=[self.familyDataArr valueForKey:@"RelationGender"];
        self.TFUserDOB.text=[self.familyDataArr valueForKey:@"RelationDOB"];
        NSString *path=[self.familyDataArr valueForKey:@"RelationImage"];
        if ([path isKindOfClass:[NSNull class]]) {
            self.imgUser.image=[UIImage imageNamed:@"user"];
        }
        else{
            [self.imgUser sd_setImageWithURL:[NSURL URLWithString:path]
                                  placeholderImage:[UIImage imageNamed:@""]];
            
        }
        self.imgUser.contentMode = UIViewContentModeScaleAspectFit;
        self.imgUser.clipsToBounds = YES;
    }
    //    [self scrollResizer];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"AddFamilyScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:[NSString stringWithFormat:@"AddFamilyScreen"]];
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
    
    [txtActiveField resignFirstResponder];
    [self showGrid];
}




#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
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
    
//       CGRect NewRect = self.ViewVisible.frame;
//    NewRect.size.height = self.TFUserGender.frame.size.height + self.TFUserGender.frame.origin.y;
//    self.ViewVisible.frame = NewRect;
//    self.Scroll.contentSize = CGSizeMake(self.Scroll.frame.size.width, self.ViewVisible.frame.size.height+10);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.Scroll.contentInset = contentInsets;
    
}

-(void) GoToEditImg{
    
    
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
    base64str =  [self imageToNSString:image];
    
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
    txtActiveField = textField;
    [textField setTintColor:[UIColor dOPDThemeColor]];
    
    return YES;
}
#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.tableView.hidden=YES;
    if (textField==self.TFUserDOB) {
        [self pickDateMethod];
    }
    if (textField==self.relationshipTXT) {
        [self.TFUserlastname resignFirstResponder];
    }

    oldValue = textField.text;
    txtActiveField= textField;
   
    if (keyboardHasAppeard)
        [self.Scroll scrollRectToVisible:[self getPaddedFrameForView:textField] animated:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.Scroll.contentInset = contentInsets;
    
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
    if(textField ==self.TFUserMobile)
    {
        NSUInteger newLength = [self.TFUserMobile.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"somethingChange" object:nil];
    return YES;
}
//-(BOOL) textFieldShouldReturn:(UITextField *)textField{
//    [self.Scroll setContentOffset:CGPointMake(0, 0) animated:YES];
//    [textField resignFirstResponder];
//    return YES;
//}
//

-(void)pickDateMethod{
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDate * currentDate = [NSDate date];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setYear: 0];
    NSDate * maxDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    [comps setYear: -120];
    NSDate * minDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    [comps setYear: -20];
    NSDate * pickerDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    datePicker.date = pickerDate;
    [self.TFUserDOB setInputView:datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setTintColor:[UIColor dOPDThemeColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.TFUserDOB setInputAccessoryView:toolBar];
    
}
-(void)ShowSelectedDate
{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.TFUserDOB.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.TFUserDOB resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.Scroll.contentInset = contentInsets;
}

#pragma mark - Validation Method
-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
    NSString *phoneRegex =@"^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$";// @"^[789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];

    if(([self.TFUserName.text isEqualToString:@""]&& [self.TFUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.TFUserName becomeFirstResponder];
        [self errorWithTitle:@"Error" detailMessage:@"Please Enter First Name"];
    }
    else if(([self.TFUserlastname.text isEqualToString:@""]&& [self.TFUserlastname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.TFUserlastname becomeFirstResponder];
        [self errorWithTitle:@"Error" detailMessage:@"Please Enter Last Name"];
    }
    else if([self.relationshipTXT.text isEqualToString:@""] && [self.relationshipTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
    {
        valid = NO;
        [self errorWithTitle:@"Error" detailMessage:@"Please Enter Relationship"];
        
    }
    else if((![phoneTest evaluateWithObject:_TFUserMobile.text]) ||(_TFUserMobile.text.length!=10) || ([_TFUserMobile.text isEqualToString:@""]&& [_TFUserMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.TFUserMobile becomeFirstResponder];
        [self errorWithTitle:@"Error" detailMessage:@"Please Enter Valid Mobile Number"];
        
    }
    else if([self.TFUserGender.text isEqualToString:@""] && [self.TFUserAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
    {
        valid = NO;
        [self.TFUserAddress becomeFirstResponder];
        [self errorWithTitle:@"Error" detailMessage:@"Please Enter Gender"];
        
    }
    else if([self.TFUserDOB.text isEqualToString:@""] && [self.TFUserAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
    {
        valid = NO;
        [self.TFUserAddress becomeFirstResponder];
        [self errorWithTitle:@"Error" detailMessage:@"Please Enter D.O.B"];
        
    }
    
   else if (self.TFUserAddress.text.length>0) {
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
    [self.view endEditing:YES];
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
            [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    
    [alert addAction:male];
    [alert addAction:female];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
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
-(void)ActiveButtonColor:(NSNotification*)notif{
    [self.addFamilyBtn setBackgroundColor:[UIColor dOPDThemeColor]];
}
-(void)deactiveButtonColor:(NSNotification*)notif{
    if ([self.controllerName  isEqualToString:@"deatils"]) {
         [self.addFamilyBtn setBackgroundColor:[UIColor colorWithRed:95.0/255.0 green:210.0/255.0 blue:195.0/255.0 alpha:1.0]];
    }
   
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)addFamilyAction:(id)sender {
    [Localytics tagEvent:[NSString stringWithFormat:@"AddFamilySubmitButtonClick"]];
        BOOL isvalid=[self CheckForValidation];
        if (isvalid)
        {
            NSString *lat = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlat];
            NSString *lng = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlong];
            NSString* vendorId = [AppDelegate MyappDelegate].vendorId;
            if ([AppDelegate MyappDelegate].isInternet)
            {
                if ([self.controllerName isEqualToString:@"deatils"]) {
                    if (isanythingChange){
                         [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:@"Update Family in progress..."];
                        [[docOPDNetworkEngine sharedInstance]UpdateUserRelationAPI:self.TFUserName.text LastName:self.TFUserlastname.text EmailId:self.TFUserAddress.text MobileNumber:self.TFUserMobile.text Relation:self.relationshipTXT.text UserId:[userDef valueForKey:User_id] Lat:lat Lon:lng DeviceId:vendorId  gender:self.TFUserGender.text DOB:self.TFUserDOB.text  RelationId:[self.familyDataArr valueForKey:@"RelationId"] withCallback:^(NSDictionary *responseData) {
                            NSArray *dataArr=[responseData objectForKey:@"Relation Status"];
                            NSInteger status=[[dataArr valueForKey:@"Status"] intValue];
                            if (status==1) {
                                isanythingChange = false;
                                [self getFamilyData];
                            }
                            
                        }];
                        
                    }
                    
                }
                else{
                    [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:@"Add Family in progress..."];
                    
                    
                    [[docOPDNetworkEngine sharedInstance]SetUserRelationAPI:self.TFUserName.text LastName:self.TFUserlastname.text EmailId:self.TFUserAddress.text MobileNumber:self.TFUserMobile.text Relation:self.relationshipTXT.text UserId:[userDef valueForKey:User_id] Lat:lat Lon:lng DeviceId:vendorId  gender:self.TFUserGender.text DOB:self.TFUserDOB.text  withCallback:^(NSDictionary *responseData) {
                        if ([base64str length]>0) {
                            [[docOPDNetworkEngine sharedInstance]UploadUserImageByMobileNumberAPI:self.TFUserMobile.text UploadImage:base64str withCallback:^(NSDictionary *responseData) {
                                [self getFamilyData];
                            }];
                        }
                        else{
                            [self getFamilyData];
                            
                        }
                        
                    }];
                }

                }
                 else
                 {
                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Either server is too busy or check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
                     [alert show];
                
                 }

    }
}

-(void)getFamilyData{
    [[docOPDNetworkEngine sharedInstance]GetRelationAPI:[userDef valueForKey:User_id] withCallback:^(NSDictionary *responseData) {
        NSInteger status=[[responseData objectForKey:@"Status"] intValue];
        if (status==1) {
           
            NSArray *RelationList=[responseData objectForKey:@"RelationList"];
            [userDef setObject:[NSKeyedArchiver archivedDataWithRootObject:RelationList] forKey:@"RelationList"];
            
            [userDef  synchronize];
            [[AppDelegate MyappDelegate] hideIndicator];
            
            [self.navigationController popViewControllerAnimated:YES];

            
        }
        else{
        }
        
    }];

}



- (IBAction)backAction:(id)sender {
    [Localytics tagEvent:[NSString stringWithFormat:@"AddFamilyMyFamilyClick"]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectRelationshipAction:(id)sender {
    [self.view endEditing:YES];
    self.tableView.hidden=NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [relationArray count];
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    // NSLog(@"willDisplayCell - %ld",(long)indexPath.section);
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:247.0/255.0 blue:248.0/255.0 alpha:1.0];
    
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *relationship = (UILabel *)[cell viewWithTag:1111];
    relationship.text=[relationArray objectAtIndex:indexPath.row];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.relationshipTXT.text=[relationArray objectAtIndex:indexPath.row];
    self.tableView.hidden=YES;
}

@end
