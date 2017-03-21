//
//  FreehealthServicesVC.h
//  docOPD
//
//  Created by Virinchi Software on 23/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "AAShareBubbles.h"
#import "GeneralDocBookingVC.h"
#import "EmergencyListVC.h"
#import "EmergencyBookVC.h"


@interface FreehealthServicesVC : UIViewController<UITableViewDataSource,UITableViewDelegate,AAShareBubblesDelegate,DYAlertPickViewDataSource, DYAlertPickViewDelegate,UIAlertViewDelegate>{
    AAShareBubbles *shareBubbles;
    NSArray *dataArr;
    NSUserDefaults *userDef;
    NSString *titleName;
    NSInteger count;
    NSString *screenName;
}
@property (strong, nonatomic)  NSString *viewController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *popupTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *popupDetailLbl;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
- (IBAction)capmRequestAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *camprequestBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHT;
- (IBAction)referAndSaveBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *referralCodeTXT;
@property (weak, nonatomic) IBOutlet UILabel *referTextLbl;


@end
