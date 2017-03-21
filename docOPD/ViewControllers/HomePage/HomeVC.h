//
//  HomeVC.h
//  docOPD
//
//  Created by Virinchi Software on 22/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>
#import "DBManager.h"
#import "docOPDNetworkEngine.h"
#import "ViewController.h"
#import "HDNotificationView.h"
#import "FindDocVC.h"
#import "PhysioVC.h"
#import "FreehealthServicesVC.h"
#import "MedicalRecordViewController.h"
#import "GeneralDocBookingVC.h"


@interface HomeVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ServerRequestFinishedProtocol,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    
    NSUserDefaults *userdef;
    ServerRequestType currentRequestType;
    NSInteger status;
    NSArray *homeArray;

}
- (IBAction)BounceMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *BounceMenu;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *FetchedData;

@property (nonatomic, strong) NSArray *albumFetch;
@property (nonatomic, strong) NSArray *sharedAlbumFetch;
@property (weak, nonatomic) IBOutlet UIView *referalView;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *referTXT;
- (IBAction)submitAction:(id)sender;
- (IBAction)skipAction:(id)sender;



@end
