//
//  ViewController.h
//  docOPD
//
//  Created by Ashutosh Kumar on 7/31/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFloatLabelTextField.h"
@interface ViewController : UIViewController<UITextFieldDelegate,ServerRequestFinishedProtocol>{
    UIView *inputAccessoryView;
    UIButton *Done;
    BOOL keyboardHasAppeard;
    ServerRequestType currentRequestType;
    NSInteger status;
    NSUserDefaults *userdef;
    BOOL LoginBtnTapped;
    NSString *mediaPath;
    NSMutableString *dataPath;
    UIView *errorView;
}
@property (strong, nonatomic) IBOutlet  UIFloatLabelTextField*TFMobile;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtActiveField;
@property (strong, nonatomic) IBOutlet UIButton *LoginBtn;
@property (strong, nonatomic) IBOutlet UIButton *ForgetBtn;
- (IBAction)UserLogin:(id)sender;
- (IBAction)ResetPassword:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UIView *ContentView;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@end

