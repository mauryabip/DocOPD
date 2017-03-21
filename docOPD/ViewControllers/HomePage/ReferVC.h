//
//  ReferVC.h
//  docOPD
//
//  Created by Virinchi Software on 05/11/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDNotificationView.h"
#import "docOPDNetworkEngine.h"


@interface ReferVC : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>{
     NSUserDefaults *userdef;
}
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *referTXT;
- (IBAction)submitAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)shareAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *referralCodeTXT;

@end
