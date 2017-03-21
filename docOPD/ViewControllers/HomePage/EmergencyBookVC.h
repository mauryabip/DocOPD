//
//  EmergencyBookVC.h
//  docOPD
//
//  Created by Virinchi Software on 02/11/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYAlertPickView.h"
#import "RNGridMenu.h"
#import "ELCImagePickerHeader.h"
#import "UIFloatLabelTextField.h"
#import "SelectFamilyVC.h"

@interface EmergencyBookVC : UIViewController<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate,RNGridMenuDelegate,ServerRequestFinishedProtocol,UIGestureRecognizerDelegate>{
    
     NSUserDefaults *userdef;
    ServerRequestType currentRequestType;
    UITextField *activeField;
    BOOL keyboardHasAppeard;
    UIDatePicker *datePicker;
    UIView *inputAccessoryView;
    UIButton *Done;
    NSMutableArray *imginfo;
    NSInteger status;
    UIView *errorView;
    
    NSString *name;
     NSInteger count;
    BOOL  isBookNowClicked;
    NSString *Age;
    NSString *gender;
    NSString *userID;
    NSString *emailId;
    NSString *mobileNumber;
    NSString * dateString;
    
    NSInteger scrollHT;
    NSString *message;
    NSString *serviceID;;
    NSMutableArray *imgIDInfo;
    NSMutableArray *dataArr;

}
@property(strong, nonatomic)NSString*titleName;
@property(strong, nonatomic)NSString*screenName;
@property(strong, nonatomic)NSString*Lat;
@property(strong, nonatomic)NSString*Lon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeTOPConst;

@property (nonatomic) BOOL textViewEmpty;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UITextField *dateTXT;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *addressTXT;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *pinTXT;
@property (weak, nonatomic) IBOutlet UIView *imageHolderView;
@property (weak, nonatomic) IBOutlet UITextView *writeTXT;
@property (weak, nonatomic) IBOutlet UIButton *mapViewBtn;
- (IBAction)mapViewAction:(id)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeTxtWTConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeTxtLeadingConst;
@property (weak, nonatomic) IBOutlet UIView *borderView;






- (IBAction)bookAction:(id)sender;

- (IBAction)attachmentAction:(id)sender;

- (IBAction)changeFamilyAction:(id)sender;
- (IBAction)backAction:(id)sender;

@end
