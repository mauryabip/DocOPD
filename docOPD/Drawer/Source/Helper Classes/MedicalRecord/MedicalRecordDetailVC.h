//
//  MedicalRecordDetailVC.h
//  docOPD
//
//  Created by Virinchi Software on 20/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "docOPDNetworkEngine.h"

@interface MedicalRecordDetailVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSString *selectedAlubID;
    BOOL shareEnabled;
    BOOL shareActive;
    NSMutableArray *selectedAlbum;
    NSUserDefaults *userdef;
}
@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
- (IBAction)shareBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)deleteBtnAction:(id)sender;
@property (strong, nonatomic)  NSArray *FetchedData;
@property (strong, nonatomic)  NSString *titleName;

- (IBAction)editAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end
