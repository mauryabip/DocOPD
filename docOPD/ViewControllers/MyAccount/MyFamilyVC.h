//
//  MyFamilyVC.h
//  docOPD
//
//  Created by Virinchi Software on 26/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "docOPDNetworkEngine.h"
#import "UIImageView+WebCache.h"
#import "HHAlertView.h"
#import "SWTableViewCell.h"

@interface MyFamilyVC : UIViewController<UITableViewDelegate,UITableViewDataSource,HHAlertViewDelegate,UIGestureRecognizerDelegate,SWTableViewCellDelegate>{
    NSUserDefaults *userdef;
    NSMutableArray *dataArray;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backAction:(id)sender;
- (IBAction)addFamilyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *tipsImgView;
@property (weak, nonatomic) IBOutlet UIButton *tipsBtn;
- (IBAction)tipsAction:(id)sender;

@end
