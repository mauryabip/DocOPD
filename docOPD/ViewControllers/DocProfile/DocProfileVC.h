//
//  DocProfileVC.h
//  docOPD
//
//  Created by Ashutosh Kumar on 8/3/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocProfileVC : UIViewController<UITableViewDataSource, UITableViewDelegate,ServerRequestFinishedProtocol>
{
    NSMutableArray *HospitalListArray;
    NSMutableDictionary *DocProfileDic;
    NSMutableArray *DocSpecilitiesArr;
    ServerRequestType currentRequestType;
    NSMutableArray *servicesArray;
    UIView *errorView;
    BOOL isslideup;
}
@property (strong, nonatomic) IBOutlet UIView *viewTopBar;
@property (strong, nonatomic) IBOutlet UILabel *LblTopTitle;

//@property (strong, nonatomic) IBOutlet UIView *DocProfileView;
@property (strong, nonatomic) NSString *docID;
@property (strong, nonatomic) IBOutlet UILabel *docNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *LblDocDegree;
@property (strong, nonatomic) IBOutlet UILabel *LbldocTitle;
@property (strong, nonatomic) IBOutlet UILabel *LblDocReview;
@property (strong, nonatomic) IBOutlet UIImageView *ImgDoc;
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) IBOutlet UIView *ViewAd;

@property (strong, nonatomic) IBOutlet UIView *viewServices;

@property (strong, nonatomic)  UIImageView *HospitalImage;
@property (strong, nonatomic)  UILabel *HospitalLbl;
@property (strong, nonatomic)  UILabel *HospitalAddLbl;
@property (strong, nonatomic)  UILabel *HospSurgeryLbl;
@property (strong, nonatomic)  UIView *HospitalView;
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;

@property (strong, nonatomic) IBOutlet UILabel *LblTitleBar;
@property (strong, nonatomic) NSString *docFullName;
@property (strong,nonatomic)NSMutableDictionary *DocFullData;
@property (strong, nonatomic) IBOutlet UILabel *LblDocExp;
@property (strong, nonatomic) IBOutlet UILabel *LblDocOperation;
@property (strong, nonatomic) IBOutlet UILabel *LblDocPost;

@property (strong, nonatomic) IBOutlet UIImageView *imgDocClinic;
@property (strong, nonatomic) IBOutlet UIView *ViewDoctorProfileHolder;
@property (strong, nonatomic) IBOutlet UIView *ViewImgBorder;

@property (strong, nonatomic) IBOutlet UILabel *LblAdPrice;
@property (strong, nonatomic) IBOutlet UIButton *BtnAdKnowMore;

@property (strong, nonatomic) IBOutlet UILabel *LblAdTitle;
@property NSString *specIDForQuotation;
@property NSString *procIDForQuotation;

@property (strong, nonatomic) NSString *comeFrom;
@property (strong, nonatomic) NSString *HospID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHTConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *servieViewHTConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adviewTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHTConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHTConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serviceTopConst;

@end
