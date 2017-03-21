//
//  DoctorsListVC.h
//  docOPD
//
//  Created by Ashutosh Kumar on 8/5/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorsListVC : UIViewController<ServerRequestFinishedProtocol>{
    NSMutableArray *dataarr;
    NSMutableArray *maindata;
    ServerRequestType currentRequestType;
    NSInteger status;
    NSString *pgIndex;
    NSMutableArray *resposeCode;
    NSString *docname;
}
@property (strong, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UIButton *back;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *middleName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *dataShowFor;
@property (strong, nonatomic) IBOutlet UILabel *LblTitleBar;
@property (strong,nonatomic)NSMutableDictionary *DocData;
@end
