//
//  AppDelegate.m
//  docOPD
//
//  Created by Ashutosh Kumar on 7/31/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "LeftMenuViewController.h"
#import "FindDocVC.h"
#import "LeftSortsViewController.h"
#import "SplashViewController.h"
#import <Google/Analytics.h>
#import "termsViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Localytics.h"

//Add Localytics
#define Localytics_docOPD_TOKEN @"ef8b6333638c8cb16e8a496-2e76389a-4f4c-11e6-71ae-002dea3c3994"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize ISAllowedGPSLocation, isInternet;
@synthesize locationManager,remoteHostStatus,Apptime2,AppTimer;
@synthesize currentlat,currentlong,vendorId;
@synthesize allDocList,allHospList,allProcedureList;
@synthesize dataPath,medicalRecordPath;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self createDirectory:@"Media"];
   
    /*=========================================================================================================
     Localytics Implementation
     =========================================================================================================*/
    
    [Localytics autoIntegrate:Localytics_docOPD_TOKEN launchOptions:launchOptions];
    [Localytics tagEvent:@"App Launched"];
    
    
    [Fabric with:@[[Crashlytics class]]];

    
    
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    //[[UITextView appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];

    [self registerNotifications];
    
/*=========================================================================================================
                                    Google Analytics Implementation
=========================================================================================================*/
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    
/*=========================================================================================================
    NEW Left Drawer
 =========================================================================================================*/
  /*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];   //设置通用背景颜色
    [self.window makeKeyAndVisible];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SplashViewController *splashVC = [storyboard instantiateViewControllerWithIdentifier:@"SplashViewController"];
    FindDocVC *findDoc = [storyboard instantiateViewControllerWithIdentifier:@"docOPD_FindDoc"];
    LeftMenuViewController *leftmenu = [storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    if ([[userdef objectForKey:isLogin]isEqualToString:@"Yes"]) {
        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:findDoc];
    }else{
        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:splashVC];
    }
    
    //MainPageViewController *mainVC = [[MainPageViewController alloc] init];
 //   self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
 //   LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
    self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftmenu andMainView:self.mainNavigationController];
    
//    self.LeftMenuVC = [[LeftMenuViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
    
    
    self.window.rootViewController = self.LeftSlideVC;
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor purpleColor]];
    
    */
/*=========================================================================================================
                                            Left Drawer
 =========================================================================================================*/
    userdef = userDefault;
#pragma mark - Left Drawer
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
      //  NSLog(@"Closed %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSString *imgNamestr =@"MyProfileImage.png";
//        leftMenu.ImgUser.image = [self getImage:@"MyProfileImage.png"];
//        leftMenu.imgUserBlur.image =[self getImage:@"MyProfileImage.png"];
        
        NSString*userImgFile = [[AppDelegate MyappDelegate].dataPath stringByAppendingPathComponent:imgNamestr];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:userImgFile];
        if (fileExists) {
            leftMenu.ImgUser.image = [self getImage:imgNamestr];
        }else{
            leftMenu.ImgUser.image = [UIImage imageNamed:@"user.png"];
        }
        
//        NSUserDefaults *udef = [NSUserDefaults standardUserDefaults];
        leftMenu.LblUserName.text = [userdef valueForKey:Username];
        leftMenu.LblUserMobile.text = [userdef valueForKey:Mobile];
        leftMenu.imgUrl = [userdef valueForKey:userProfileImgUrl];
//        leftMenu.MobLbl.text = [udef valueForKey:@"Mobile"];
      //  NSLog(@"user profile img url %@", [userdef valueForKey:userProfileImgUrl]);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidReveal object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
       // NSLog(@"Revealed %@", menu);
    }];

    
    
    ISAllowedGPSLocation=NO;
    
//    AppTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(SendMyLocationONweb) userInfo:nil repeats:YES];
//    
//    [AppTimer fire];
    
/*======================================================================================================
                                    GET UDID OF Current Device
=====================================================================================================*/
    
    vendorId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
 //   NSLog(@"Your Device ID is %@",vendorId);
    [userdef setObject:vendorId forKey:DeviceID];
    
