//
//  photoViwerViewController.m
//  docOPD
//
//  Created by Virinchi Software on 2/6/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "photoViwerViewController.h"
#import "VIPhotoView.h"
#import "NSData+Base64.h"
@interface photoViwerViewController ()

@end

@implementation photoViwerViewController
@synthesize image,getImagePath;
- (void)viewDidLoad {
    [super viewDidLoad];
    keyboardHasAppeard = NO;
    self.textViewEmpty=NO;
    userdef = userDefault;
    self.captionTXT.delegate=self;
    self.ScrollView.contentSize = CGSizeMake(self.ScrollView.frame.size.width, self.captionTXT.frame.size.height);
    self.captionTXT.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self setupTextView:self.captionTXT];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10; // for example shift right bar button to the right
    
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithCustomView:self.captionTXT];
    self.toolBar.items = [NSArray arrayWithObjects:spacer,barItem, nil];
    self.toolBar.hidden= YES;
    [self.ViewTextviewholder addSubview:self.captionTXT];
    //self.ImgView.userInteractionEnabled = YES;
    self.ViewTextviewholder.backgroundColor = [UIColor colorWithRed:227.0 green:227.0 blue:227.0 alpha:1.0];
    //    NSLog(@"grand parent %@, parent = %@",self.grandParent,self.parentFolder);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hidekeyboard)];
    tap.numberOfTapsRequired = 1.0;
    [self.view addGestureRecognizer:tap];
   // [self.ImgView addGestureRecognizer:tap];
    //[self.btnSave setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _previousContentHeight =   self.captionTXT.contentSize.height;
    self.captionTXT.enablesReturnKeyAutomatically = YES;

    
    
    
  //  self.view.backgroundColor=  [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    [self GetData];
    [self setupView];
}

-(void)viewDidAppear:(BOOL)animated{
    [self registerForKeyboardNotifications];
}

-(void)hidekeyboard {
   // [self.captionTXT resignFirstResponder];
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"MedicalRecordImageViewerScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
      [Localytics tagEvent:@"MedicalRecordImageViewerScreen"];
}

-(void)setupView{
    image = [UIImage imageWithContentsOfFile:getImagePath];
//    NSLog(@"get image path by push: %@",self.getImagePath);

    
    NSInteger indexOfImgCode = [self.dbManager.arrColumnNames indexOfObject:@"upload_image"];
    NSInteger indexOfImgtag = [self.dbManager.arrColumnNames indexOfObject:@"image_tag"];
    
    NSString *imageCode = [[self.FetchedData objectAtIndex:0]objectAtIndex:indexOfImgCode];
    NSString *caption =  [[self.FetchedData objectAtIndex:0]objectAtIndex:indexOfImgtag];
    
    if ( [caption length]>0) {
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [placeholderLabel removeFromSuperview];
        }];
        self.captionTXT.text=caption;
    }
     oldCaption=caption;
    
    NSData *data = [[NSData alloc] initWithData:[NSData
                                                 dataFromBase64String:imageCode]];
    //collectionImageView.image = [UIImage imageWithData:data];
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:self.view.bounds andImage:[UIImage imageWithData:data]];
   // photoView.autoresizingMask = (1 << 6) -1;
    
    [self.viewMain addSubview:photoView];
    
//    UITextView *textCaption = [[UITextView alloc]initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width-20, 30)];
//    textCaption.text = caption;
//    textCaption.font = [UIFont systemFontOfSize:14];
//    textCaption.textColor = [UIColor whiteColor];
//    textCaption.backgroundColor = [UIColor clearColor];
//    textCaption.editable = false;
//    textCaption.scrollEnabled = YES;
//    [self.viewMain addSubview: textCaption];
//    
//    CGRect frame = textCaption.frame;
//    
//    frame.size.height = textCaption.contentSize.height;
//    if (frame.size.height<=100) {
//        frame.size.height = textCaption.contentSize.height;
//    }else{
//        frame.size.height = 100;
//    }
//    frame.origin.y=[UIScreen mainScreen].bounds.size.height - frame.size.height;
////    NSLog(@"fram size height: %f",frame.size.height);
//    
//    textCaption.frame = frame;
//    
    
    
    UIButton *closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    closebtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-110, 20, 100, 100);
    closebtn.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 80,0);
    [closebtn setImage:[UIImage imageNamed:@"white-cancel.png"] forState:UIControlStateNormal];
    [closebtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.viewMain addSubview:closebtn];
}



-(void)closeView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    NSLog(@"%@", NSStringFromCGRect([[[self.view subviews] lastObject] frame]));
}



- (UIImage*)getImage: (NSString*)filename {
    
    //   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //   NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
   // NSString *localpath = [NSString stringWithFormat:@"%@/%@/%@",[[AppDelegate MyappDelegate]medicalRecordPath],self.grandParent,self.parentFolder];
    //   localpath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:@"Media"];
   // NSString *getImagePath = [localpath stringByAppendingPathComponent:filename];
//    NSLog(@"Get image path in getImge func: %@",self.getImagePath);
    UIImage *img = [UIImage imageWithContentsOfFile:filename];
    return img;
    
}


