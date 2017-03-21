//
//  ReplyOnEnquiryVC.m
//  docOPD
//
//  Created by Ashu on 18/01/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "ReplyOnEnquiryVC.h"
#import "UIImageView+WebCache.h"
#import "HDNotificationView.h"
@interface ReplyOnEnquiryVC ()

@end

@implementation ReplyOnEnquiryVC
@synthesize ImgUser;
@synthesize txtViewActive;
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self setupErrorview];
    [self registerForKeyboardNotifications];
    userdef = userDefault;
    keyboardHasAppeard = false;
    self.LblDocName.text = [self.enquiryData valueForKey:@"Docname"];
    self.LblHospName.text = [self.enquiryData valueForKey:@"HospitalName"];
    self.LblOldEnqText.text = [self.enquiryData valueForKey:@"UserComment"];

    self.LblOldEnqText.numberOfLines = 0;
    self.LblOldEnqText.lineBreakMode = NSLineBreakByWordWrapping;
    [self.LblOldEnqText sizeToFit];
    
    [self.ImgDoc sd_setImageWithURL:[NSURL URLWithString:[self.enquiryData valueForKey:@"DocPicURL"]]
                   placeholderImage:[UIImage imageNamed:@"doctor-96.png"]
                            options:SDWebImageRefreshCached];
    self.ImgDoc.layer.cornerRadius = self.ImgDoc.frame.size.width/2;
    self.ImgDoc.layer.masksToBounds = YES;
    
    self.DocImgBackView.layer.cornerRadius = self.DocImgBackView.frame.size.width/2;
    self.DocImgBackView.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    self.DocImgBackView.layer.borderWidth = 1.0;
    
    ImgUser.image = [self getImage:@"MyProfileImage.png"];
    ImgUser.layer.cornerRadius = ImgUser.frame.size.width/2;
    ImgUser.layer.masksToBounds = YES;
    
    self.userImgbackView.layer.borderWidth = 1.0f;
    self.userImgbackView.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    self.userImgbackView.layer.cornerRadius = self.userImgbackView.frame.size.width/2;
    
    self.OldPostView.layer.borderWidth = 1.0f;
    self.OldPostView.layer.borderColor = [UIColor dOPDTFBorderColor].CGColor;
    self.OldPostView.layer.cornerRadius = 4.0;
    
    self.TVReplyContent.text = @"";
    [self.TVReplyContent becomeFirstResponder];
    self.TVReplyContent.delegate = self;
    [self setupTextView:self.TVReplyContent];
    [self OldPostViewResizer];
    [Localytics tagEvent:@"Enquiry reply"];
    [self ScrollResizer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Reply on Enquiry"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


-(void)setupTextView:(UITextView*)textview{
    // you might have to play around a little with numbers in CGRectMake method
    // they work fine with my settings
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, textview.frame.size.width - 10.0, 34.0)];
    [placeholderLabel setText:@"Write something here"];
    // placeholderLabel is instance variable retained by view controller
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    placeholderLabel.font = [UIFont systemFontOfSize:13.0];
    
    // textView is UITextView object you want add placeholder text to
    [textview addSubview:placeholderLabel];
}


#pragma mark - TextView Delegate

- (void) textViewDidChange:(UITextView *)textView
{
    if(![textView hasText]) {
        [textView addSubview:placeholderLabel];
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 1.0;
        }];
    } else if ([[textView subviews] containsObject:placeholderLabel]) {
        
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [placeholderLabel removeFromSuperview];
        }];
    }
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (![textView hasText]) {
        [textView addSubview:placeholderLabel];
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 1.0;
        }];
    }
}

#pragma mark - Back Button Action
- (IBAction)didPressBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Reply Button Action
- (IBAction)didPressReplyBtn:(id)sender {
    [Localytics tagEvent:@"Enquiry reply submit"];
    if (!ReplyBtnTapped) {
        if (![self.TVReplyContent hasText]) {
            [self ViewSlideDown:@"Write something about your problem."];
             ReplyBtnTapped = false;
        }else{
            ReplyBtnTapped = YES;
            [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:.000];
        }
    }
}

