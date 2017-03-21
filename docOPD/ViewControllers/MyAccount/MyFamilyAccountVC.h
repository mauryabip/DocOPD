//
//  MyFamilyAccountVC.h
//  docOPD
//
//  Created by Virinchi Software on 24/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileDetailViewController.h"
#import "termsViewController.h"
#import "MyFamilyVC.h"
#import "AddFamilyVC.h"



@interface MyFamilyAccountVC : UIViewController<UIActionSheetDelegate>{
    NSUserDefaults *userDef;
    NSMutableString *dataPath;
    
}
- (IBAction)settingAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *borderView;

- (IBAction)BounceMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *BounceMenu;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
- (IBAction)openMyAccountAction:(id)sender;
- (IBAction)myFamilyAction:(id)sender;
- (IBAction)membershipAction:(id)sender;
- (IBAction)referAction:(id)sender;
@end