-(void)GetData{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT user_id,upload_image,image_tag FROM medicalRecord WHERE image_id='%@'",self.imageid];
    
    // Get the results.
    if (self.FetchedData != nil) {
        self.FetchedData = nil;
    }
    self.FetchedData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - TextView Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    //   NSLog(@"textview did begin editing");
    [UIView animateWithDuration:0.15 animations:^{
        placeholderLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        [placeholderLabel removeFromSuperview];
    }];
}


- (void)textViewDidChange:(UITextView *)textView
{
//    _previousContentHeight = textView.frame.size.height;
//    CGFloat maxHeight = 90.0f;
//    CGFloat fixedWidth = textView.frame.size.width;
//    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
//    CGRect newFrame = textView.frame;
//    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), fminf(newSize.height, maxHeight));
//    textView.frame = newFrame;
//    CGRect inputrect;
//    if (_previousContentHeight<newSize.height) {
//        inputrect = self.ViewTextviewholder.frame;
//        inputrect.origin.y = inputrect.origin.y -(newFrame.size.height-_previousContentHeight);
//        inputrect.size.height = inputrect.size.height+(newFrame.size.height-_previousContentHeight);
//        self.ViewTextviewholder.frame = inputrect;
//        
//        
//    }else if (_previousContentHeight>newSize.height){
//        inputrect = self.ViewTextviewholder.frame;
//        inputrect.origin.y = inputrect.origin.y +(_previousContentHeight-newFrame.size.height);
//        inputrect.size.height = inputrect.size.height-(_previousContentHeight-newFrame.size.height);
//        self.ViewTextviewholder.frame = inputrect;
//        
//    }
//    
    
    
}





-(void)setupTextView: (UITextView*)textview{
    textview.text=@"";
    textview.layer.borderColor= [UIColor dOPDImgBorderColor].CGColor;
    textview.layer.borderWidth = 1.0f;
    textview.layer.cornerRadius = 4.0;
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, textview.frame.size.width - 10.0, 34.0)];
    [placeholderLabel setText:@"Tap to add a caption"];
    // placeholderLabel is instance variable retained by view controller
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setTextColor:[UIColor dOPDBlueColor]];
    placeholderLabel.font = [UIFont systemFontOfSize:17.0];
    textview.delegate= self;
    textview.keyboardAppearance = UIKeyboardAppearanceDark;
    textview.font =[UIFont systemFontOfSize:17.0];
    // textView is UITextView object you want add placeholder text to
    [textview addSubview:placeholderLabel];
    
}



- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (![textView hasText]) {
        self.textViewEmpty = NO;
        [textView addSubview:placeholderLabel];
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 1.0;
        }];
        
    }
    else if ([textView hasText] && ![oldCaption isEqualToString:textView.text]){
        self.textViewEmpty = YES;
    }
    
    else {
        self.textViewEmpty = NO;
    }
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
#pragma mark Notification handlers
- (void)keyboardWasShown:(NSNotification*)notif
{
    NSDictionary* info = [notif userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // NSInteger oldKBSize =0;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.ScrollView.contentInset = contentInsets;
    self.ScrollView.scrollIndicatorInsets = contentInsets;
    [self animateTextView:YES withKBHeight:kbSize.height];
    
    //     if(keyboardHasAppeard == NO){
    //         [self animateTextView:YES withKBHeight:kbSize.height];
    //     }
    keyboardHasAppeard = YES;
}



- (void) animateTextView:(BOOL)up withKBHeight:(float)kbheight
{
    const int movementDistance =kbheight; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement= movement = (up ? -movementDistance : movementDistance);
    //   NSLog(@"%d",movement);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    
    //    CGRect inputviewFrame = self.toolbar.frame;
    //    inputviewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - self.toolbar.frame.size.height-kbheight;
    //    self.toolbar.frame = inputviewFrame;
    CGRect inputviewFrame = self.ViewTextviewholder.frame;
    inputviewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - self.ViewTextviewholder.frame.size.height-kbheight;
    self.ViewTextviewholder.frame = inputviewFrame;
    
    
    [UIView commitAnimations];
}


- (void)keyboardWillBeHidden:(NSNotification*)notif
{
    [UIView beginAnimations:nil context:nil];
    
    CGRect inputviewFrame = self.ViewTextviewholder.frame;
    inputviewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - inputviewFrame.size.height-45;
    self.ViewTextviewholder.frame = inputviewFrame;
    
    [UIView commitAnimations];
    
    keyboardHasAppeard = NO;
}




- (IBAction)updateCaptionAction:(id)sender {
    if (self.textViewEmpty) {
        self.textViewEmpty=NO;
        [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:@"Updating in progress..."];
        [[docOPDNetworkEngine sharedInstance]UpdateCaptionBaseOnImageIdAPI:self.captionTXT.text ImageId:self.imageid withCallback:^(NSDictionary *responseData) {
            oldCaption=self.captionTXT.text;
            NSString *udateQuery = [NSString stringWithFormat:@"UPDATE medicalRecord SET image_tag ='%@' WHERE image_id = '%@'" ,self.captionTXT.text,self.imageid];
            // Execute the query.
            [self.dbManager executeQuery:udateQuery];
            
            [[AppDelegate MyappDelegate] hideIndicator];
            [self success:AppName detailMessage:@"Successfully Updated"];
            
        }];
    }
//    else{
//        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:AppName message:[NSString stringWithFormat:@"Please Add a Caption" ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//               [alert show];
//    }
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

@end
