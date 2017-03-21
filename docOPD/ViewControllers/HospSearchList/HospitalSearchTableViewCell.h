//
//  HospitalSearchTableViewCell.h
//  docOPD
//
//  Created by Virinchi Software on 10/29/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HospitalSearchTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgDoctor;
@property (strong, nonatomic) IBOutlet UILabel *LblDoctorName;
@property (strong, nonatomic) IBOutlet UILabel *LblDoctorDegree;

@property (strong, nonatomic) IBOutlet UILabel *LblDoctorExp;
@property (strong, nonatomic) IBOutlet UILabel *LblDoctorReview;
@property (strong, nonatomic) IBOutlet UILabel *LblDoctorNewRate;
@property (strong, nonatomic) IBOutlet UILabel *LblDoctorOldRate;
@property (strong, nonatomic) IBOutlet UIImageView *imgDoctorNewRate;
@property (strong, nonatomic) IBOutlet UIImageView *imgDoctorDegree;
@property (strong, nonatomic) IBOutlet UIImageView *imgDoctorExp;
@property (strong, nonatomic) IBOutlet UIImageView *imgDoctorReview;
@property (strong, nonatomic) IBOutlet UIView *viewEnquiry;
@property (strong, nonatomic) IBOutlet UIImageView *imgEnquiry;
@property (strong, nonatomic) IBOutlet UILabel *LblEnquiry;
@property (strong, nonatomic) IBOutlet UIView *viewBookAppointment;
@property (strong, nonatomic) IBOutlet UIImageView *imgBookAppointment;
@property (strong, nonatomic) IBOutlet UILabel *LblBookAppointment;
@property (strong, nonatomic) IBOutlet UIImageView *imgCellAccessories;
@property (strong, nonatomic) IBOutlet UIButton *BtnBookAppointment;
@property (strong, nonatomic) IBOutlet UIButton *BtnEnquiry;

@property (strong, nonatomic) IBOutlet UILabel *LblDoctorAvailibility;
@property (strong, nonatomic) IBOutlet UIView *ViewImgBorder;

@property (strong, nonatomic) IBOutlet UIButton *BtnAllTimings;
@property (strong, nonatomic) IBOutlet UIButton *BtnDoctorProfile;
@property (strong, nonatomic) IBOutlet UIView *viewOldRate;


@end
