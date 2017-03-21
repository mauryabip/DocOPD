//
//  OTPViewController.h
//  docOPD
//
//  Created by Virinchi Software on 10/21/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFloatLabelTextField.h"
@interface OTPViewController : UIViewController<UITextFieldDelegate,ServerRequestFinishedProtocol>{
    BOOL isBtnTapped;
    ServerRequestType currentRequestType;
    NSInteger status;
    UIView *inputAccessoryView;
    UIButton *Done;
    BOOL keyboardHasAppeard;
    UIView *errorView;
}
@property (nonatomic,strong) UITextField *txtActiveField;
@property (nonatomic,strong) NSString *MobileNumberForOTP;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *TFOTP;
@property (weak, nonatomic) IBOutlet UIScrollView *Scroller;
@property (weak, nonatomic) IBOutlet UIView *ContentView;
@end
