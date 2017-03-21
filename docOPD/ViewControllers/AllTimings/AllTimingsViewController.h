//
//  AllTimingsViewController.h
//  docOPD
//
//  Created by Virinchi Software on 10/31/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface AllTimingsViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate>{
   // NSMutableArray *allday;
    NSArray *items;
}
@property (strong, nonatomic) IBOutlet UILabel *LblDoctorName;
@property (strong, nonatomic) IBOutlet UILabel *LblHeaderTitle;
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) IBOutlet UILabel *LblSeperator;
@property (strong, nonatomic) NSMutableDictionary *AvailDic;
@property (strong, nonatomic) NSString *DataFor;
//@property (strong, nonatomic) NSString *trackedViewName;
@property (strong, nonatomic) NSString *DataForDoctor;
@end
