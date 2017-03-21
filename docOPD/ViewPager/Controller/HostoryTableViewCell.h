//
//  HostoryTableViewCell.h
//  docOPD
//
//  Created by Virinchi Software on 11/21/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface HostoryTableViewCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UIView *viewImgBackRound;
@property (strong, nonatomic) IBOutlet UIImageView *ImgDoc;
@property (strong, nonatomic) IBOutlet UILabel *LblDocName;
@property (strong, nonatomic) IBOutlet UILabel *lblHospital;
//@property (strong, nonatomic) IBOutlet UILabel *lblDate;
//@property (strong, nonatomic) IBOutlet UILabel *lblTime;
//@property (strong, nonatomic) IBOutlet UILabel *lblCity;
//@property (strong, nonatomic) IBOutlet UIButton *BtnStatus;
@property (strong, nonatomic) IBOutlet UILabel *LblDocDegree;
@property (strong, nonatomic) IBOutlet UILabel *LblMeetingInfo;
@property (strong, nonatomic) IBOutlet UIImageView *ImgStatus;
@property (strong, nonatomic) IBOutlet UILabel *LblAppointmentStatic;
@property (strong, nonatomic) IBOutlet UILabel *LblStatus;


//@property (nonatomic) float requiredCellHeight;

@end