/*======================================================================================================
                                            GPS Location Get
 =====================================================================================================*/
    
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        
    {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    
/*======================================================================================================
                                            Push Notification
 =====================================================================================================*/
    
 /*   if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
      //  NSLog(@"system version > 8.0");
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    application.applicationIconBadgeNumber = 0;
    
    */
    
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    
    
/*======================================================================================================
                                                Reachability Check
 =====================================================================================================*/
    
    reachability = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    [reachability startNotifier];
    remoteHostStatus = [reachability currentReachabilityStatus];
    
    IsNoInternetAppear=false;
    
    if(remoteHostStatus == NotReachable) {
        isInternet = false;
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Your internet is not connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
  //      [self StopUpdateGPSLocation];
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        isInternet = true;
    //    NSLog(@"Connected via wifi");
        

    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        isInternet = true;
     //   NSLog(@"connected via cell");
         IsNoInternetAppear = false;

    }
    
 //   NSLog(@"user login status:%@",[userdef objectForKey:isLogin]);
  //   NSLog(@"mobile=%@,Authkey=%@,UserName=%@,Email=%@",[userdef objectForKey:Mobile],[userdef objectForKey:AuthKey],[userdef objectForKey:Username],[userdef objectForKey:EmailID]);
//    if ([[userdef objectForKey:isLogin]isEqualToString:@"Yes"]) {
//        NSLog(@"User logged in");
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        FindDocVC *findDoc = [storyboard instantiateViewControllerWithIdentifier:@"docOPD_FindDoc"];
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        // Override point for customization after application launch.
//  
//        self.window.rootViewController = findDoc;
//        [self.window makeKeyAndVisible];
//
//    }
//    

    allProcedureList = [[NSMutableArray alloc]init];
    allDocList = [[NSMutableArray alloc]init];
    allHospList = [[NSMutableArray alloc]init];
    
    
    /*======================================================================================================
                                        Set Status Bar Style
     =====================================================================================================*/
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor dOPDThemeColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:21], NSFontAttributeName, nil]];

    
    return YES;
}


//-(void)imageupdateforSlider{
//    NSLog(@"img update for slider enter");
//    ImgUser.image = [self getImage:@"MyProfileImage.png"];
//}

- (UIImage*)getImage: (NSString*)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    dataPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:@"Media"];
    NSString *getImagePath = [dataPath stringByAppendingPathComponent:filename];
  //  NSLog(@"Get image path: %@",getImagePath);
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


/*======================================================================================================
                                        handle Network Change
 =====================================================================================================*/

- (void) handleNetworkChange:(NSNotification *)notice
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"nointernet"];
    remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
    {
        isInternet = false;
    //    NSLog(@"no");
        if (!IsNoInternetAppear) {
            IsNoInternetAppear = YES;
            [navController presentViewController:vc animated:YES completion:nil];
        }
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        isInternet = true;
     //   NSLog(@"wifi");
        //       [self AlertShow];
        if (IsNoInternetAppear) {
            [navController dismissViewControllerAnimated:YES completion:nil];
            IsNoInternetAppear = false;
        }
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        isInternet = true;
   //     NSLog(@"cell");
        //[self AlertShow];
        if (IsNoInternetAppear) {
            [navController dismissViewControllerAnimated:YES completion:nil];
            IsNoInternetAppear = false;
        }

    }
}


/*======================================================================================================
                                        CLLocationManagerDelegate
 =====================================================================================================*/


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    ISAllowedGPSLocation = true;
    // NSLog(@"location manager ----------------------");
    [ NSString stringWithFormat:@"locatoin %3.6f" , (newLocation.coordinate.latitude) ];
    self.currentlat = newLocation.coordinate.latitude;
    self.currentlong = newLocation.coordinate.longitude;
//    NSLog(@"updating location = %f, %f", self.currentlat, self.currentlong);
  [manager stopUpdatingLocation];
    [self StopUpdateGPSLocation];
  //  [self UpdateGPSLocation];
}

/*
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    [self StopUpdateGPSLocation];
}

-(void)UpdateGPSLocation
{
    if (ISAllowedGPSLocation)
    {
        [locationManager startUpdatingLocation];
        
    }
    [locationManager startUpdatingLocation];
    
}
*/
-(void)StopUpdateGPSLocation
{
    
    [locationManager stopUpdatingLocation];
    
}


