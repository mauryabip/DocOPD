//
//  MedicalRecordViewController.h
//  docOPD
//
//  Created by Virinchi Software on 1/23/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "docOPDNetworkEngine.h"
#import "ViewController.h"

@interface MedicalRecordViewController : UIViewController<SlideNavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSMutableArray *ArrFolderDetails;
    NSMutableDictionary*DicFolderDetails;
    NSUserDefaults *userdef;
    NSMutableString *dataPath;
    NSString *AlbumName;
    NSMutableArray *ArrAllFolder;
    NSString *Rtype;
    NSString *imgName;
    NSString *imgCaption;
    NSString *base64Str;
  //  ServerRequestType currentRequestType;
    UIView *errorView;
    NSInteger indexNumber,status;
    BOOL isIndicatorShow, isSyncTapped;
    NSString *selectedAlubID;
    BOOL shareEnabled;
    BOOL shareActive;
    UIImageView *FolderImg;
    UITextField *mobile;
    UITextField *emailID;
    NSMutableArray *selectedAlbum;
    NSString *sectionIdentity;
    BOOL sectionFlag;
    NSInteger recordStatus;
    CGSize result;

    
}
@property (weak, nonatomic) IBOutlet UIImageView *tipsImageView;
@property (nonatomic, strong) NSArray *albumFetch;
@property (nonatomic, strong) NSArray *sharedAlbumFetch;
@property (nonatomic, strong) NSString *viewController;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *sharedCollectionView;
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UIView *Topbar;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *FetchedData;
@property (nonatomic, strong) NSArray *sharedFetchedData;

@property (nonatomic, strong) NSArray *SyncData;
@property (nonatomic, strong) DBManager *db;
@property (strong, nonatomic) IBOutlet UIButton *BtnSync;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
- (IBAction)deleteBtnAction:(id)sender;
- (IBAction)editBtnAction:(id)sender;
- (IBAction)shareBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *syncLbl;
@property (weak, nonatomic) IBOutlet UIButton *loadRecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *loadSharedRecordBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewHT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sharedCollViewHT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sharedCollviewTop;
- (IBAction)loadRecordAction:(id)sender;
- (IBAction)loadSharedRecordAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

@property (weak, nonatomic) IBOutlet UIButton *tipsBtn;
- (IBAction)tipsAction:(id)sender;

@end
