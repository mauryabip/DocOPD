//
//  HospitalProfileTableViewCell.h
//  docOPD
//
//  Created by Virinchi Software on 10/27/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface HospitalProfileTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ImgCell;
@property (strong, nonatomic) IBOutlet UILabel *LblDocName;
@property (strong, nonatomic) IBOutlet UILabel *LblDocFee;
@property (strong, nonatomic) IBOutlet UILabel *LblDocDegree;
@property (strong, nonatomic) IBOutlet UIView *ViewImageBack;
@property (strong, nonatomic) IBOutlet UILabel *LblOldPrice;
@property (strong, nonatomic) IBOutlet UILabel *LblAvailibility;
@property (weak, nonatomic) IBOutlet UILabel *specalityLbl;

@property (strong, nonatomic) IBOutlet UILabel *LblSepConditional;
@end
