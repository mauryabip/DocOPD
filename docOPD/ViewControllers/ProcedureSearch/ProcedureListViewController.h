//
//  ProcedureListViewController.h
//  docOPD
//
//  Created by Virinchi Software on 10/29/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcedureListViewController : UIViewController<UIAlertViewDelegate, ServerRequestFinishedProtocol, UITableViewDelegate>{
    ServerRequestType currentRequestType;
    NSMutableArray *hosptalData;
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
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) NSString *ProId;
@property (strong, nonatomic) NSString *ProName;
@property (strong, nonatomic) NSString *ShowDataFor;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleBar;
@property (nonatomic) BOOL isDocSearch, isProSearch, isSpecSearch;

- (IBAction)didPressBookAppointment:(id)sender;
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

@end
