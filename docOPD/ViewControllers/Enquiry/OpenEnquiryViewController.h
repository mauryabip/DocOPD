//
//  OpenEnquiryViewController.h
//  docOPD
//
//  Created by Virinchi Software on 1/30/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFloatLabelTextField.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "RNGridMenu.h"
#import "ELCImagePickerHeader.h"
#import "UIFloatLabelTextField.h"
#import "SelectFamilyVC.h"

@interface OpenEnquiryViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,ServerRequestFinishedProtocol,UIAlertViewDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate,RNGridMenuDelegate,UIGestureRecognizerDelegate>{
    NSUserDefaults *userdef;
    ServerRequestType currentRequestType;
    NSString *specialiesName;
    NSString *procName;
    NSInteger status;
    BOOL isEnquiryClicked,keyboardHasAppeard;
    UITextField *activeField;
    UIView *inputAccessoryView;
    UIButton *Done;
    UILabel *placeholderLabel;
    UIView *errorView;
    NSMutableArray *imginfo;
    NSString *name;
    NSString *userID;
    NSString *emailId;
    NSString *mobileNumber;
    NSInteger count;
    NSMutableArray *imgIDInfo;
    NSString *enquiryID;
    NSMutableArray *dataArr;
}
@property (strong, nonatomic) IBOutlet UIButton *BtnSubmit;
- (IBAction)didPressDismissBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFFullName;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFMobile;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFEmail;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFEnqFor;
@property (strong, nonatomic) IBOutlet UITextView *TVEnquiry;

@property (weak, nonatomic) IBOutlet UIButton *enquiryBtn;

@property (strong, nonatomic) IBOutlet UIView *ViewCountry;
@property(nonatomic, strong) AVAudioPlayer *audioPlayer;
@property(strong,nonatomic)NSString *comeFrom;
@property(strong,nonatomic)NSString *titleName;

@property(strong,nonatomic)NSString *doctorID;
@property(strong,nonatomic)NSString *hospID;
@property(strong,nonatomic)NSString *specID;
@property(strong,nonatomic)NSString *procedureID;
@property (nonatomic) BOOL textViewEmpty;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UIView *Contentview;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (strong, nonatomic) IBOutlet UIView *viewImageHolder;
- (IBAction)attachmentAction:(id)sender;
- (IBAction)changeFamilyAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeTxtWTConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeTxtLeadingConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeTOPConst;

@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UIView *holderView;


@end
