//
//  AddFamilyVC.h
//  docOPD
//
//  Created by Virinchi Software on 26/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"
#import "SlideNavigationController.h"
#import "UIFloatLabelTextField.h"
#import "docOPDNetworkEngine.h"
#import "UIImageView+WebCache.h"

@interface AddFamilyVC : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate, UIActionSheetDelegate,RNGridMenuDelegate,SlideNavigationControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIDatePicker *datePicker;
    UITextField *lastTF;
    UITextField *activeTF;
    UITextField *txtActiveField;
    NSUserDefaults *userDef;
    NSString*mediaPath;
    NSMutableString *dataPath;
    UIView *inputAccessoryView;
    UIButton *Done;
    BOOL keyboardHasAppeard;
    NSString *oldValue;
    NSArray *relationArray;
    NSString*base64str;
    
    BOOL isBtnTapped,isanythingChange;
}
@property (strong, nonatomic) IBOutlet UIView *viewImgBorder;
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UIView *ViewVisible;

@property (strong, nonatomic)  NSMutableArray *familyDataArr;
@property (strong, nonatomic)  NSString *controllerName;

@property (strong, nonatomic) IBOutlet UIView *ViewImgNameHolder;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFUserName;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFUserlastname;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFUserMobile;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFUserAddress;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFUserDOB;
- (IBAction)addFamilyAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)selectRelationshipAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addFamilyBtn;

@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *relationshipTXT;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroll;
@property (strong, nonatomic) IBOutlet UIButton *BtnUploadImg;
@property(nonatomic, assign)id delegate;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFUserGender;
@end
@protocol sliderimagechange <NSObject>

-(void)imageupdateforSlider;


@end
