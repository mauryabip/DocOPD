//
//  ProcedureListTableViewCell.h
//  docOPD
//
//  Created by Virinchi Software on 10/29/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcedureListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ImgHospital;
@property (strong, nonatomic) IBOutlet UILabel *LblHospitalName;
@property (strong, nonatomic) IBOutlet UILabel *LblHospitalAddress;
@property (strong, nonatomic) IBOutlet UILabel *LblHospitalSpec;
@property (strong, nonatomic) IBOutlet UILabel *LblAvailability;
@property (strong, nonatomic) IBOutlet UILabel *LblNewRate;
@property (strong, nonatomic) IBOutlet UILabel *LblOldRate;
@property (strong, nonatomic) IBOutlet UIImageView *imgNewRate;
@property (strong, nonatomic) IBOutlet UIImageView *imgHospitalAddress;
@property (strong, nonatomic) IBOutlet UIImageView *imgHospitalSpec;
@property (strong, nonatomic) IBOutlet UIView *viewEnquiry;
@property (strong, nonatomic) IBOutlet UIView *ViewBookAppointment;
@property (strong, nonatomic) IBOutlet UIImageView *imgEnquiry;
@property (strong, nonatomic) IBOutlet UILabel *LblEnquiry;
@property (strong, nonatomic) IBOutlet UIImageView *imgBookAppointment;
@property (strong, nonatomic) IBOutlet UILabel *LblBookAppointment;
@property (strong, nonatomic) IBOutlet UIButton *BtnEnquiry;
@property (strong, nonatomic) IBOutlet UIButton *BtnBookAppointment;
@property (strong, nonatomic) IBOutlet UIImageView *imgCellAccessories;
@property (strong, nonatomic) IBOutlet UILabel *HosType;
@property (strong, nonatomic) IBOutlet UIButton *BtnAllTimings;
@property (strong, nonatomic) IBOutlet UIView *viewOldRate;

@property (strong, nonatomic) IBOutlet UIView *ImgHosImgBorder;

@property (strong, nonatomic) IBOutlet UIButton *BtnViewMore;

@property (strong, nonatomic) IBOutlet UIButton *BtnHospitalProfile;


@property (strong, nonatomic) IBOutlet UILabel *LblDocName;
@property (strong, nonatomic) IBOutlet UILabel *LblDocDegree;
@property (strong, nonatomic) IBOutlet UILabel *LblDocSpec;
@property (strong, nonatomic) IBOutlet UILabel *LblDocRev;
@property (strong, nonatomic) IBOutlet UIImageView *ImgDoc;
@property (strong, nonatomic) IBOutlet UIView *viewDocImage;







@end
