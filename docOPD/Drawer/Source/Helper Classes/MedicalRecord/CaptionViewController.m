//
//  CaptionViewController.m
//  docOPD
//
//  Created by Virinchi Software on 2/4/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "CaptionViewController.h"

@interface CaptionViewController ()

@end

@implementation CaptionViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showGrid];
    keyboardHasAppeard = NO;
    self.textViewEmpty=YES;
    userdef = userDefault;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    CGRect rect = self.ContentView.frame;
 
    self.ContentView.frame = rect;
    self.ScrollView.contentSize = CGSizeMake(self.ScrollView.frame.size.width, self.ContentView.frame.size.height);

    CaptiontextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width-10, 34)];
    CaptiontextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self setupTextView:CaptiontextView];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10; // for example shift right bar button to the right

    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithCustomView:CaptiontextView];
    self.toolbar.items = [NSArray arrayWithObjects:spacer,barItem, nil];
    self.toolbar.hidden= YES;
    [self.ViewTextviewholder addSubview:CaptiontextView];
    self.ImgView.userInteractionEnabled = YES;
    self.ViewTextviewholder.backgroundColor = [UIColor colorWithRed:227.0 green:227.0 blue:227.0 alpha:1.0];
//    NSLog(@"grand parent %@, parent = %@",self.grandParent,self.parentFolder);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hidekeyboard)];
    tap.numberOfTapsRequired = 1.0;
    [self.view addGestureRecognizer:tap];
    [self.ImgView addGestureRecognizer:tap];
    [self.btnSave setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _previousContentHeight =   CaptiontextView.contentSize.height;
    CaptiontextView.enablesReturnKeyAutomatically = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"InsertCaptionScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"InsertCaptionScreen"];
}

-(void)viewDidAppear:(BOOL)animated{
    [self registerForKeyboardNotifications];
}

-(void)hidekeyboard {
    [self.view endEditing:YES];
}

#pragma mark - RNGridMenuDelegate

- (void)gridMenuWillDismiss:(RNGridMenu *)gridMenu{
    [Localytics tagEvent:@"InsertCaptionAlbumImageClick"];
 //   NSLog(@"gridMenuWillDismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
  //  NSLog(@"Dismissed with item %ld: %@", (long)itemIndex, item.title);
    
    switch (itemIndex) {
        case 0:
        //    NSLog(@"case 0, Gallery, Opening gallery");
            [self imagePickFromGallery];
            break;
            
        case 1:
       //     NSLog(@"case 1");
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
    PickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    // NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    //  self.imgUser.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    self.ImgView.image = image;
    [self.btnSave setTitleColor:[UIColor dOPDThemeColor] forState:UIControlStateNormal];
   // self.ImgView.contentMode = UIViewContentModeScaleAspectFill;
    
//    [self ImgToBase64:image];
//    [self saveImage:image];
//    [self saveInfo];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
   //    NSLog(@"imagePickerControllerDidCancel");
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
   
    
}


-(void)ImgToBase64:(UIImage*)image{
    NSString*base64str =  [self imageToNSString:image];
 //   NSLog(@"Base 64= %@",base64str);
    
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
    
    base64EncodedString = [imageData base64EncodedStringWithOptions:0];
    return base64EncodedString;
}


-(void)saveImage:(UIImage*)image{
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    //  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //  NSString *documentsDirectory = [paths objectAtIndex:0];
    imageName = [NSString stringWithFormat:@"%@-%@-%@.png",self.grandParent,self.parentFolder,[self GetLocalTimeStamp]];
//    NSLog(@"image name = %@",imageName);
    // NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
    
    NSString *localpath = [NSString stringWithFormat:@"%@/%@/%@",[[AppDelegate MyappDelegate]medicalRecordPath],self.grandParent,self.parentFolder];
    
    NSString *savedImagePath = [localpath stringByAppendingPathComponent:imageName];
    
 //   NSLog(@"save path= %@",savedImagePath);
    [imageData writeToFile:savedImagePath atomically:NO];
//    [self updateImgArray];
//    [self.collectionView reloadData];
    
}
-(NSString *)GetLocalTimeStamp{
    //    NSDate *localDate = [NSDate date];
    //    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; // You could also use the systemTimeZone method
    //    NSTimeInterval gmtTimeInterval = [localDate timeIntervalSinceReferenceDate] - timeZoneOffset;
    //    NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
    //    NSString * timeStamp = [NSString stringWithFormat:@"%f",[gmtDate timeIntervalSince1970]];
    //    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    
    //    NSLog(@"Time Stamp= %@",timeStamp);
    //    NSLog(@"timeInMiliseconds = %f",timeInMiliseconds);
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
//    NSLog(@" milliseconds= %lld",milliseconds);
    NSString *timeStamp = [NSString stringWithFormat:@"%lld",milliseconds];
    return timeStamp;
}




- (void)saveInfo{
    // Prepare the query string.
    NSString *imgid = [userdef objectForKey:medicalImgID];
    NSString *caption= [CaptiontextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    imageName = [NSString stringWithFormat:@"%@-%@-%@.png",self.grandParent,self.parentFolder,[self GetLocalTimeStamp]];
    NSString *query = [NSString stringWithFormat:@"INSERT INTO medicalRecord (user_id,album_name,upload_status,report_type,upload_image,image_name,image_tag, image_id,album_id) VALUES('%@', '%@','%@','%@', '%@','%@' ,'%@','%@','%@')",[userdef objectForKey:User_id],self.grandParent,@"0",self.parentFolder,base64EncodedString,imageName,caption?caption:@"",imgid?imgid:@"",self.folderid?self.folderid:@""];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
  //      NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        [delegate updateImage];
        NSInteger med_id = imgid.integerValue +1;
        imgid = [NSString stringWithFormat:@"%ld",(long)med_id];
        [userdef setObject:imgid forKey:medicalImgID];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else{
     //   NSLog(@"Could not execute the query.");
    }
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
    _previousContentHeight = textView.frame.size.height;
    CGFloat maxHeight = 90.0f;
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), fminf(newSize.height, maxHeight));
    textView.frame = newFrame;
    CGRect inputrect;
    if (_previousContentHeight<newSize.height) {
        inputrect = self.ViewTextviewholder.frame;
        inputrect.origin.y = inputrect.origin.y -(newFrame.size.height-_previousContentHeight);
        inputrect.size.height = inputrect.size.height+(newFrame.size.height-_previousContentHeight);
        self.ViewTextviewholder.frame = inputrect;
        
        
    }else if (_previousContentHeight>newSize.height){
        inputrect = self.ViewTextviewholder.frame;
        inputrect.origin.y = inputrect.origin.y +(_previousContentHeight-newFrame.size.height);
        inputrect.size.height = inputrect.size.height-(_previousContentHeight-newFrame.size.height);
        self.ViewTextviewholder.frame = inputrect;
        
    }
    
    
    
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
        self.textViewEmpty = YES;
        [textView addSubview:placeholderLabel];
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 1.0;
        }];
        
    }else {
        self.textViewEmpty = NO;
    }
}


- (IBAction)didPressSaveBtn:(id)sender {
    [self ImgToBase64:PickedImage];
    //[self saveImage:PickedImage];
    [self saveInfo];
  [Localytics tagEvent:@"InsertCaptionSaveButtonClick"];
}

- (IBAction)didPressCancelBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    inputviewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - inputviewFrame.size.height;
    self.ViewTextviewholder.frame = inputviewFrame;

    [UIView commitAnimations];
    
    keyboardHasAppeard = NO;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
