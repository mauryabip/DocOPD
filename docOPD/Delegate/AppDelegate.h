//
//  AppDelegate.h
//  docOPD
//
//  Created by Ashutosh Kumar on 7/31/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#include <CoreLocation/CLLocationManagerDelegate.h>
#include <CoreLocation/CLError.h>
#import  <CoreLocation/CoreLocation.h>
#include <CoreLocation/CLLocation.h>
#include <CoreLocation/CLLocationManager.h>
#import  <corelocation/CLGeocoder.h>
#import "LeftSlideViewController.h"
#import "LeftMenuViewController.h"
#import "DBManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    Reachability* reachability;
    NSUserDefaults *userdef;
    NSString*username,*pwd;
    NSInteger *status;
    BOOL IsNoInternetAppear;
    UIView *errorView;
    NSMutableArray  *offlineMedicalRecordArr;
    NSInteger imgDwnloadCount,retryCount;
}
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) LeftMenuViewController *LeftMenuVC;
@property (nonatomic)NetworkStatus remoteHostStatus;
@property (nonatomic) BOOL isInternet;
@property (nonatomic, assign) float currentlat;
@property (nonatomic, assign) float currentlong;
@property (assign, nonatomic) BOOL ISAllowedGPSLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSString *deviceTok;
@property (strong, nonatomic)NSTimer *AppTimer,*Apptime2;
@property (nonatomic) NSString *vendorId;
@property(nonatomic,strong)NSMutableString *dataPath;
@property(nonatomic,strong)NSMutableString *medicalRecordPath;
@property (nonatomic,strong)NSMutableArray *allDocList;
@property (nonatomic,strong)NSMutableArray *allHospList;
@property (nonatomic,strong)NSMutableArray *allProcedureList;
+ (AppDelegate *)MyappDelegate;
- (void) showIndicator;
-(void) showIndicatorWithTitle:(NSString*)title Message:(NSString *)message;
- (void) hideIndicator;
-(void)ViewSlideDown:(NSString*)Message;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic,strong)NSArray *fetchedData;

@property (nonatomic, strong) DBManager *dbm;
@property (nonatomic,strong)NSArray *dataFetched;

-(void)fetchDataFromDB;
//-(BOOL)openURL:(NSURL*)url;
@end