#pragma mark - GetImage
- (UIImage*)getImage: (NSString*)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    dataPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:@"Media"];
    NSString *getImagePath = [dataPath stringByAppendingPathComponent:filename];
//    NSLog(@"Get image path: %@",getImagePath);
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
    
}

#pragma mark - Old Post View Resizer
-(void)OldPostViewResizer{
    CGRect frame = self.OldPostView.frame;
    frame.size.height = self.LblOldEnqText.frame.size.height + self.LblOldEnqText.frame.origin.y +20;
    self.OldPostView.frame = frame;
    
    
}


#pragma mark - Scroll View Resizer
-(void)ScrollResizer{
    CGRect frame = self.ContentView.frame;
    frame.size.height = self.OldPostView.frame.size.height + self.OldPostView.frame.origin.y +10;
    self.ContentView.frame = frame;
    [self.Scroller setContentSize:CGSizeMake(self.Scroller.frame.size.width, self.ContentView.frame.size.height)];
    
    //[self.Scroller setContentOffset:CGPointMake(0, self.ContentView.frame.size.height) animated:YES];
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
    [txtViewActive resignFirstResponder];
    [self.Scroller setContentOffset:CGPointMake(0, 0) animated:YES];
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
    self.Scroller.scrollIndicatorInsets = contentInsets;
    
    //scrolling the active field to visible area
   // if ((nil != txtViewActive) && (keyboardHasAppeard == NO))
    
    CGRect frame = self.viewFooter.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - kbSize.height-self.viewFooter.frame.size.height;
    
    //self.LblOldEnqText.frame.size.height + self.LblOldEnqText.frame.origin.y +20;
    self.viewFooter.frame = frame;
      //  [self.Scroller scrollRectToVisible:[self getPaddedFrameForView:self.viewFooter] animated:YES];
    
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



#pragma mark - Service Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"" Message:@"Your query is \nbeing submitting"];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kSetEnquiryReply], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[userdef objectForKey:AuthKey]],AuthKey,[NSString stringWithFormat:@"%@",self.TVReplyContent.text],userComment,[NSString stringWithFormat:@"%@",[self.enquiryData valueForKey:EnquiryID]],EnquiryID,nil];
    
//    NSLog(@"dataDic for ApiCalling for enquiry reply: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kSetEnquiryReply;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling for enquiry reply");
    
}


#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    
    [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
    
//    NSLog(@"enquiry reply view controller requestFinished");
}



#pragma mark - result methods for booking enquiry service
- (void) result:(NSDictionary *)response

{
//    NSLog(@"response for enquiry reply = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    NSDictionary *resposeCode=[response objectForKey:@"Enquiry Reply Status"];
    NSString *message=[resposeCode objectForKey:@"Message"];
    status=[[resposeCode objectForKey:@"Status"] integerValue];
    
    if (status == 0)
    {
//        NSLog(@"On the doc enquiry reply");
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"DocOPD" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        ReplyBtnTapped = false;
        [alert show];
    }
    
    else if (status == 1){
//        NSLog(@"status message = %@",message);
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:message preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *OKBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//        [alert addAction:OKBtn];
//        [self presentViewController:alert animated:YES completion:nil];
        [self ViewSlideDown:message];
        ReplyBtnTapped = false;
    }
}

- (void) requestError
{
    ReplyBtnTapped = false;
//    NSLog(@"doc enquiry reply  View Controller error");
    [[AppDelegate MyappDelegate] hideIndicator];
     [self ViewSlideDown:@"Something went wrong"];
    
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
        //        msg.textAlignment = NSTextAlignmentCenter;
        msg.numberOfLines =2;
        msg.tag = 99;
        //        msg.lineBreakMode = NSLineBreakByWordWrapping;
        //        [msg sizeToFit];
        msg.textColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        msg.font = [UIFont systemFontOfSize:14.0];
        [errorView addSubview:msg];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 delay:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            errorView.frame  = CGRectMake(0, -84, [UIScreen mainScreen].bounds.size.width,84);
            
        } completion:^(BOOL finished) {
            ReplyBtnTapped = NO;
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
        [self performSelector:@selector(didPressBack:) withObject:nil afterDelay:3.0];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
