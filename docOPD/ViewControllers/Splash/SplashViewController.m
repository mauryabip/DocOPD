//
//  SplashViewController.m
//  docOPD
//
//  Created by Virinchi Software on 10/23/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "SplashViewController.h"
#import "MMMaterialDesignSpinner.h"
#import "ViewController.h"
#import "FindDocVC.h"
#import "testViewController.h"
#import "UIImage+animatedGIF.h"
#import "docOPDNetworkEngine.h"


@interface SplashViewController ()
@property (nonatomic, strong) MMMaterialDesignSpinner *spinnerView;
@end

@implementation SplashViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [docOPDNetworkEngine sharedInstance].medicalRecordsByDateFlag=YES;
    [docOPDNetworkEngine sharedInstance].removeLoadFlag=YES;
    NSDate *todayDate = [NSDate date]; // get today date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d"];
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"hh:mm a"];
    NSString *convertedDateString1 = [dateFormatter1 stringFromDate:todayDate];
    
    [docOPDNetworkEngine sharedInstance].lastSyncTime=[NSString stringWithFormat:@"%@, at %@",convertedDateString,convertedDateString1];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    NSString *convertedDateString2 = [dateFormatter2 stringFromDate:todayDate];
    
    [docOPDNetworkEngine sharedInstance].lastSyncTimeDateForAPI=convertedDateString2;
    
   // self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navigationController setNavigationBarHidden:YES];
    MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectZero];
    self.spinnerView = spinnerView;
    //self.spinnerView.bounds = CGRectMake(([UIScreen mainScreen].bounds.size.width-100)/2,self.FooterView.frame.size.height+self.FooterView.frame.origin.y+10, 100, 100);
    self.spinnerView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-75)/2,self.FooterView.frame.size.height+self.FooterView.frame.origin.y+75, 75, 75);
    //self.spinnerView.bounds = CGRectMake(0,0, 100, 100);
    // self.spinnerView.tintColor = [UIColor colorWithRed:215.f/255 green:49.f/255 blue:69.f/255 alpha:1];
    self.spinnerView.tintColor = [UIColor dOPDThemeColor];
    //self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.spinnerView.lineWidth = 3.0;
    //[self.view addSubview:self.spinnerView];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"heartbeat" withExtension:@"gif"];
    self.GifHeartBeat.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    
    UILabel *LoadingView = [[UILabel alloc]initWithFrame:CGRectMake(0,self.spinnerView.frame.size.height+self.spinnerView.frame.origin.y+15, [UIScreen mainScreen].bounds.size.width, 20)];
    [LoadingView setText:@"Loading..."];
    LoadingView.textColor = [UIColor dOPDThemeColor];
    LoadingView.font = [UIFont systemFontOfSize:14.0];
    LoadingView.textAlignment = NSTextAlignmentCenter;
   // [self.view addSubview:LoadingView];
      userdef = userDefault;
    if ([[userdef objectForKey:isLogin]isEqualToString:@"Yes"]) {
         [self performSelector:@selector(skipToGetData) withObject:nil afterDelay:5.000];
    }else{
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(skipToGetData) userInfo:nil repeats:NO];
    }
    
   
 
    if (![AppDelegate MyappDelegate].isInternet) {
         [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(skipToGetData) userInfo:nil repeats:NO];
    }
    [self startLoader];

}

- (void)startLoader {
    [self.loadingView showView:YES];

}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"SplashScreen"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"SplashScreen"];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.spinnerView startAnimating];
}


#pragma mark - API Calling

-(void)ApiCalling{
//    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetDocList], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userdef objectForKey:AuthKey],AuthKey,nil];
    
//    NSLog(@"dataDic for Reg: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetDocList;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
    
    
}


-(void)GetHospitalList{
    //    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetHospitalList], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userdef objectForKey:AuthKey],AuthKey,nil];
    
//    NSLog(@"dataDic for Reg: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetHospitalList;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
}


-(void)GetProcedureList{
    //    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetProcedureList], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userdef objectForKey:AuthKey],AuthKey,nil];
    
//    NSLog(@"dataDic for Reg: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetProcedureList;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
}

#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
//    [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
//    NSLog(@"splash Controller requestFinished for %d",currentRequestType);
    
   if (currentRequestType==kGetMedicalRecords) {
//        NSLog(@"response from appdelegate = %@",[AppDelegate MyappDelegate].allDocList);
       
    }
    
    
    
}

#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response

{
    //NSLog(@"response = %@",response);
  
//    NSLog(@"splash status1 message");
  

    if (currentRequestType==kGetDocList) {
        NSMutableArray *resposeCode=[response objectForKey:@"DoctorList"];
        [AppDelegate MyappDelegate].allDocList = resposeCode;
//          NSLog(@"response from appdelegate = %@",[AppDelegate MyappDelegate].allDocList);
         [self performSelector:@selector(GetHospitalList) withObject:nil afterDelay:.000];
    }else if (currentRequestType==kGetHospitalList){
        NSMutableArray *resposeCode=[response objectForKey:@"HospitalList"];
        [AppDelegate MyappDelegate].allHospList = resposeCode;
//          NSLog(@"response from appdelegate = %@",[AppDelegate MyappDelegate].allHospList);
        [self performSelector:@selector(GetProcedureList) withObject:nil afterDelay:.000];
    }else if (currentRequestType==kGetProcedureList){
        NSMutableArray *resposeCode=[response objectForKey:@"ProcedureList"];
       [AppDelegate MyappDelegate].allProcedureList = resposeCode;
//          NSLog(@"response from appdelegate = %@",[AppDelegate MyappDelegate].allProcedureList);
         [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(skipToGetData) userInfo:nil repeats:NO];
    }
}
    


- (void) requestError
{
//    NSLog(@"RegisterViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
    [self skipToGetData];
}



-(void)skipToGetData{
    [self.loadingView showView:NO];
    if ([[userdef objectForKey:isLogin]isEqualToString:@"Yes"]) {
//        NSLog(@"User logged in");HomeVC
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        FindDocVC *findDoc = [storyboard instantiateViewControllerWithIdentifier:@"docOPD_FindDoc"];
//       [self.navigationController pushViewController:findDoc animated:NO];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeVC *HomeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        [self.navigationController pushViewController:HomeVC animated:NO];
        
//        testViewController *test = [self.storyboard instantiateViewControllerWithIdentifier:@"test"];
//        [self.navigationController pushViewController:test animated:YES];
    }else{
        ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_Login"];
        [self.navigationController pushViewController:login animated:YES];
    }
}


@end
