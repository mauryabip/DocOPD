//
//  BookAppointmentVC.h
//  docOPD
//
//  Created by Ashutosh Kumar on 8/4/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookAppointmentVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *DocView;
@property (strong, nonatomic) IBOutlet UIImageView *DocImage;
@property (strong, nonatomic) IBOutlet UILabel *DocNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *DocDegreeLbl;
@property (strong, nonatomic) IBOutlet UILabel *DocProfileLbl;

- (IBAction)BounceMenu:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UIImageView *HospitalImage;
@property (strong, nonatomic) IBOutlet UILabel *HospitalNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *HospitalAddressLbl;


@end
