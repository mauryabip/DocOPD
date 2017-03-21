//
//  SelectSpecializationVC.h
//  docOPD
//
//  Created by Virinchi Software on 29/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectSpecializationVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *dataArr;
}
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)resetAction:(id)sender;

@end
