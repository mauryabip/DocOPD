//
//  HospListVC.m
//  docOPD
//
//  Created by Ashutosh Kumar on 8/11/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "HospListVC.h"
#import "HospitalProfileVC.h"
#import "UIImageView+WebCache.h"
#import "testViewController.h"
typedef enum{
    kTAG_HospitalDetailView = 999999999,
}ALLTAGS;
@interface HospListVC ()

@end

@implementation HospListVC

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES];
    pgIndex = @"1";
    hosptalData = [[NSMutableArray alloc]init];
   // hosptalData = [[NSMutableArray alloc]initWithObjects:@"Batra Hospital",@"Paras HMRI", @"Paras FMRI", nil];
    [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.000];
//    [self mainView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"Hospital Search"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

#pragma mark  - mainView View
-(void)mainView{
    UIView *HospitalDetailView;
    int HosViewNewOriginmargin =0;
    for (int i=0; i<hosptalData.count; i++) {
        HospitalDetailView = [[UIView alloc]init];
        HospitalDetailView.frame = CGRectMake(8, 8+ HosViewNewOriginmargin, [UIScreen mainScreen].bounds.size.width-16, 159);
        
        HospitalDetailView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
        [self.ContentView addSubview:HospitalDetailView];
        HospitalDetailView.tag= kTAG_HospitalDetailView;
        
        
        //Hospital Button for view profile
        
        UIButton *HospitalProfilebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        HospitalProfilebutton.frame = CGRectMake(0, 0, HospitalDetailView.frame.size.width, HospitalDetailView.frame.size.height);
//        [HospitalProfilebutton setBackgroundColor:[UIColor dOPDThemeColor]];
        [HospitalDetailView addSubview:HospitalProfilebutton];
        [HospitalProfilebutton addTarget:self action:@selector(ViewHospProfile:) forControlEvents:UIControlEventTouchUpInside];
        HospitalProfilebutton.tag = i+1;

        UIView *hospitalLeftsideview = [[UIView alloc]init];
        hospitalLeftsideview.frame= CGRectMake(0, 0, HospitalDetailView.frame.size.width/4 ,HospitalDetailView.frame.size.height - HospitalDetailView.frame.size.height);
        
        [HospitalDetailView addSubview:hospitalLeftsideview];
        
        
        UIImageView *HospImage = [[UIImageView alloc]init];
    //    if ([UIScreen mainScreen].bounds.size.width <= 320 ) {
    //        HospImage.frame= CGRectMake(18.0, 18.0, 44, 44);
    //        
    //    }
    //    else{
            HospImage.frame= CGRectMake(8, 6.0, 100, 100);
        //}
        HospImage.layer.cornerRadius = 50.0;
        HospImage.layer.masksToBounds = YES;
        [hospitalLeftsideview addSubview:HospImage];
        
        
        [HospImage sd_setImageWithURL:[NSURL URLWithString:[hosptalData objectAtIndex:i][@"HosPicURL"]]
                          placeholderImage:[UIImage imageNamed:@"def-hospital.png"] options:SDWebImageRefreshCached];
        //HospImage.image = [UIImage imageNamed:@"def-hospital.png"];
        
        
        UIView *hospitalRightsideview = [[UIView alloc]init];
        hospitalRightsideview.frame= CGRectMake(hospitalLeftsideview.frame.size.width + hospitalLeftsideview.frame.origin.x, hospitalLeftsideview.frame.origin.y,HospitalDetailView.frame.size.width -  hospitalLeftsideview.frame.origin.x -hospitalLeftsideview.frame.size.width,hospitalLeftsideview.frame.size.height);
        
        [HospitalDetailView addSubview:hospitalRightsideview];
        
        UILabel *HosNameLbl = [[UILabel alloc]init];
        
        if ([UIScreen mainScreen].bounds.size.width <= 320 ) {
            HosNameLbl.frame = CGRectMake(hospitalRightsideview.frame.size.width/10, HospImage.frame.origin.y+5, hospitalRightsideview.frame.size.width-hospitalRightsideview.frame.size.width/10, 21);
            
        }
        else{
            HosNameLbl.frame = CGRectMake(hospitalRightsideview.frame.size.width/7, HospImage.frame.origin.y+5, hospitalRightsideview.frame.size.width - HospImage.frame.origin.x - HospImage.frame.size.width -30, 21);
            
        }
        
        //    HosNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(hospitalRightsideview.frame.size.width/7, HospImage.frame.origin.y-5, hospitalRightsideview.frame.size.width - HospImage.frame.origin.x - HospImage.frame.size.width -30, 21)];
       // HosNameLbl.text = @"B.L Kapoor Hospital";
        HosNameLbl.text = [hosptalData objectAtIndex:i][@"HospitalName"];
        HosNameLbl.textColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:49.0/255.0 alpha:1.0];
        HosNameLbl.font = [UIFont systemFontOfSize:14.0];
        [hospitalRightsideview addSubview:HosNameLbl];
        
        
        UIImageView *HospLocImg = [[UIImageView alloc]initWithFrame:CGRectMake(HosNameLbl.frame.origin.x, HosNameLbl.frame.origin.y + HosNameLbl.frame.size.height+10, 12, 12)];
        [hospitalRightsideview addSubview:HospLocImg];
        HospLocImg.image = [UIImage imageNamed:@"location.png"];
        
        UILabel *HospLocLbl = [[UILabel alloc]initWithFrame:CGRectMake(HospLocImg.frame.origin.x + HospLocImg.frame.size.width+5, HosNameLbl.frame.origin.y + HosNameLbl.frame.size.height+9, hospitalRightsideview.frame.size.width - HospLocImg.frame.origin.x - HospLocImg.frame.size.width -8, 13)];
        HospLocLbl.text = [hosptalData objectAtIndex:i][@"HospitalAddress"];
        HospLocLbl.textColor = [UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0];
        HospLocLbl.font = [UIFont systemFontOfSize:11.0];
        [hospitalRightsideview addSubview:HospLocLbl];
        
        
        UIImageView *HospSurgeryImg = [[UIImageView alloc]initWithFrame:CGRectMake(HospLocImg.frame.origin.x, HospLocLbl.frame.origin.y + HospLocLbl.frame.size.height+8, 12, 12)];
        [hospitalRightsideview addSubview:HospSurgeryImg];
        HospSurgeryImg.image = [UIImage imageNamed:@"surgery.png"];
        
        UILabel *HospSurgeryLbl = [[UILabel alloc]initWithFrame:CGRectMake(HospSurgeryImg.frame.origin.x + HospSurgeryImg.frame.size.width+5, HospLocLbl.frame.origin.y + HospLocLbl.frame.size.height+7, hospitalRightsideview.frame.size.width - HospSurgeryImg.frame.origin.x - HospSurgeryImg.frame.size.width, 13)];
        NSString *hosSpecp;
        NSMutableArray *hospitalsp =[hosptalData objectAtIndex:i][@"HospitalSpecialities"];
//        if (!([hosptalData objectAtIndex:i][@"HospitalSpecialities"])||([hosptalData objectAtIndex:i][@"HospitalSpecialities"])==(id)[NSNull null] || [([hosptalData objectAtIndex:i][@"HospitalSpecialities"]) isKindOfClass:[NSNull class]] || !(hospitalsp.count))
//        {
        if (hospitalsp == nil || hospitalsp==(id)[NSNull null] || [hospitalsp isKindOfClass:[NSNull class]])
        {
             hosSpecp = @"NA";
        }else{
            NSMutableArray *stringcon = [[NSMutableArray alloc]init];
            for (int j=0; j<hospitalsp.count; j++) {
                hosSpecp = [NSString stringWithFormat:@"%@",[hospitalsp objectAtIndex:j][@"SpecialistName"]];
                [stringcon addObject:hosSpecp];
            }
//            NSLog(@"Array for spe: %@",stringcon);
         hosSpecp = [stringcon componentsJoinedByString:@","];
            
        }
        HospSurgeryLbl.text = hosSpecp;
        HospSurgeryLbl.textColor = [UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0];
        HospSurgeryLbl.font = [UIFont systemFontOfSize:11.0];
        [hospitalRightsideview addSubview:HospSurgeryLbl];
        
        
        UILabel *oldRateLbl = [[UILabel alloc]initWithFrame:CGRectMake(HospImage.frame.origin.x, HospImage.frame.origin.y + HospImage.frame.size.height+5, HospImage.frame.size.width, 14)];
       // oldRateLbl.text = @"INR 800";
        oldRateLbl.font = [UIFont systemFontOfSize:11.0];
        oldRateLbl.textAlignment = NSTextAlignmentCenter;
        oldRateLbl.textColor = [UIColor colorWithRed:92.0/255.0 green:91.0/255.0 blue:91.0/255.0 alpha:1.0];
        [hospitalLeftsideview addSubview:oldRateLbl];
        
        
        
        
   //     NSDictionary* attributes = @{
//                                     NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle],NSStrikethroughColorAttributeName: [UIColor colorWithRed:69.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0]
//                                     };
//        
      //  NSAttributedString* attributeString = [[NSAttributedString alloc] initWithString:oldRateLbl.text attributes:attributes];
     //   oldRateLbl.attributedText = attributeString;
        
    #pragma mark NewRateView
        //newRateView View Generate
        
        UIView *newRateView =[[UIView alloc]init];
        
        if ([UIScreen mainScreen].bounds.size.width <= 320 ) {
            
            newRateView.frame = CGRectMake(HospImage.frame.origin.x, oldRateLbl.frame.origin.y + oldRateLbl.frame.size.height+5, oldRateLbl.frame.size.width+10, 20);
            
        }
        else
        {
    //        newRateView.frame = CGRectMake(oldRateLbl.frame.origin.x-20, oldRateLbl.frame.origin.y + oldRateLbl.frame.size.height+5, oldRateLbl.frame.size.width+20, 20);
            newRateView.frame = CGRectMake(HospImage.frame.origin.x, oldRateLbl.frame.origin.y + oldRateLbl.frame.size.height+5, oldRateLbl.frame.size.width+20, 20);
        }
      //  newRateView.backgroundColor = [UIColor dOPDThemeColor];
        [HospitalDetailView addSubview:newRateView];
        
        
        UIImageView *NewRateImg = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 12, 8)];
        [newRateView addSubview:NewRateImg];
    //    NewRateImg.image = [UIImage imageNamed:@"whitecheck.png"];
        
        
        UILabel *NewRateLbl = [[UILabel alloc]initWithFrame:CGRectMake(NewRateImg.frame.origin.x + NewRateImg.frame.size.width+4, 3, 45, 14)];
     //   NewRateLbl.text = @"INR 499";
        NewRateLbl.font = [UIFont systemFontOfSize:11.0];
        NewRateLbl.textColor = [UIColor whiteColor];
        [newRateView addSubview:NewRateLbl];
        
        
        //Enquiry View Generate
        UIView *enquiryView =[[UIView alloc]initWithFrame:CGRectMake(HosNameLbl.frame.origin.x, HospSurgeryLbl.frame.origin.y + HospSurgeryLbl.frame.size.height+10, 70, 30)];
        enquiryView.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
        enquiryView.layer.borderWidth = 1.0;
        enquiryView.layer.cornerRadius = 5.0;
        [hospitalRightsideview addSubview:enquiryView];
        
        
        UIImageView *HospEnqImg = [[UIImageView alloc]initWithFrame:CGRectMake(7, 8 , 14, 14)];
        [enquiryView addSubview:HospEnqImg];
        HospEnqImg.image = [UIImage imageNamed:@"enquiry.png"];
        
        UILabel *HospEnqLbl = [[UILabel alloc]initWithFrame:CGRectMake(HospEnqImg.frame.origin.x + HospEnqImg.frame.size.width+5, 8, 40, 14)];
        HospEnqLbl.text = @"Enquiry";
        HospEnqLbl.font = [UIFont systemFontOfSize:11.0];
        HospEnqLbl.textColor = [UIColor dOPDThemeColor];
        [enquiryView addSubview:HospEnqLbl];
        
        //Appointment View Generate
        UIView *AppointmentView =[[UIView alloc]init];
        AppointmentView.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
        AppointmentView.layer.borderWidth = 1.0;
        AppointmentView.layer.cornerRadius = 5.0;
        [hospitalRightsideview addSubview:AppointmentView];
        
        
        UIImageView *AppointmentImg = [[UIImageView alloc]initWithFrame:CGRectMake(7, 8 , 14, 14)];
        [AppointmentView addSubview:AppointmentImg];
        AppointmentImg.image = [UIImage imageNamed:@"blue-appointment.png"];
        
        UILabel *AppointmentLbl = [[UILabel alloc]initWithFrame:CGRectMake(AppointmentImg.frame.origin.x + AppointmentImg.frame.size.width+5, 8, 100, 14)];
        AppointmentLbl.font = [UIFont systemFontOfSize:11.0];
        AppointmentLbl.textColor = [UIColor dOPDThemeColor];
        [AppointmentView addSubview:AppointmentLbl];
        
        if ([UIScreen mainScreen].bounds.size.width <= 320 ) {
            AppointmentView.frame = CGRectMake(enquiryView.frame.origin.x + enquiryView.frame.size.width + 10, enquiryView.frame.origin.y, 100, 30);
            AppointmentLbl.text = @"Appointment";
            
        }else {
            AppointmentView.frame = CGRectMake(enquiryView.frame.origin.x + enquiryView.frame.size.width + 10, enquiryView.frame.origin.y, 128, 30);
            AppointmentLbl.text = @"Book Appointment";
        }

        CGRect ReframeHospitalView = HospitalDetailView.frame;
        ReframeHospitalView.size.height = enquiryView.frame.origin.y + enquiryView.frame.size.height+10;
        HospitalDetailView.frame = ReframeHospitalView;
        HosViewNewOriginmargin = HosViewNewOriginmargin + HospitalDetailView.frame.size.height+8;
    }
    
    
}
#pragma mark - View Hospital Profile

-(void)ViewHospProfile: (UIButton*)sender{

    HospitalProfileVC *HosProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_HospitalProfile"];
    HosProfile.hosData = [hosptalData objectAtIndex:sender.tag-1];
    HosProfile.hosname = [hosptalData objectAtIndex:sender.tag-1][@"HospitalName"];
//    NSLog(@"last");
//    testViewController *test = [self.storyboard instantiateViewControllerWithIdentifier:@"test"];
//    [self.navigationController pushViewController:test animated:YES];
    
    [self.navigationController pushViewController:HosProfile animated:YES];

}

#pragma mark - GoTOBack

- (IBAction)GoToBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - API Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetHospitalByHosName], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.hosName,HospitalName,pgIndex,PageIndex,nil];
    
//    NSLog(@"dataDic for GetHospitalListByName: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetHospitalByHosName;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
    
    
}

#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
//    NSLog(@"hospital Controller requestFinished");
}


#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response

{
//    NSLog(@"response = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    
    NSMutableArray *resposeCode=[response objectForKey:@"HospitalList"];
    
    [resposeCode addObject:response];
    [hosptalData addObject:response];
    [self mainView];
    
    
}

- (void) requestError
{
//    NSLog(@"hospital ViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
