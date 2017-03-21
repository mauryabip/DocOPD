//
//  MyProfileVC.h
//  docOPD
//
//  Created by Virinchi Software on 11/4/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"
#import "SlideNavigationController.h"
#import "UIFloatLabelTextField.h"
@interface MyProfileVC : UIViewController<ServerRequestFinishedProtocol,UIGestureRecognizerDelegate,UITextFieldDelegate, UIActionSheetDelegate,RNGridMenuDelegate,SlideNavigationControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>{
    UITextField *lastTF;
    UITextField *activeTF;
    BOOL isBtnTapped,isanythingChange;
    ServerRequestType currentRequestType;
    UITextField *txtActiveField;
    NSUserDefaults *userDef;
    NSString*mediaPath;
    NSMutableString *dataPath;
    UIView *inputAccessoryView;
    UIButton *Done;
    BOOL keyboardHasAppeard;
    NSString *oldValue;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHTConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHTConst;
@property (strong, nonatomic) IBOutlet UILabel *LblMobile;
@property (strong, nonatomic) IBOutlet UIView *viewImgBorder;
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UIView *ViewVisible;

@property (strong, nonatomic) IBOutlet UIView *ViewImgNameHolder;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFUserName;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFUserPassword;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFUserMobile;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFUserAddress;
@property (strong, nonatomic) IBOutlet UILabel *LblSep;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroll;
@property (strong, nonatomic) IBOutlet UIButton *BtnUpdate;
@property (strong, nonatomic) IBOutlet UIButton *BtnUploadImg;
@property(nonatomic, assign)id delegate;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFUserGender;
@end
@protocol sliderimagechange <NSObject>

-(void)imageupdateforSlider;

@end
