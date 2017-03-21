//
//  ProfileDetailViewController.h
//  SlideMenu
//
//  Created by Aryan Gh on 4/25/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface ProfileDetailViewController : UIViewController <SlideNavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSUserDefaults *userDef;
    NSInteger status;
    UITableView *tbleview;
    NSMutableArray *array1;
    NSMutableArray *array2;
    NSDictionary *resposeCode;
    NSString *astrics;
    UIButton *EditNameButton, *lastclicked;
    UIButton *EditAddressButton;
    UIButton *EditEmailButton;
    UITextField *FullNameTF, *EmailTF, *addressTF;
    NSInteger lastCellTapped;
    UITextField *activeTF;
    BOOL isAddressEdit, isNameEdit, isEmailEdit, isEditClicked,saveData, isKBOpen;
}
@property(nonatomic, assign)id delegate;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;







@end
