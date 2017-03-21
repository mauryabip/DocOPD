//
//  HospitalSearchViewController.h
//  docOPD
//
//  Created by Virinchi Software on 10/29/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HospitalSearchViewController : UIViewController<ServerRequestFinishedProtocol,UIAlertViewDelegate>
{
    ServerRequestType currentRequestType;
    NSInteger status;
    NSString *pgIndex;
    NSDictionary *hospital;
    NSArray *hospitalSectionTitles;
    NSMutableArray *DoctorData;
    UIView *errorView;
    //NSInteger status;
    NSInteger sectionIndex;
    
}
@property (strong, nonatomic) IBOutlet UILabel *LblAdTitle;
@property (strong, nonatomic) IBOutlet UIView *viewAD;
@property (strong,nonatomic) NSString *hosName;
- (IBAction)didPressEnquirenowButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHTConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adviewTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adviewHTConst;

@end
