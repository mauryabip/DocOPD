//
//  NewPasswordViewController.h
//  docOPD
//
//  Created by Virinchi Software on 10/21/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFloatLabelTextField.h"
@interface NewPasswordViewController : UIViewController<UITextFieldDelegate,ServerRequestFinishedProtocol,UIAlertViewDelegate>{
    BOOL isBtnTapped;
    ServerRequestType currentRequestType;
    NSInteger status;
    UIView *inputAccessoryView;
    UIButton *Done;
    BOOL keyboardHasAppeard;
    UIView *errorView;
}
@property (strong,nonatomic)NSString *MobileNumberForChangePassword;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFNewPwd;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFConfirmPwd;
@property (strong, nonatomic) IBOutlet UIButton *BtnChangePwd;
@property (nonatomic,strong) UITextField *txtActiveField;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@end
