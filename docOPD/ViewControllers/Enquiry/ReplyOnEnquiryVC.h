//
//  ReplyOnEnquiryVC.h
//  docOPD
//
//  Created by Ashu on 18/01/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyOnEnquiryVC : UIViewController<UITextViewDelegate,ServerRequestFinishedProtocol>{
    NSMutableString *dataPath;
    UIView *inputAccessoryView;
    UIButton *Done;
    BOOL keyboardHasAppeard;
    BOOL ReplyBtnTapped;
    UILabel *placeholderLabel;
    NSInteger status;
    ServerRequestType currentRequestType;
    NSUserDefaults *userdef;
  
     UIView *errorView;
}
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UIButton *BtnReply;

@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (strong, nonatomic) IBOutlet UIView *ReplyView;
@property (strong, nonatomic) UITextView *txtViewActive;
@property (strong, nonatomic) IBOutlet UIView *OldPostView;

@property (strong, nonatomic) IBOutlet UIView *userImgbackView;
@property (strong, nonatomic) IBOutlet UITextView *TVReplyContent;

@property (strong, nonatomic) IBOutlet UIImageView *ImgUser;
@property (strong, nonatomic) IBOutlet UIView *DocImgBackView;
@property (strong, nonatomic) IBOutlet UIImageView *ImgDoc;
@property (strong, nonatomic) IBOutlet UILabel *LblDocName;
@property (strong, nonatomic) IBOutlet UILabel *LblHospName;
@property (strong, nonatomic) IBOutlet UILabel *LblOldEnqText;
- (IBAction)didPressReplyBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (strong, nonatomic) NSMutableDictionary *enquiryData;
@end
