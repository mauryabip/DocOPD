//
//  ContentViewController.h
//  CKViewPager
//
//  Created by Lucas Oceano on 11/03/2015.
//  Copyright (c) 2015 Lucas Oceano Martins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "HostoryTableViewCell.h"
@interface ContentViewController : UIViewController<SlideNavigationControllerDelegate,ServerRequestFinishedProtocol,UITableViewDataSource, UITableViewDelegate,SWTableViewCellDelegate>
{
    ServerRequestType currentRequestType;
    NSInteger curIndex;
    NSMutableArray *BookingArray;
    NSMutableArray *EnquiryArray;
    UIButton *lastButton;
    UIView *errorView;
    NSString *bookingID;
    NSIndexPath *clickedIndexpath;
    CGFloat cellHeight;
    NSInteger status;
    NSInteger clickedCell;
  //  BOOL isBooking, isEnquiry;
}
@property NSString *labelString;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *BtnEnquiry;

@property (strong, nonatomic) IBOutlet UIView *ViewNotFoundRecord;
@property (strong, nonatomic) IBOutlet UIButton *BtnHistory;
@property (nonatomic)NSInteger currentindex;
@property (strong, nonatomic) IBOutlet UILabel *LblNotFoundRecord;
@property (strong) HostoryTableViewCell *cellPrototype;
@property (strong, nonatomic) IBOutlet UILabel *LblTitleForEmpty;
@property (strong, nonatomic) IBOutlet UIImageView *ImgEmpty;
@end
//@protocol GetCurrentIndex <NSObject>
//
//-(void)currentIndex:(NSInteger)index;
//
//@end