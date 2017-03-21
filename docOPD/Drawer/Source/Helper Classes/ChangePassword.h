//
//  ChangePassword.h
//  docOPD
//
//  Created by Virinchi Software on 11/5/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFloatLabelTextField.h"
@interface ChangePassword : UIViewController<ServerRequestFinishedProtocol, UITextViewDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate>{
    UITextField *txtActiveField;
    BOOL keyboardHasAppeard,isBtnTapped;
    UIView *inputAccessoryView;
    UIButton *Done;
    ServerRequestType currentRequestType;
    NSUserDefaults *userdef;

}

@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFOldPwd;

@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFNewPwd;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFConfirmPwd;

@end
