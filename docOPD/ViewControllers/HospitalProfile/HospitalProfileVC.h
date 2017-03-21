//
//  HospitalProfileVC.h
//  docOPD
//
//  Created by Ashutosh Kumar on 8/4/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HospitalProfileVC : UIViewController<UITableViewDataSource, UITableViewDelegate,ServerRequestFinishedProtocol,UIScrollViewDelegate>{

    NSArray *HospitalData;
     NSMutableArray *HospitalDocData;
    NSMutableArray *HospitalTreatmentData;
    ServerRequestType currentRequestType;
    NSMutableArray *TreatmentList;
    UIView *errorView;
    NSMutableArray *DocList;
}
@property (strong, nonatomic) IBOutlet UIView *TopBar;
@property (strong, nonatomic) IBOutlet UILabel *LblTopTitle;

@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (strong, nonatomic) IBOutlet UIView *HospitalView;
@property (strong, nonatomic) IBOutlet UILabel *HospitalNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *HospitalAddLbl;
@property (strong, nonatomic) IBOutlet UIImageView *HospitalImage;
@property (strong, nonatomic) IBOutlet UIView *ButtonHolder;
@property (strong, nonatomic) IBOutlet UIButton *DoctorBtn;
@property (strong, nonatomic) IBOutlet UIButton *TreatmentBtn;
- (IBAction)HospTreamentList:(id)sender;
- (IBAction)HospDocList:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *LblAbout;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)UIButton *LastClicked;
@property (strong, nonatomic) IBOutlet UILabel *HospAboutLbl;
@property (nonatomic) NSString *hosname;
@property (strong, nonatomic) IBOutlet UILabel *LblTitleBar;
@property (nonatomic,strong) NSMutableDictionary *hosData;
@property (strong, nonatomic) IBOutlet UIImageView *imgho;
@property (strong, nonatomic) IBOutlet UIView *ViewAbout;
@property (strong, nonatomic) IBOutlet UIImageView *ImgHospLogo;
@property (strong, nonatomic) IBOutlet UIView *ViewBorderImg;
@property (strong, nonatomic) IBOutlet UILabel *LblNoOfPhysician;
@property (strong, nonatomic) IBOutlet UIImageView *ic_physian;
@property (strong, nonatomic) NSString *comeFrom;
@property (strong, nonatomic) NSString *docID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHTConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutHTConst;
@end
