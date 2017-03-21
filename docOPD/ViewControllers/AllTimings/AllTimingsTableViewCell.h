//
//  AllTimingsTableViewCell.h
//  docOPD
//
//  Created by Virinchi Software on 10/31/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllTimingsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *ViewDayBack;
@property (strong, nonatomic) IBOutlet UILabel *LblDayNameInitial;
@property (strong, nonatomic) IBOutlet UILabel *LblDayTiming;

@end
