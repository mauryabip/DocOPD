//
//  ResetPassVC.h
//  docOPD
//
//  Created by Ashutosh Kumar on 8/1/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFloatLabelTextField.h"
@interface ResetPassVC : UIViewController<ServerRequestFinishedProtocol, UITextFieldDelegate, UIAlertViewDelegate>{
    BOOL isBtnTapped;
    ServerRequestType currentRequestType;
    NSInteger status;
    UIView *inputAccessoryView;
    UIButton *Done;
    BOOL keyboardHasAppeard;
    UIView *errorView;
    NSUserDefaults *userdef;

}
@property (strong, nonatomic) IBOutlet UITextField *TFMobile;
@property (strong, nonatomic) UIFloatLabelTextField *txtActiveField;
@property (strong, nonatomic) IBOutlet UIButton *ResetPassBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *Scroller;
@property (weak, nonatomic) IBOutlet UIView *ContentView;

@end