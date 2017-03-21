//
//  DocEnquiryViewController.h
//  docOPD
//
//  Created by Virinchi Software on 11/10/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"
#import "ELCImagePickerHeader.h"
#import "UIFloatLabelTextField.h"
#import "SelectFamilyVC.h"

@interface DocEnquiryViewController : UIViewController<UITextViewDelegate,ServerRequestFinishedProtocol,UIAlertViewDelegate,UIGestureRecognizerDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate,RNGridMenuDelegate,UIScrollViewDelegate>{
    NSUserDefaults *userdef;
    BOOL keyboardHasAppeard,isEnquiryClicked;
    UIView *inputAccessoryView;
    UITextField *activeField;
    UIButton *Done;
    NSInteger status;
    NSString *docname, *docId, *docDegree, *hosName, *hosType, *hosAdd,*docImgUrl, *HosImgURL;
    ServerRequestType currentRequestType;
    UIView *errorView;
    NSMutableArray *imginfo;
    NSString *name;
    NSString *userID;
    NSString *emailId;
    NSString *mobileNumber;
    NSInteger count;
    NSMutableArray *imgIDInfo;
    NSString *enquiryID;
    NSString *messageSuccess;
    CGSize resulation;
    NSMutableArray *dataArr;
}
@property (strong, nonatomic) IBOutlet UIButton *BtnBack;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) IBOutlet UIView *Contentview;
@property (strong, nonatomic) IBOutlet UIImageView *imgDoc;
@property (strong, nonatomic) IBOutlet UILabel *LblDocName;
@property (strong, nonatomic) IBOutlet UILabel *LblDocSpec;
@property (strong, nonatomic) IBOutlet UILabel *LblDocDegree;
@property (strong, nonatomic) IBOutlet UIView *ViewDocImgBorder;
@property (strong, nonatomic) IBOutlet UIView *ViewHosImgBorder;
@property (strong, nonatomic) IBOutlet UIImageView *ImgHospital;
@property (strong, nonatomic) IBOutlet UILabel *LblHosName;
@property (strong, nonatomic) IBOutlet UILabel *LblHosType;
@property (strong, nonatomic) IBOutlet UILabel *LblHosAddress;
@property (strong, nonatomic) IBOutlet UILabel *Lbl1Num;
@property (strong, nonatomic) IBOutlet UILabel *Lbl2Num;
@property (strong, nonatomic) IBOutlet UIImageView *imgName;
@property (strong, nonatomic) IBOutlet UIImageView *imgMobile;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmail;
@property (strong, nonatomic) IBOutlet UIView *viewinfoHolder;
@property (strong, nonatomic) IBOutlet UIView *ViewDocInfo;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (strong, nonatomic) NSMutableDictionary *doctorDic;
@property (nonatomic) BOOL textViewEmpty;
@property (strong, nonatomic) NSMutableDictionary *hospitalDic;
@property (strong, nonatomic) IBOutlet UITextView *TVComment;
@property (strong, nonatomic)NSString *comeFrom;
@property (strong, nonatomic) NSMutableDictionary *enquiryData;
@property (strong, nonatomic) IBOutlet UIView *viewCountry;
@property (strong, nonatomic) IBOutlet UIView *viewImageHolder;
- (IBAction)attachmentAction:(id)sender;
- (IBAction)changeFamilyAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeTxtWTConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeTxtLeadingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeTTOPConst;


@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UIView *holderView;

@end
