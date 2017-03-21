//
//  MenuViewController.h
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import <MessageUI/MessageUI.h>
#import "MyFamilyAccountVC.h"

@interface LeftMenuViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
//    NSMutableArray *tabledata;
	UIViewController *vc ;
    NSMutableString *dataPath;
    NSInteger LastindexClicked;
    NSUserDefaults *userDef;
}
@property (strong, nonatomic) IBOutlet UITableView *tableVw;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;
@property (strong, nonatomic) IBOutlet UILabel *LblUserName;
@property (strong, nonatomic) IBOutlet UILabel *LblUserMobile;
@property (strong, nonatomic) IBOutlet UIImageView *ImgUser;
@property (strong, nonatomic) IBOutlet UIView *UserInfoView;
@property (strong, nonatomic) IBOutlet UIView *ViewImgBorder;
@property (strong, nonatomic) IBOutlet UIImageView *imgUserBlur;
@property (strong, nonatomic) IBOutlet UIView *viewblur;
@property (strong , nonatomic)NSString *imgUrl;

@end