#pragma - mark Class Methods

/*======================================================================================================
                                            Class Methods
 =====================================================================================================*/

#pragma - mark Class Methods
+ (AppDelegate *)MyappDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void) showIndicator
{
    //[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window  animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.color = [[UIColor dOPDThemeColor]colorWithAlphaComponent:0.9];
    hud.labelText = @"Loading...";
}


-(void) showIndicatorWithTitle:(NSString*)title Message:(NSString *)message
{
    //[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window  animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.color = [[UIColor dOPDThemeColor]colorWithAlphaComponent:0.9];
    hud.labelText = title;
    hud.detailsLabelText = message;
}


-(void) hideIndicator
{
    [MBProgressHUD hideHUDForView:self.window animated:NO];
}





#pragma mark  - Push notification Delegates

/*=========================================================================================================
                                            Push notification Delegates
 =========================================================================================================*/
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
   // NSLog(@"My token is: %@", deviceToken);
    [self regiserDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
  //  NSLog(@"Failed to get token, error: %@", error);
  //  NSLog(@"%@, %@", error, error.localizedDescription);
}

-(void)regiserDeviceToken: (NSData*)deviceToken{
   // NSLog(@"Device token is %@", deviceToken);
    NSMutableString *String = [[NSMutableString alloc]init];
    NSInteger length = [deviceToken length];
    char const *bytes = [deviceToken bytes];
    for (int i=0; i<length; i++) {
        [String appendString:[NSString stringWithFormat:@"%02.2hhx", bytes[i]]];
    }
  //  NSLog(@"%@", String);
    self.deviceTok = String;
 //   NSLog(@"My token is: %@", String);
    userdef = userDefault;
    [userdef setObject:String forKey:DeviceToken];
    [userdef synchronize];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Create Directory

/*======================================================================================================
                                        Create Document Directory
 =====================================================================================================*/

-(void) createDirectory : (NSString *) dirName {
 //   NSLog(@"Create directory enter");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    dataPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:dirName];
    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]) {
      //  NSLog(@"Couldn't create directory error: %@", error);
    }
    else {
       // NSLog(@"directory created!");
    }
 //   NSLog(@"dataPath : %@ ",dataPath); // Path of folder created

}

/*======================================================================================================
                            View SlideDown like notification view
 =====================================================================================================*/
-(void)ViewSlideDown:(NSString*)Message{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        errorView.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,84);
        errorView.backgroundColor = [UIColor dOPDThemeColor];
        UILabel *msg = [[UILabel alloc]initWithFrame:CGRectMake(40, (errorView.frame.size.height-30)/2, errorView.frame.size.width-40, 40)];
        msg.text = Message;
        //        msg.textAlignment = NSTextAlignmentCenter;
        msg.numberOfLines =2;
        //        msg.lineBreakMode = NSLineBreakByWordWrapping;
        //        [msg sizeToFit];
        msg.textColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        msg.font = [UIFont systemFontOfSize:14.0];
        [errorView addSubview:msg];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 delay:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            errorView.frame  = CGRectMake(0, -84, [UIScreen mainScreen].bounds.size.width,84);
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    }];
}

#pragma mark - Fetch Data From DB

/*======================================================================================================
                                    Fetch Data From DB and Sync with Server
 =====================================================================================================*/

