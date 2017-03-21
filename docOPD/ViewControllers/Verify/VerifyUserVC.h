//
//  VerifyUserVC.h
//  docOPD
//
//  Created by Virinchi Software on 10/21/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFloatLabelTextField.h"
@protocol Dismiss <NSObject>

- (void)dismissAndPush:(UIViewController *)vc ;

@end


@interface VerifyUserVC : UIViewController<ServerRequestFinishedProtocol,UITextFieldDelegate>
{
    UIButton *Done;
    UIView *inputAccessoryView;
    NSUserDefaults *userdef;
    ServerRequestType currentRequestType;
    NSInteger status;
    BOOL keyboardHasAppeard;
    BOOL isBtnTapped;
    UIView *errorView;
}
@property (nonatomic,retain)id delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *Scroller;
@property (nonatomic,strong)UITextField *txtActiveField;
@property (nonatomic,strong)NSString *PushThrough;
@property (nonatomic,strong)NSString *mobNumber;
@property (nonatomic,strong)NSString *relationUserId;
@property (weak, nonatomic) IBOutlet UIView *ContentView;
@property (weak, nonatomic) IBOutlet UIButton *BtnSignIn;
@property (weak, nonatomic) IBOutlet UIButton *BtnVerify;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *TFVerificationCode;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UIButton *backToFamilyBtn;
- (IBAction)backToFamilyAction:(id)sender;


@end
