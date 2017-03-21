//
//  SearchVC.h
//  docOPD
//
//  Created by Ashutosh Kumar on 8/3/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate,UISearchDisplayDelegate,UITextFieldDelegate>
{
    NSMutableArray *DoctorData;
    NSMutableArray *ProcedureData, *HospitalData,*fulldoctorlist;
    
    NSMutableArray *filterData;
    NSArray *searchResults;
    NSString *docName;
    NSInteger ShowData;
    NSMutableArray *procedureList;
    BOOL searchStart;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
-(void)showDataof:(NSInteger)Valueof;
@end