-(void)fetchDataFromDB{
     self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
  //  NSLog(@"fetchMedicalRecordFromDB Enter");
    offlineMedicalRecordArr = [[NSMutableArray alloc]init];
    NSString *query = [NSString stringWithFormat:@"SELECT rowid,upload_image, image_name, report_type, album_name,image_id,image_tag FROM medicalRecord WHERE user_id='%@' AND upload_status='0'",[userdef valueForKey:User_id]];
 //   NSLog(@"Fetch Query: %@",query);
    // Get the results.
    if (self.fetchedData != nil) {
        self.fetchedData = nil;
    }
    self.fetchedData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    if (!self.fetchedData || self.fetchedData.count==0) {
     //   NSLog(@"Database have not record. %@",self.fetchedData);
        
    }else{
    
        
        NSInteger indexOfAlbumName = [self.dbManager.arrColumnNames indexOfObject:@"album_name"];
        NSInteger indexOfUploadImage = [self.dbManager.arrColumnNames indexOfObject:@"upload_image"];
        NSInteger indexOfImageName = [self.dbManager.arrColumnNames indexOfObject:@"image_name"];
        NSInteger indexOfReportType = [self.dbManager.arrColumnNames indexOfObject:@"report_type"];
        NSInteger indexOfImgTag = [self.dbManager.arrColumnNames indexOfObject:@"image_tag"];
        NSInteger indexOfImgid = [self.dbManager.arrColumnNames indexOfObject:@"image_id"];
       
//        NSString* AlbumName = [[self.fetchedData objectAtIndex:index]objectAtIndex:indexOfAlbumName];
//        NSString*base64Str = [[self.fetchedData objectAtIndex:index]objectAtIndex:indexOfUploadImage];
//        NSString*imgName = [[self.fetchedData objectAtIndex:index]objectAtIndex:indexOfImageName];
//        NSString*Rtype = [[self.fetchedData objectAtIndex:index]objectAtIndex:indexOfReportType];
//        NSString*imgCaption;
//        NSLog(@"SubArray count: %ld",(long)[[self.fetchedData objectAtIndex:index]count]);
//        
//        if ([[self.fetchedData objectAtIndex:index]count]<=indexOfImgTag) {
//            imgCaption =@"";
//        }else
//            imgCaption =[[self.fetchedData objectAtIndex:index]objectAtIndex:indexOfImgTag];
//        NSLog(@"Api hitting for Index number : %ld",(long)indexNumber);
//        [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:.000];
//
        
//        
//        
//        NSInteger indexOfid_planTime = 0;
//        NSInteger indexOfid_plan = [self.dbManager.arrColumnNames indexOfObject:@"id_plan"];
//        NSInteger indexOfPlandate = [self.dbManager.arrColumnNames indexOfObject:@"plandate"];
//        NSInteger indexOfResepID = [self.dbManager.arrColumnNames indexOfObject:@"id_resep"];
//        NSInteger indexOfTime = [self.dbManager.arrColumnNames indexOfObject:@"time"];
//        
        
        
        
    //    NSLog(@"Fetched data count for fetchPlanFromDB = %lu",(unsigned long)self.fetchedData.count);
        if (self.fetchedData.count>0) {
            for (int index=0; index<self.fetchedData.count; index++) {
                NSMutableDictionary *datadic=[[NSMutableDictionary alloc]init];
                [datadic setObject:[[self.fetchedData objectAtIndex:index]objectAtIndex:indexOfAlbumName] forKey:FolderName];
                [datadic setObject:[[self.fetchedData objectAtIndex:index]objectAtIndex:indexOfImageName] forKey:ImgName];
                [datadic setObject:[[self.fetchedData objectAtIndex:index]objectAtIndex:indexOfUploadImage] forKey:base64];
                [datadic setObject:[[self.fetchedData objectAtIndex:index]objectAtIndex:indexOfReportType] forKey:ReportType];
                [datadic setObject:[[self.fetchedData objectAtIndex:index]objectAtIndex:indexOfImgid] forKey:medicalImgID];
             
                NSString*imgCaption;
                if ([[self.fetchedData objectAtIndex:index]count]<=indexOfImgTag) {
                    imgCaption =@"";
                }else
                    imgCaption =[[self.fetchedData objectAtIndex:index]objectAtIndex:indexOfImgTag];
                
                 [datadic setObject:imgCaption forKey:ImgCaption];
                [offlineMedicalRecordArr addObject:datadic];
            }
            
            for (int i=0; i<offlineMedicalRecordArr.count; i++) {
                [self asyncAPICallingForSyncMedReport:[offlineMedicalRecordArr objectAtIndex:i]];
            }
        }
    }
}

