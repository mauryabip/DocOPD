//
//  DocBookingViewController.h
//  docOPD
//
//  Created by Virinchi Software on 11/6/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYAlertPickView.h"
#import "RNGridMenu.h"
#import "ELCImagePickerHeader.h"
#import "UIFloatLabelTextField.h"
#import "SelectFamilyVC.h"

@interface DocBookingViewController : UIViewController<UIAlertViewDelegate,DYAlertPickViewDataSource, DYAlertPickViewDelegate,ServerRequestFinishedProtocol,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate,RNGridMenuDelegate>{
    NSString *docname, *docSpec, *docDegree, *hosName, *hosType, *hosAdd,*docImgUrl, *HosImgURL;
    BOOL keyboardHasAppeard, isDateSelected,isBookNowClicked;
    UITextField *activeField;
    NSInteger weekday,status;
    NSUserDefaults *userdef;
    ServerRequestType currentRequestType;
    NSMutableArray *imginfo;
    NSInteger count;
    NSMutableArray *imgIDInfo;
    UIView *errorView;
    UIView *inputAccessoryView;
    UIButton *Done;
    NSString *name;
    NSString *userID;
    NSString *emailId;
    NSString *mobileNumber;
    NSString *bookingId;
    NSString *messageSuccess;
    NSMutableArray *dataArr;
}

@property (nonatomic) BOOL textViewEmpty;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *MobileNoTextField;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *firstNameTextField;

@property (strong, nonatomic) IBOutlet UIView *ViewImgNameHolder;

@property (strong, nonatomic) IBOutlet UIView *CountryView;
@property (strong, nonatomic) IBOutlet UILabel *LblNote;

@property(strong, nonatomic)NSString*comeFrom;
@property(strong, nonatomic)NSString*DocSpeciality;

@property (strong, nonatomic) IBOutlet UIView *ViewhospimgBorder;
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
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UIView *DocInfoView;
@property (strong, nonatomic) IBOutlet UIButton *BtnDate;
@property (strong, nonatomic) IBOutlet UIButton *BtnTime;
@property (strong, nonatomic) IBOutlet UILabel *Lbl3Num;

@property (strong, nonatomic) IBOutlet UIView *viewinfoHolder;
@property (strong, nonatomic) IBOutlet UIImageView *imgName;

@property (strong, nonatomic) IBOutlet UIImageView *imgMobile;

@property (strong, nonatomic) IBOutlet UIImageView *imgEmail;

@property (strong, nonatomic) IBOutlet UIView *viewFooter;

@property (strong, nonatomic) IBOutlet UILabel *LblTerm;
@property (strong, nonatomic) IBOutlet UIButton *BtnBookNow;
@property (strong, nonatomic) IBOutlet UILabel *Lbl1Num;
@property (strong, nonatomic) IBOutlet UILabel *Lbl2Num;


@property (strong, nonatomic) IBOutlet UIButton *BtnAttachment;

@property(nonatomic,strong)NSString*docid;
@property (strong, nonatomic) IBOutlet UIView *viewImageHolder;

- (IBAction)changeFamilyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UIView *holderView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UITextView *writeNoteTXT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeLeadingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeWTConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeTOPConst;




-(void)DoctorDataName:(NSString*)Name DocSpecility:(NSString*)Speciality DoctorDegree:(NSString*)Degree DocImg:(NSString*)imgURL;
-(void)HospitalDataName:(NSString*)Name HospitalType:(NSString*)type HospitalAddress:(NSString*)address HospitalImg:(NSString*)imgURL;

@property (nonatomic, strong)NSMutableDictionary *HospitalData;
@end
