//
//  DocProfileHospitalTableViewCell.h
//  docOPD
//
//  Created by Virinchi Software on 11/2/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocProfileHospitalTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *viewBorderHospitalImg;
@property (strong, nonatomic) IBOutlet UIImageView *Imghospital;
@property (strong, nonatomic) IBOutlet UILabel *LblHosName;
@property (strong, nonatomic) IBOutlet UILabel *LblHosLocation;
@property (strong, nonatomic) IBOutlet UILabel *LblHosType;
@property (strong, nonatomic) IBOutlet UILabel *LblAvaiability;
@property (strong, nonatomic) IBOutlet UILabel *LblDocTiming;
@property (strong, nonatomic) IBOutlet UIButton *BtnAllTiming;
@property (strong, nonatomic) IBOutlet UIButton *BtnEnquiry;
@property (strong, nonatomic) IBOutlet UIButton *BtnBookAppointment;
@property (strong, nonatomic) IBOutlet UIButton *BtnHospDetail;
@property (strong, nonatomic) IBOutlet UIView *viewBookAppointment;
@property (strong, nonatomic) IBOutlet UIView *viewEnquiry;

@end
