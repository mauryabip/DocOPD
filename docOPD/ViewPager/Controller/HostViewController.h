//
//  HostViewController.h
//  CKViewPager
//
//  Created by Lucas Oceano on 11/03/2015.
//  Copyright (c) 2015 Lucas Oceano Martins. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ViewPagerController.h"

@interface HostViewController : ViewPagerController
@property (assign,nonatomic)id delegates;
@end
@protocol GetCurrentIndex <NSObject>

-(void)currentIndex:(NSInteger)index;

@end