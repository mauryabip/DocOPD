//
//  CustomSearchViewController.h
//  docOPD
//
//  Created by Virinchi Software on 1/5/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "SWTableViewCell.h"
@interface CustomSearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate,UISearchDisplayDelegate,UITextFieldDelegate,ServerRequestFinishedProtocol,SWTableViewCellDelegate>
{
    NSMutableArray *DoctorData;
    NSMutableArray *ProcedureData, *HospitalData,*fulldoctorlist, *APIDATA;
    NSUserDefaults *userdef;
    NSMutableArray *filterData;
    NSArray *searchResults;
    NSString *docName;
    NSInteger ShowData;
    NSMutableArray *procedureList;
    BOOL searchStart;
    ServerRequestType currentRequestType;
    NSString *SearchString;
    UIView *errorView;
    NSString *searchtype,*searchName,*searchtypeid;
    NSInteger status;
    NSMutableArray *filteredArray;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *FetchedData;
@end
