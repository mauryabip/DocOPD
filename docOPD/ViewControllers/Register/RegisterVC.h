//
//  RegisterVC.h
//  docOPD
//
//  Created by Ashutosh Kumar on 7/31/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFloatLabelTextField.h"
@interface RegisterVC : UIViewController<ServerRequestFinishedProtocol,UITextFieldDelegate>
{
    NSUserDefaults *userdef;
    NSInteger status;
    ServerRequestType currentRequestType;
    UIView *inputAccessoryView;
    UIButton *Done;
    BOOL keyboardHasAppeard;
    BOOL isRegisterClicked;
    UIView *errorView;
//    UIFloatLabelTextField *emailTextField;
//    UIFloatLabelTextField *MobileNoTextField;
//    UIFloatLabelTextField *FullNameTextField;
//    UIFloatLabelTextField *PasswordTextField;
    
}
@property (strong, nonatomic) IBOutlet UIView *FullnameView;
@property (strong, nonatomic) IBOutlet UIButton *BtnTnc;

@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFFullName;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFMobile;

@property (strong, nonatomic) IBOutlet UIView *EmailView;

@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFEmail;
@property (strong, nonatomic) IBOutlet UIFloatLabelTextField *TFpassword;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (strong, nonatomic) IBOutlet UIButton *BtnBack;

@property (strong, nonatomic) IBOutlet UIButton *BtnRegister;
@property (strong,nonatomic)UITextField *txtActiveField;
- (IBAction)GoBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *BtnSignIn;

@property (strong, nonatomic) IBOutlet UIView *InfoFillView;



@end
