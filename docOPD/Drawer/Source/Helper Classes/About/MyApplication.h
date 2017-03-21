//
//  MyApplication.h
//  Test
//
//  Created by Ashu on 24/04/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface MyApplication : UIApplication
-(BOOL)openURL:(NSURL *)url;

-(BOOL)openURL:(NSURL *)url forceOpenInSafari:(BOOL)forceOpenInSafari;
@end
