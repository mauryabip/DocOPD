//
//  PhysioVC.h
//  docOPD
//
//  Created by Virinchi Software on 23/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralDocBookingVC.h"
#import "SelectSpecializationVC.h"


@interface PhysioVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,ServerRequestFinishedProtocol,UIActionSheetDelegate>{
    ServerRequestType currentRequestType;
    NSMutableArray *hosptalData;
    NSMutableArray *hosptalDataBackUp;
    NSInteger status;
    NSInteger pgIndex;
    NSDictionary *hospital;
    NSArray *hospitalSectionTitles;
    // NSMutableArray *resposeCode;
    NSMutableArray  *arrayForBool;
    NSInteger tappedSection;
    NSString *lowestQuotation;
    UIView *errorView;
    NSMutableDictionary *HospitalDic;
    
}
@property (strong, nonatomic) NSString *ProId;
@property (strong, nonatomic) NSString *ProName;
@property (strong, nonatomic) NSString *ShowDataFor;
@property (nonatomic) BOOL isDocSearch, isProSearch, isSpecSearch;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *middleName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *specID;
@property (strong,nonatomic) NSMutableDictionary *DocData;
@property (strong, nonatomic) IBOutlet UIButton *BtnKnowMore;
@property (strong, nonatomic) IBOutlet UILabel *LblAdPrice;
@property (strong, nonatomic) IBOutlet UILabel *LblAdTitle;
@property (strong, nonatomic) IBOutlet UIView *ViewAd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adviewbottomConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adviewHTConst;

- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)alltimingAction:(id)sender;
- (IBAction)openHospitalAction:(id)sender;
- (IBAction)docProfileAction:(id)sender;
- (IBAction)bookAppointmentAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *specializationLbl;
@property (weak, nonatomic) IBOutlet UIButton *SortBtn;
@property (weak, nonatomic) IBOutlet UIButton *SpecializationBtn;
- (IBAction)SpecializationAction:(id)sender;
- (IBAction)sortAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *SortLbl;

@end
