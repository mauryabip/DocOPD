//
//  EmergencyListVC.h
//  docOPD
//
//  Created by Virinchi Software on 02/11/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmergencyListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSUserDefaults *userDef;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backAction:(id)sender;
- (IBAction)callAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic)  NSString *name;
@property (strong, nonatomic)  NSArray *Data;
@end