-(void)asyncAPICallingForSyncMedReport:(NSDictionary*)userInfo{
    
    
    NSString *userid=  [userdef objectForKey:User_id];
    NSString *album =  [userInfo objectForKey:FolderName];
    NSString *uploadimg =  [userInfo objectForKey:base64];
    NSString *ImageName =  [userInfo objectForKey:ImgName];
    NSString *RType =  [userInfo objectForKey:ReportType];
    NSString *imgTag = [userInfo objectForKey:ImgCaption];
    NSString *imgid = [userInfo objectForKey:medicalImgID];
    if ([RType isEqualToString:@"Priscription"]) {
        RType =@"Precription";
    }
    RType= [NSString stringWithFormat:@"Medical%@",RType];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"UploadMedicalReport"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
  //  NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"UserId=%@&UploadImage=%@&ImageName=%@&ReportType=%@&ImageTag=%@&AlbumName=%@",userid?userid:@"",uploadimg?uploadimg:@"",ImageName?ImageName:@"",RType?RType:@"",imgTag,album?album:@""];
  //  NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    __block NSError *e;
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    // Code to run when the response completes...
                //    NSLog(@"Async UploadMedicalReport Response= %@",response);
                    
                    if (!error) {
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &e];
                   //     NSLog(@"Async UploadMedicalReport Response json data= %@",json);
                        
                       
//                        status = [[[json valueForKey:@"MedicalStatus"]valueForKey:@"Status"]integerValue];
                        if ([[[json valueForKey:@"MedicalStatus"]valueForKey:@"Status"]integerValue]==1) {
                            NSString *newImageID = [[json valueForKey:@"MedicalStatus"]valueForKey:@"ImageId"];
                     //       NSLog(@"%@",[[json valueForKey:@"MedicalStatus"]valueForKey:@"ImageId"]);
                            [self updateMedicalRecordInDBWithImageID:imgid withNewImageID:newImageID];
                        }
                        
                        
//                        NSDictionary *resposeCode=[json objectForKey:@"post"];
//                        if ([[json objectForKey:@"status"]integerValue] ==1) {
//                           
//                            [self updateServerPlanTimeInDB:locplantime withNewPlan:serverPlanTimeid];
//                        }
                        
                    
                    } else {
                        // update the UI to indicate error
                    }
                }] resume];
    
    
}


//-(void)updateTable{
//    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
//    NSInteger indexOfImgid = [self.dbManager.arrColumnNames indexOfObject:@"image_id"];
//    NSString *imgid = [[self.SyncData objectAtIndex:indexNumber]objectAtIndex:indexOfImgid];
//    NSString *query = [NSString stringWithFormat:@"UPDATE medicalRecord SET upload_status='1' WHERE image_id='%@' AND upload_status='0'",imgid];
//    NSLog(@"update Query: %@",query);
//    
//    
//    // Execute the query.
//    [self.db executeQuery:query];
//    
//    // If the query was successfully executed then pop the view controller.
//    if (self.db.affectedRows != 0)
//    {
//        NSLog(@"Query was executed successfully. Affected rows = %d", self.db.affectedRows);
//        indexNumber ++;
//        NSLog(@"Index number : %d, fetched array count = %d",indexNumber,self.SyncData.count);
//        if (indexNumber< self.SyncData.count) {
//            [self getinfo:indexNumber];
//        }else{
//            NSLog(@"IndexNumber lapssed");
//            if (isIndicatorShow) {
//                [[AppDelegate MyappDelegate]hideIndicator];
//                isIndicatorShow = false;
//            }
//        }
//    }
//    else{
//        NSLog(@"Could not execute the query.");
//    }
//}



/*======================================================================================================
                    update Medical Record In DB With ImageID
 =====================================================================================================*/


-(void)updateMedicalRecordInDBWithImageID:(NSString*)imageid withNewImageID:(NSString*)NewImageID{
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];

    NSString *query = [NSString stringWithFormat:@"UPDATE medicalRecord SET upload_status='1', image_id='%@' WHERE image_id='%@' AND upload_status='0'",NewImageID,imageid];
  //  NSLog(@"query for update: %@",query);
    [self.dbManager executeQuery:query];
    if (self.dbManager.affectedRows != 0) {
   //     NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
   //     NSLog(@"Could not execute the query.");
    }
}



/*======================================================================================================
                            update Medical Image Record In DB With ImageURL
 =====================================================================================================*/


