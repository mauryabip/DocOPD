//
//  SubFolderViewController.h
//  docOPD
//
//  Created by Virinchi Software on 1/23/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "UIImageView+WebCache.h"

@interface SubFolderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray *recordArr;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)didPressBackMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblParentFolder;
@property (nonatomic)NSString *parentFolder;
@property (nonatomic)NSString *folderid;
@property (nonatomic)NSString *recordType;

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *FetchedData;

@end

