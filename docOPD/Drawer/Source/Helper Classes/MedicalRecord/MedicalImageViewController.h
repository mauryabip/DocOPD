//
//  MedicalImageViewController.h
//  docOPD
//
//  Created by Virinchi Software on 1/23/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"
#import "DBManager.h"
#import "CaptionViewController.h"
#import "ContactVC.h"

@protocol ImageAddedInfoDelegate<NSObject>

-(void)ImageWasAdded;

@end
@interface MedicalImageViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RNGridMenuDelegate>{
    NSMutableArray *ArrImage;
    NSString *base64EncodedString;
    NSString *imageName;
    NSUserDefaults *userdef;
    BOOL isUpdate;
    BOOL shareEnabled;
    NSString *selectedImageID;
    UITextField *mobile;
    UITextField *emailID;
    BOOL shareActive;
    NSMutableArray *selectedImage;
    NSArray *imgArr;

}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *LblParentFolderName;
@property (strong, nonatomic) IBOutlet UILabel *LblGrandParent;
@property (nonatomic)NSString *parentFolder;
@property (nonatomic)NSString *grandParent;
@property (nonatomic)NSString *id;
@property (nonatomic)NSString *recordType;

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *FetchedData;
@property (nonatomic)NSString *folderid;
@property (assign, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIButton *backToAlbumBtn;
- (IBAction)backToAlbumAction:(id)sender;
- (IBAction)deleteBtnAction:(id)sender;
- (IBAction)shareBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
- (IBAction)editBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editTraillingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareLeadingConst;


@end
