//
//  MedicalRecordViewController.h
//  docOPD
//
//  Created by Virinchi Software on 1/23/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
@interface MedicalRecordViewController : UIViewController<SlideNavigationControllerDelegate>{
    NSMutableArray *ArrFolderDetails;
    NSMutableDictionary*DicFolderDetails;
    NSUserDefaults *userdef;
    NSMutableString *dataPath;
    NSString *AlbumName;
}
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UIView *Topbar;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *FetchedData;
@end
