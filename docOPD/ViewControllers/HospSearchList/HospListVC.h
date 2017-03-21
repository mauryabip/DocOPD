//
//  HospListVC.h
//  docOPD
//
//  Created by Ashutosh Kumar on 8/11/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HospListVC : UIViewController<ServerRequestFinishedProtocol>
{
    ServerRequestType currentRequestType;
    NSMutableArray *hosptalData;
    NSInteger status;
    NSString *pgIndex;
}
- (IBAction)GoToBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (strong,nonatomic) NSString *hosName;



@end
