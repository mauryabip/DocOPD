//
//  SelectFamilyVC.h
//  docOPD
//
//  Created by Virinchi Software on 27/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "docOPDNetworkEngine.h"
#import "UIImageView+WebCache.h"

@interface SelectFamilyVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSUserDefaults *userdef;
    NSMutableArray *dataArray;
}
- (IBAction)backAction:(id)sender;
- (IBAction)changeFamilyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *familyData;
@property (weak, nonatomic) IBOutlet UIButton *changeFamilyBtn;

@end