-(void)fetchImageUrlFromDB{
    self.dbm = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    //    [self createDirectory:@"resepImg"];
    // Form the query.
    NSString *query = @"SELECT image_name,image_id,image_url from medicalRecord WHERE image_download='0'";
    query = @"SELECT image_name,image_id,image_url from medicalRecord WHERE image_download='0' OR (image_download='1' AND upload_image='(null)') OR (image_download='1' AND upload_image='')";
    // Get the results.
    if (self.dataFetched != nil) {
        self.dataFetched = nil;
    }
    self.dataFetched = [[NSArray alloc] initWithArray:[self.dbm loadDataFromDB:query]];
    imgDwnloadCount = [self.dataFetched count];
    
    NSInteger indexOfImageURL = [self.dbm.arrColumnNames indexOfObject:@"image_url"];
    NSInteger indexOfImageID = [self.dbm.arrColumnNames indexOfObject:@"image_id"];
    
 //   NSLog(@"Fetched data count = %lu",(unsigned long)self.fetchedData.count);
    if (self.dataFetched.count>0) {
        for (int i=0; i<self.dataFetched.count; i++) {
            NSString *imgUrls = [[self.dataFetched objectAtIndex:i]objectAtIndex:2];
            NSString *imgIDs = [[self.dataFetched objectAtIndex:i]objectAtIndex:1];
            [self downloadImages:imgUrls updateDB:imgIDs];
        }
    }else if (self.dataFetched.count==0){
        [userdef setObject:@"1" forKey:isAllImgdownload];
    }
}



-(void)downloadImages:(NSString*)imageURL updateDB:(NSString*)imageID{
  //  NSLog(@"image url= %@",imageURL);
    //    NSString*base64str =  [self imageToNSString:image];
    BOOL result = [[imageURL lowercaseString] hasPrefix:@"http://"];
    NSURL *urlAddress = nil;
    
    if (result) {
        urlAddress = [NSURL URLWithString: imageURL];
    }
    else {
        if ([[imageURL lowercaseString] hasPrefix:@"https://"]) {
            urlAddress = [NSURL URLWithString: imageURL];
        }
        else{
            NSString *url = [NSString stringWithFormat:@"http://%@", imageURL];
            urlAddress = [NSURL URLWithString: url];
        }
    }
  //   NSLog(@"image url= %@",urlAddress);
   // NSURLRequest *requestObject = [NSURLRequest requestWithURL:urlAddress];
    
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:urlAddress
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                
                if (response) {
                   // NSLog(@"respond found");
                    imgDwnloadCount--;
                    NSString *bs64 =[data base64EncodedStringWithOptions:0];
                    if (bs64 != nil || ![bs64 isEqualToString:@"(null)"] || bs64.length!=0) {
                        [self updateImageInDBWithImageID:imageID withBase64:bs64];
                    }
                    
                }else{
                   // NSLog(@"respond not found for %@",imageID);
                    imgDwnloadCount--;
                    [userdef setValue:@"0" forKey:isAllImgdownload];
                }
                if (imgDwnloadCount==0) {
                  //  NSLog(@"Total respond done");
//                    if (retryCount<5) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"imgdwnldDn" object:nil];
                    //    retryCount++;
                    //}
                }
                
            }] resume];
}

-(void)updateImageInDBWithImageID:(NSString*)imageID withBase64:(NSString*)base64str{
    
    // Form the query.
    NSString *query =[NSString stringWithFormat:@"UPDATE medicalRecord SET upload_image ='%@', image_download='1'  WHERE image_id='%@'",base64str,imageID];
    
    //                        UPDATE resep SET image_base64 = 'Texas' , is_image_download='1' WHERE image = '298.jpg';
    [self.dbm executeQuery:query];
    if (self.dbm.affectedRows != 0) {
     //   NSLog(@"Query was executed successfully. Affected rows = %d", self.dbm.affectedRows);
    }
    else{
      //  NSLog(@"Could not execute the query.");
    }
}


-(void) registerNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchImageUrlFromDB)
                                                 name:@"imgdwnldDn" object:nil];
}


//-(BOOL)openURL:(NSURL*)url
//{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    termsViewController *tvc = [storyboard instantiateViewControllerWithIdentifier:@"docOPD_TnC"];
//    tvc.fullURL = [NSString stringWithFormat:@"%@",url];
//    [self.window.rootViewController presentViewController:tvc animated:YES completion:nil];
//    return YES;
//}
@end
