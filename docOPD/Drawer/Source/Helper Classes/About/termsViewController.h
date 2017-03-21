//
//  termsViewController.h
//  docOPD
//
//  Created by Virinchi Software on 3/2/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTimerProgressView.h"
@interface termsViewController : UIViewController<UINavigationBarDelegate>{
    NSTimer *timer;
    BOOL isVisible;
    NSString *screenName;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *LblTitle;
@property (strong, nonatomic) NSString *fullURL;
@property (strong, nonatomic) NSString *headerTitleText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorSpinner;
//@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) IBOutlet UIView *topbarView;
@end
