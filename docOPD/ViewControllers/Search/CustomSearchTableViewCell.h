//
//  CustomSearchTableViewCell.h
//  docOPD
//
//  Created by Virinchi Software on 1/7/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface CustomSearchTableViewCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *LblName;
@property (strong, nonatomic) IBOutlet UILabel *LblType;
@end
