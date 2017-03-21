//
//  HospitalTableViewCell.h
//  docOPD
//
//  Created by Ashutosh Kumar on 8/11/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HospitalTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *HospitalImage;

@property (strong, nonatomic) IBOutlet UILabel *HospitalLbl;
@property (strong, nonatomic) IBOutlet UILabel *HospLocLbl;
@property (strong, nonatomic) IBOutlet UILabel *HosSpeLbl;



@end
