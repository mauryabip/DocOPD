//
//  FindDocVC.h
//  docOPD
//
//  Created by Ashutosh Kumar on 8/1/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>
#import "DBManager.h"
#import "docOPDNetworkEngine.h"

@interface FindDocVC : UIViewController<SlideNavigationControllerDelegate,UITextFieldDelegate,ServerRequestFinishedProtocol>{
    ServerRequestType currentRequestType;
    NSMutableArray *masksList;
    NSUserDefaults *userdef;
    NSArray * sortedArray;
    UIView *errorView;
    NSInteger status;
    NSMutableArray *folderDetails;

}
@property (strong, nonatomic) IBOutlet UILabel *lblMoreSec;
@property (strong, nonatomic) IBOutlet UIButton *BounceMenu;
@property (strong, nonatomic) IBOutlet UITextField *SearchBoxTF;
@property (strong, nonatomic) IBOutlet UIView *ButtonHolderView;
@property (strong, nonatomic) IBOutlet UIButton *ProcedureBtn;
@property (strong, nonatomic) IBOutlet UIButton *DoctorBtn;
@property (strong, nonatomic) IBOutlet UIButton *HospitalBtn;
@property (strong, nonatomic) UIButton *LastclickedBtn;
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UIView *MoreSectionView;

@property (strong, nonatomic) IBOutlet UIButton *SearchBtn;

@property (strong, nonatomic) IBOutlet UIButton *BtnRefresh;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *FetchedData;

@property (nonatomic, strong) NSArray *albumFetch;
@property (nonatomic, strong) NSArray *sharedAlbumFetch;



- (IBAction)GoBack:(id)sender;
@end
