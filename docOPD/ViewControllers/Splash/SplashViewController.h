//
//  SplashViewController.h
//  docOPD
//
//  Created by Virinchi Software on 10/23/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHLoadingTipView.h"
#import "HomeVC.h"

@interface SplashViewController : UIViewController<ServerRequestFinishedProtocol>
{
    NSInteger status;
    ServerRequestType currentRequestType;
    NSUserDefaults *userdef;
   
}

@property (strong, nonatomic) IBOutlet UIView *FooterView;
@property (strong, nonatomic) IBOutlet UIImageView *GifHeartBeat;
@property (strong, nonatomic) IBOutlet LHLoadingTipView *loadingView;

@end
