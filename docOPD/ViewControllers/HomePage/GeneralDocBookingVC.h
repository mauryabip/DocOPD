//
//  GeneralDocBookingVC.h
//  docOPD
//
//  Created by Virinchi Software on 26/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYAlertPickView.h"
#import "RNGridMenu.h"
#import "ELCImagePickerHeader.h"
#import "UIFloatLabelTextField.h"
#import "SelectFamilyVC.h"


@interface GeneralDocBookingVC : UIViewController<UIAlertViewDelegate,DYAlertPickViewDataSource, DYAlertPickViewDelegate,ServerRequestFinishedProtocol,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate,RNGridMenuDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
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
    UIDatePicker *datePicker;
    UIView *inputAccessoryView;
    UIButton *Done;
    NSMutableString *dataPath;
    NSString *radilogyClickedStr;
    NSInteger indexNo;
    CGSize resulation;
    
    NSString *name;
    NSString *Age;
    NSString *gender;
    NSString *userID;
    NSString *emailId;
    NSString *mobileNumber;
    NSString * dateString;
    
    NSInteger scrollHT;
    NSInteger keybordScrollHT;
    NSString *message;
    NSString *serviceID;
    NSMutableArray *labData;
    NSArray *labDataRecord;
    NSInteger indexSelected;
    NSString *screenName;
}

@property(strong, nonatomic)NSString*popupSelection;
@property (weak, nonatomic) IBOutlet UILabel *lblMakeAppointment;
@property (weak, nonatomic) IBOutlet UILabel *screenTitleNameLbl;

@property(strong, nonatomic)NSString*titleName;
@property(strong, nonatomic)NSString*LabTitleId;
@property (nonatomic) BOOL textViewEmpty;
- (IBAction)showFamilyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *familyNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *familyImgView;

@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *MobileNoTextField;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *firstNameTextField;

@property (strong, nonatomic) IBOutlet UIView *ViewImgNameHolder;
@property (weak, nonatomic) IBOutlet UITextField *datetimeTXT;

@property (strong, nonatomic) IBOutlet UIView *CountryView;
@property (strong, nonatomic) IBOutlet UILabel *LblNote;

@property(strong, nonatomic)NSString*comeFrom;

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

//upperviews
@property (strong, nonatomic)  NSString *controllerName;
@property (strong, nonatomic) IBOutlet UIView *DocInfoView;
@property (weak, nonatomic) IBOutlet UIView *radiologyView;
@property (weak, nonatomic) IBOutlet UIButton *radilogyBtn;
@property (weak, nonatomic) IBOutlet UIButton *pathologyBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomViewTOPConst;
@property (weak, nonatomic) IBOutlet UICollectionView *pathologyCollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upperViewHTConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionTopConst;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeTOPConst;

@property (weak, nonatomic) IBOutlet UIView *borderView;



@property (strong, nonatomic) IBOutlet UIView *viewinfoHolder;
@property (strong, nonatomic) IBOutlet UIImageView *imgName;

@property (strong, nonatomic) IBOutlet UIImageView *imgMobile;

@property (strong, nonatomic) IBOutlet UIImageView *imgEmail;

@property (strong, nonatomic) IBOutlet UIView *viewFooter;

@property (strong, nonatomic) IBOutlet UILabel *LblTerm;
@property (strong, nonatomic) IBOutlet UIButton *BtnBookNow;
@property (strong, nonatomic) IBOutlet UILabel *Lbl1Num;
@property (strong, nonatomic) IBOutlet UILabel *Lbl2Num;
@property (weak, nonatomic) IBOutlet UIButton *seletDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;


@property (strong, nonatomic) IBOutlet UIButton *BtnAttachment;

@property(nonatomic,strong)NSString*docid;
@property (strong, nonatomic) IBOutlet UIView *viewImageHolder;


-(void)DoctorDataName:(NSString*)Name DocSpecility:(NSString*)Speciality DoctorDegree:(NSString*)Degree DocImg:(NSString*)imgURL;
-(void)HospitalDataName:(NSString*)Name HospitalType:(NSString*)type HospitalAddress:(NSString*)address HospitalImg:(NSString*)imgURL;

@property (nonatomic, strong)NSMutableDictionary *HospitalData;
- (IBAction)selectDateAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *writeNoteTXT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeTXTLeadingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeTXTWtConst;
@property (weak, nonatomic) IBOutlet UICollectionView *listCollectionView;


@end
