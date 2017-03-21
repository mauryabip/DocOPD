//
//  AllServicesViewController.h
//  docOPD
//
//  Created by Virinchi Software on 1/13/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllServicesViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *LblDoctorName;

@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) IBOutlet UILabel *LblSeperator;
@property (strong, nonatomic) NSMutableDictionary *AvailDic;
@property (strong, nonatomic) NSString *DataFor;
@property (strong, nonatomic) NSMutableArray *ServicesArr;
@end
