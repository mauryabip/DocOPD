//
//  DoctorsListVC.m
//  docOPD
//
//  Created by Ashutosh Kumar on 8/5/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "DoctorsListVC.h"
#import "DocProfileVC.h"
#import "UIImageView+WebCache.h"
typedef enum{
    kTAG_DocInfoView = 11,
    kTAG_DocNameView,
    kTAG_HospitalDetailView,
    kTAG_ScrollView,
    kTAG_ContentView,
}ALLTAGS;
@interface DoctorsListVC ()

@end

@implementation DoctorsListVC
@synthesize nameLbl,nameView;
- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES];
    self.Scroller.tag = kTAG_ScrollView;
    self.ContentView.tag = kTAG_ContentView;
     pgIndex = @"1";
//    NSLog(@"Doctor data from search list is : %@",self.DocData);
    maindata = [[NSMutableArray alloc]init];
    dataarr = [[NSMutableArray alloc]init];
//    for (int i=0; i<dataarr.count; i++) {
//        CGRect newframe = nameView.frame;
//        nameLbl.text = [dataarr objectAtIndex:i];
//        newframe.origin.y = nameView.layer.frame.origin.y + nameView.layer.frame.size.height;
//        nameView.frame = newframe;
//        [self.ContentView addSubview:nameView];
//    }
    
    
    if([self.dataShowFor isEqualToString:@"procedure"]){
        
//        NSLog(@"Data show for procedure");
        self.LblTitleBar.text = @"Procedure Search Results";
        [self performSelector:@selector(ApiCallingForProcedure) withObject:nil afterDelay:0.00];
        
    }else if ([self.dataShowFor isEqualToString:@"doctor"])
    {
//        NSLog(@"Data show for doctor");
        self.LblTitleBar.text = @"Doctor Search Results";
        [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.00];
        
    }
    else if ([self.dataShowFor isEqualToString:@"hospital"]){
//        NSLog(@"Data show for hospital");
        self.LblTitleBar.text = @"Hospital Search Results";
        [self performSelector:@selector(ApiCallingForHospital) withObject:nil afterDelay:0.00];
        
    }

//        [self mainView];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark  - mainView View
-(void)mainView{
 
#pragma mark Doctor View
    int DocViewNewOriginmargin = 0;
    UIView *DocInfoView;
    for (int d=0; d<maindata.count; d++) {
        DocInfoView = [[UIView alloc]initWithFrame:CGRectMake(8, 8+ DocViewNewOriginmargin, [UIScreen mainScreen].bounds.size.width-16, 159)];
        [self.ContentView addSubview:DocInfoView];
        DocInfoView.tag= kTAG_DocInfoView;
        DocInfoView.backgroundColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
        
        UIView *DocImageView = [[UIView alloc]initWithFrame:CGRectMake(1, 1, DocInfoView.frame.size.width/4,85)];
         DocImageView.backgroundColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        [DocInfoView addSubview:DocImageView];

        UIImageView *docImage = [[UIImageView alloc]init] ;
    //   if ([UIScreen mainScreen].bounds.size.width <= 320 )
    //   {
    //       docImage.frame= CGRectMake(8.0, 8.0, 50, 50);
    //       docImage.layer.cornerRadius = 25.0;
    //
    //   }else {
           docImage.frame= CGRectMake(8.0, 6.0, 60, 60);
           docImage.layer.cornerRadius = 30.0;

      // }
        
            docImage.layer.masksToBounds = YES;
        [DocImageView addSubview:docImage];
        [docImage sd_setImageWithURL:[NSURL URLWithString:[maindata objectAtIndex:d][@"DocPicURL"]] placeholderImage:[UIImage imageNamed:@"doctor-96.png"] options:SDWebImageRefreshCached];
        
        
        UIView *DocNameView = [[UIView alloc]init];
        DocNameView.frame = CGRectMake(DocImageView.frame.size.width+DocImageView.frame.origin.x, 1, DocInfoView.frame.size.width-DocImageView.frame.origin.x -DocImageView.frame.size.width-1, 85.0);
        DocNameView.backgroundColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        [DocInfoView addSubview:DocNameView];
        DocInfoView.tag= kTAG_DocNameView;

    //    UIImageView *docImage = [[UIImageView alloc]init] ;
    //    docImage.frame= CGRectMake(8.0, 8.0, 50, 50);
    //    docImage.layer.cornerRadius = 25.0;
    //    docImage.layer.masksToBounds = YES;
    //    [DocNameView addSubview:docImage];
    //    docImage.image = [UIImage imageNamed:@"man.png"];
        
        
        UILabel *docNameLbl = [[UILabel alloc]init];
        if ([UIScreen mainScreen].bounds.size.width <= 320 ){
         docNameLbl.frame= CGRectMake(DocNameView.frame.size.width/10, docImage.frame.origin.y, DocNameView.frame.size.width -DocNameView.frame.size.width/10, 21);
        }else{
         docNameLbl.frame= CGRectMake(DocNameView.frame.size.width/7, docImage.frame.origin.y, DocNameView.frame.size.width - DocNameView.frame.size.width/7, 21);
        }
        
        
        //CGRectMake(hospitalRightsideview.frame.size.width/7, HospImage.frame.origin.y-5, hospitalRightsideview.frame.size.width - HospImage.frame.origin.x - HospImage.frame.size.width -30, 21)];

        docNameLbl.text = [NSString stringWithFormat:@"%@ %@ %@",[maindata objectAtIndex:d][@"FirstName"],[maindata objectAtIndex:d][@"MiddleName"],[maindata objectAtIndex:d][@"LastName"]];
        //docNameLbl.text = [maindata objectAtIndex:d];
        docNameLbl.textColor = [UIColor whiteColor];
        docNameLbl.font = [UIFont boldSystemFontOfSize:16.0];
        docname = docNameLbl.text;
        [DocNameView addSubview:docNameLbl];
        
//        UIButton *DocProfileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        DocProfileBtn.frame = CGRectMake(0, 0, DocInfoView.frame.size.width, DocInfoView.frame.size.height);
//        [DocProfileBtn addTarget:self action:@selector(OpenDoctorProfile:) forControlEvents:UIControlEventTouchUpInside];
//        DocProfileBtn.tag = d+1;
//        NSLog(@"Docprofilebutton tag %d",DocProfileBtn.tag);
//        [DocProfileBtn setBackgroundColor:[UIColor yellowColor]];
//        [DocInfoView addSubview:DocProfileBtn];
        
        
        UIImageView *docDegree = [[UIImageView alloc]initWithFrame:CGRectMake(docNameLbl.frame.origin.x, docNameLbl.frame.origin.y + docNameLbl.frame.size.height+8, 12, 12)];
        [DocNameView addSubview:docDegree];
        docDegree.image = [UIImage imageNamed:@"white-degree.png"];
        
        UILabel *docDegreeLbl = [[UILabel alloc]initWithFrame:CGRectMake(docDegree.frame.origin.x + docDegree.frame.size.width+5, docNameLbl.frame.origin.y + docNameLbl.frame.size.height+7, DocNameView.frame.size.width - docDegree.frame.origin.x - docDegree.frame.size.width -8, 13)];
        docDegreeLbl.text = [maindata objectAtIndex:d][@"Qualification"];
        docDegreeLbl.textColor = [UIColor whiteColor];
        docDegreeLbl.font = [UIFont systemFontOfSize:11.0];
        [DocNameView addSubview:docDegreeLbl];
        
        
        UIImageView *docExp = [[UIImageView alloc]initWithFrame:CGRectMake(docDegree.frame.origin.x, docDegreeLbl.frame.origin.y + docDegreeLbl.frame.size.height+8, 12, 12)];
        [DocNameView addSubview:docExp];
        docExp.image = [UIImage imageNamed:@"white-expierance.png"];
        
        UILabel *docExpLbl = [[UILabel alloc]initWithFrame:CGRectMake(docExp.frame.origin.x + docExp.frame.size.width+5, docDegreeLbl.frame.origin.y + docDegreeLbl.frame.size.height+7, DocNameView.frame.size.width/2 - docExp.frame.origin.x - docExp.frame.size.width, 13)];
        docExpLbl.text =[maindata objectAtIndex:d][@"Experience"];;
        docExpLbl.textColor = [UIColor whiteColor];
        docExpLbl.font = [UIFont systemFontOfSize:11.0];
        [DocNameView addSubview:docExpLbl];
        
        
        UIImageView *docReview = [[UIImageView alloc]initWithFrame:CGRectMake(docExpLbl.frame.origin.x + docExpLbl.frame.size.width+8, docExp.frame.origin.y, 12, 12)];
        [DocNameView addSubview:docReview];
        docReview.image = [UIImage imageNamed:@"white-review.png"];
        
        UILabel *docReviewLbl = [[UILabel alloc]initWithFrame:CGRectMake(docReview.frame.origin.x + docReview.frame.size.width+5, docDegreeLbl.frame.origin.y + docDegreeLbl.frame.size.height+7, DocNameView.frame.size.width - docImage.frame.origin.x - docReview.frame.size.width - docReview.frame.origin.x, 13)];
        docReviewLbl.text =  [maindata objectAtIndex:d][@"TotalReview"];
        docReviewLbl.textColor = [UIColor whiteColor];
        docReviewLbl.font = [UIFont systemFontOfSize:11.0];
        [DocNameView addSubview:docReviewLbl];

       
        
        CGRect reframeDocNameview = DocNameView.frame;
        reframeDocNameview.size.height = docReviewLbl.frame.origin.y + docReviewLbl.frame.size.height +8;
        DocNameView.frame = reframeDocNameview;
//        NSLog(@"%f", DocNameView.frame.size.height);

        CGRect docimgView= DocImageView.frame;
        docimgView.size.height = DocNameView.frame.size.height;
        DocImageView.frame = docimgView;


        
        
        UIButton *DocProfileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        DocProfileBtn.frame = CGRectMake(0, 0, DocNameView.frame.size.width, DocNameView.frame.size.height);
        [DocProfileBtn addTarget:self action:@selector(OpenDoctorProfile:) forControlEvents:UIControlEventTouchUpInside];
        DocProfileBtn.tag = d+1;
    //    NSLog(@"Docprofilebutton tag %d",DocProfileBtn.tag);
     //   [DocProfileBtn setBackgroundColor:[UIColor yellowColor]];
        [DocNameView addSubview:DocProfileBtn];
        
        
        
      
    // Hospital DeailView
    #pragma mark Hospital DeailView
//        UIView *HospitalDetailView;
//        [DocInfoView addSubview:HospitalDetailView];
//        int count=0;
        
        dataarr =  [[resposeCode objectAtIndex:d]valueForKey:@"HospitalList"];
        if (dataarr.count)
        {
            UIView *HospitalDetailView;
            [DocInfoView addSubview:HospitalDetailView];
//              NSLog(@"Data Arr have data ");
     
//            NSLog(@"Data Arr: %@ for index %d",dataarr,d);
            int count=0;
            for (int i=0; i<dataarr.count; i++)
            {
        //        UILabel *horizontalLine = [[UILabel alloc]init];
        //        horizontalLine.frame = CGRectMake(1,DocNameView.frame.origin.y + DocNameView.frame.size.height, HospitalDetailView.frame.size.width, 1);
        //        horizontalLine.backgroundColor = [UIColor dOPDTFFontColor];
        //        [HospitalDetailView addSubview:horizontalLine];
          
                
                HospitalDetailView = [[UIView alloc]init];
                HospitalDetailView.frame = CGRectMake(1, DocNameView.frame.origin.y + DocNameView.frame.size.height + count, DocInfoView.frame.size.width-2, 120.0);
                
               // HospitalDetailView.frame = CGRectMake(1, horizontalLine.frame.origin.y + horizontalLine.frame.size.height + count, DocInfoView.frame.size.width-2, 120.0);
                
                HospitalDetailView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
                [DocInfoView addSubview:HospitalDetailView];
                HospitalDetailView.tag= kTAG_HospitalDetailView;

                
                UIView *hospitalLeftsideview = [[UIView alloc]init];
                hospitalLeftsideview.frame= CGRectMake(0, 0, DocInfoView.frame.size.width/4 ,DocInfoView.frame.size.height - DocNameView.frame.size.height);
                
                [HospitalDetailView addSubview:hospitalLeftsideview];
                
                
                UIImageView *HospImage = [[UIImageView alloc]init];
                if ([UIScreen mainScreen].bounds.size.width <= 320 ) {
                    HospImage.frame= CGRectMake(18.0, 5.0, 50, 50);
                    
                }
                else{
                HospImage.frame= CGRectMake(28.0, 8.0, 50, 50);
                }
                HospImage.layer.cornerRadius = 25.0;
                HospImage.layer.masksToBounds = YES;
                [hospitalLeftsideview addSubview:HospImage];
                [HospImage sd_setImageWithURL:[NSURL URLWithString:[dataarr objectAtIndex:i][@"HosPicURL"]] placeholderImage:[UIImage imageNamed:@"def-hospital.png"] options:SDWebImageRefreshCached];

                
                UIView *hospitalRightsideview = [[UIView alloc]init];
                hospitalRightsideview.frame= CGRectMake(hospitalLeftsideview.frame.size.width + hospitalLeftsideview.frame.origin.x, hospitalLeftsideview.frame.origin.y,HospitalDetailView.frame.size.width -  hospitalLeftsideview.frame.origin.x -hospitalLeftsideview.frame.size.width,hospitalLeftsideview.frame.size.height);
              
                [HospitalDetailView addSubview:hospitalRightsideview];
                
                UILabel *HosNameLbl = [[UILabel alloc]init];
                
                if ([UIScreen mainScreen].bounds.size.width <= 320 ) {
                    HosNameLbl.frame = CGRectMake(hospitalRightsideview.frame.size.width/10, HospImage.frame.origin.y-5, hospitalRightsideview.frame.size.width-hospitalRightsideview.frame.size.width/10, 21);

                }
                else{
    //                HosNameLbl.frame = CGRectMake(hospitalRightsideview.frame.size.width/7, HospImage.frame.origin.y-5, hospitalRightsideview.frame.size.width - HospImage.frame.origin.x - HospImage.frame.size.width -30, 21);
                    HosNameLbl.frame = CGRectMake(hospitalRightsideview.frame.size.width/7, HospImage.frame.origin.y-5, hospitalRightsideview.frame.size.width-hospitalRightsideview.frame.size.width/7 , 21);

                }
                
            //    HosNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(hospitalRightsideview.frame.size.width/7, HospImage.frame.origin.y-5, hospitalRightsideview.frame.size.width - HospImage.frame.origin.x - HospImage.frame.size.width -30, 21)];
                HosNameLbl.text = [dataarr objectAtIndex:i][@"HospitalName"];
                HosNameLbl.textColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:49.0/255.0 alpha:1.0];
                HosNameLbl.font = [UIFont systemFontOfSize:13.0];
                [hospitalRightsideview addSubview:HosNameLbl];

                
                UIImageView *HospLocImg = [[UIImageView alloc]initWithFrame:CGRectMake(HosNameLbl.frame.origin.x, HosNameLbl.frame.origin.y + HosNameLbl.frame.size.height+4, 12, 12)];
                [hospitalRightsideview addSubview:HospLocImg];
                HospLocImg.image = [UIImage imageNamed:@"location.png"];
                
                UILabel *HospLocLbl = [[UILabel alloc]initWithFrame:CGRectMake(HospLocImg.frame.origin.x + HospLocImg.frame.size.width+5, HosNameLbl.frame.origin.y + HosNameLbl.frame.size.height+3, hospitalRightsideview.frame.size.width - HospLocImg.frame.origin.x - HospLocImg.frame.size.width -8, 13)];
                HospLocLbl.text = [dataarr objectAtIndex:i][@"HospitalAddress"];
                HospLocLbl.textColor = [UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0];
                HospLocLbl.font = [UIFont systemFontOfSize:11.0];
                [hospitalRightsideview addSubview:HospLocLbl];
                
                
                UIImageView *HospSurgeryImg = [[UIImageView alloc]initWithFrame:CGRectMake(HospLocImg.frame.origin.x, HospLocLbl.frame.origin.y + HospLocLbl.frame.size.height+4, 12, 12)];
                [hospitalRightsideview addSubview:HospSurgeryImg];
                HospSurgeryImg.image = [UIImage imageNamed:@"surgery.png"];
                
                UILabel *HospSurgeryLbl = [[UILabel alloc]initWithFrame:CGRectMake(HospSurgeryImg.frame.origin.x + HospSurgeryImg.frame.size.width+5, HospLocLbl.frame.origin.y + HospLocLbl.frame.size.height+3, hospitalRightsideview.frame.size.width - HospSurgeryImg.frame.origin.x - HospSurgeryImg.frame.size.width, 13)];
               
                NSMutableArray *hospitalsp = [[NSMutableArray alloc]init];;
                hospitalsp =[maindata objectAtIndex:d][@"DoctorSpecialities"];
                 NSString *hosSpecp;
            
    //            if (!hospitalsp.count || hospitalsp == nil || hospitalsp==(id)[NSNull null] || [hospitalsp isKindOfClass:[NSNull class]])
    //            {
    //                hosSpecp = @"NA";
    //            }else{
    //                NSMutableArray *stringcon = [[NSMutableArray alloc]init];
    //                for (int j=0; j<hospitalsp.count; j++) {
    //                    hosSpecp = [NSString stringWithFormat:@"%@",[hospitalsp objectAtIndex:j][@"SpecialistName"]];
    //                    [stringcon addObject:hosSpecp];
    //                }
    //                NSLog(@"Array for spe: %@",stringcon);
    //                hosSpecp = [stringcon componentsJoinedByString:@","];
    //            }
                
                
                if ([maindata objectAtIndex:d][@"DoctorSpecialities"] == nil || [[maindata objectAtIndex:d][@"DoctorSpecialities"] length] == 0 || ![maindata objectAtIndex:d][@"DoctorSpecialities"] || ([maindata objectAtIndex:d][@"DoctorSpecialities"]==[NSNull null]) || [[maindata objectAtIndex:d][@"DoctorSpecialities"] isEqual:(id)[NSNull class]]) {
                    hosSpecp = NA;
                }
                else{
                    HospSurgeryLbl.text =[maindata objectAtIndex:d][@"DoctorSpecialities"];
                }
             
                HospSurgeryLbl.textColor = [UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0];
                HospSurgeryLbl.font = [UIFont systemFontOfSize:11.0];
                [hospitalRightsideview addSubview:HospSurgeryLbl];


                UILabel *oldRateLbl = [[UILabel alloc]initWithFrame:CGRectMake(HospImage.frame.origin.x, HospImage.frame.origin.y + HospImage.frame.size.height+2, 60, 14)];
                //oldRateLbl.text = @"INR 800";
                NSString *DocFee=[dataarr objectAtIndex:i][@"DoctorFee"];
                NSString *DocDisFee=[dataarr objectAtIndex:i][@"DoctorDiscountedFee"];
                
           //     if (([[maindata objectAtIndex:d][@"ConsultationFee"] isKindOfClass:[NSNull class]]) || !([maindata objectAtIndex:d][@"ConsultationFee"]) || [maindata objectAtIndex:d][@"ConsultationFee"] == nil || [[maindata objectAtIndex:d][@"ConsultationFee"] length] == 0 )
                
                if (DocDisFee.length)
                {
    //                if (([[dataarr objectAtIndex:i][@"DoctorFee"] isKindOfClass:[NSNull class]]) || !([dataarr objectAtIndex:i][@"DoctorFee"]) || [dataarr objectAtIndex:i][@"DoctorFee"] == nil || (!DocFee.length))
                   if ((!DocFee.length))
                    {
                        oldRateLbl.text = NA;
                        oldRateLbl.hidden = true;
                    }else{
                        oldRateLbl.hidden = false;
                        oldRateLbl.text = DocFee;
                    }
                    
                    oldRateLbl.font = [UIFont systemFontOfSize:11.0];
                    oldRateLbl.textColor = [UIColor colorWithRed:92.0/255.0 green:91.0/255.0 blue:91.0/255.0 alpha:1.0];
                    [hospitalLeftsideview addSubview:oldRateLbl];
                    
                    NSDictionary* attributes = @{
                                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle],NSStrikethroughColorAttributeName: [UIColor colorWithRed:69.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0]
                                                 };
                    
                    NSAttributedString* attributeString = [[NSAttributedString alloc] initWithString:oldRateLbl.text attributes:attributes];
                    oldRateLbl.attributedText = attributeString;
                }else{
                   oldRateLbl.hidden = true;
                }
                
            #pragma mark  NewRateView
                //newRateView View Generate

                UIView *newRateView =[[UIView alloc]init];
                
                if ([UIScreen mainScreen].bounds.size.width <= 320 ) {
                
                    newRateView.frame = CGRectMake(oldRateLbl.frame.origin.x-10, oldRateLbl.frame.origin.y + oldRateLbl.frame.size.height+5, oldRateLbl.frame.size.width+10, 20);

                }
                else
                {
                newRateView.frame = CGRectMake(oldRateLbl.frame.origin.x-20, oldRateLbl.frame.origin.y + oldRateLbl.frame.size.height+5, oldRateLbl.frame.size.width+20, 20);
                }
                newRateView.backgroundColor = [UIColor dOPDThemeColor];
                [HospitalDetailView addSubview:newRateView];
                
                UIView *newRView = [[UIView alloc]init]; //Contain white check amount on this view after that make center to parent view
                [newRateView addSubview:newRView];
                
                
    //            UIImageView *NewRateImg = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 12, 8)];
                //[newRateView addSubview:NewRateImg];
                UIImageView *NewRateImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 2, 12, 8)];
                [newRView addSubview:NewRateImg];
                NewRateImg.image = [UIImage imageNamed:@"whitecheck.png"];
                
                
          
                UILabel *NewRateLbl = [[UILabel alloc]initWithFrame:CGRectMake(NewRateImg.frame.origin.x + NewRateImg.frame.size.width+4, 0, 45, 14)];
             // UILabel *NewRateLbl = [[UILabel alloc]initWithFrame:CGRectMake(NewRateImg.frame.origin.x + NewRateImg.frame.size.width, 0, 45, 14)];
                //   NewRateLbl.text = @"INR 499";
    //            if (([[dataarr objectAtIndex:i][@"DoctorFee"] isKindOfClass:[NSNull class]]) || !([dataarr objectAtIndex:i][@"DoctorFee"]) || [dataarr objectAtIndex:i][@"DoctorFee"] == nil || [[dataarr objectAtIndex:i][@"DoctorFee"] length] == 0 ) {
                if (DocDisFee.length)
                {
                    NewRateLbl.hidden = false;
                    NewRateLbl.text= DocDisFee;
                   
                }else{
                    if (DocFee.length) {
                        NewRateLbl.hidden = false;
                       
                        NewRateLbl.text= DocFee;
                    }
                    else{
                        NewRateLbl.hidden = true;
                    }

                }
                
                NewRateLbl.font = [UIFont systemFontOfSize:11.0];
    //            NewRateLbl.textAlignment = NSTextAlignmentCenter;
                NewRateLbl.textColor = [UIColor whiteColor];
                NewRateLbl.numberOfLines = 0;
                NewRateLbl.lineBreakMode = NSLineBreakByWordWrapping;
                [NewRateLbl sizeToFit];
                
                
                //[newRateView addSubview: NewRateLbl];
                 [newRView addSubview:NewRateLbl];
                CGRect newrectformidview = newRView.frame;
                newrectformidview.origin.x=0;
                newrectformidview.origin.y=0;
                newrectformidview.size.width=NewRateLbl.frame.size.width + NewRateImg.frame.size.width;
                newrectformidview.size.height= NewRateLbl.frame.size.height;
                newRView.frame = newrectformidview;
               
//                NSLog(@"frame of newRview = %f",newRView.frame.origin.x);
//                NSLog(@"frame of newRview = %f",newRView.frame.origin.y);
//                NSLog(@"frame of newRview = %f",newRView.frame.size.width);
//                NSLog(@"frame of newRview = %f",newRView.frame.size.height);
                
                newRView.center = CGPointMake(newRateView.frame.size.width  / 2,
                                                 newRateView.frame.size.height / 2);
                
                
                
              //   newRView.center = newRateView.center;
                //Enquiry View Generate
                UIView *enquiryView =[[UIView alloc]initWithFrame:CGRectMake(HosNameLbl.frame.origin.x, HospSurgeryLbl.frame.origin.y + HospSurgeryLbl.frame.size.height+15, 70, 30)];
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
                
                if (dataarr.count >1 && i<dataarr.count-1) {
                    
                    UILabel *horizontalLine = [[UILabel alloc]init];
                    horizontalLine.frame = CGRectMake(0, AppointmentView.frame.origin.y+AppointmentView.frame.size.height +8, HospitalDetailView.frame.size.width, 1);
                    horizontalLine.backgroundColor = [UIColor dOPDTFBorderColor];
                    [HospitalDetailView addSubview:horizontalLine];
                    
                }
               
                CGRect ReframeHospitalView = HospitalDetailView.frame;
                ReframeHospitalView.size.height = enquiryView.frame.origin.y + enquiryView.frame.size.height+10;
                HospitalDetailView.frame = ReframeHospitalView;
                count = count + HospitalDetailView.frame.size.height;
    
            }
        
            CGRect newframe = DocInfoView.frame;
            newframe.size.height = HospitalDetailView.frame.origin.y + HospitalDetailView.frame.size.height+1;
            DocInfoView.frame = newframe;
            DocViewNewOriginmargin = DocViewNewOriginmargin + DocInfoView.frame.size.height+10;
        }else{
            CGRect newframe = DocInfoView.frame;
            newframe.size.height = DocNameView.frame.origin.y + DocNameView.frame.size.height+1;
            DocInfoView.frame = newframe;
            //DocViewNewOriginmargin = DocViewNewOriginmargin + DocInfoView.frame.size.height+10;

        }
  
    }
    
    
        CGRect newFrameContentView = self.ContentView.frame;
        newFrameContentView.size.height = DocInfoView.frame.size.height+DocInfoView.frame.origin.y+5;
        self.ContentView.frame = newFrameContentView;
        self.Scroller.contentSize = CGSizeMake(self.Scroller.frame.size.width, self.ContentView.frame.size.height+5) ;
    
}

-(void)OpenDoctorProfile:(UIButton*)sender{
    DocProfileVC *Docprofile = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_DocProfile"];
    Docprofile.DocFullData = [maindata objectAtIndex:sender.tag-1];
    [self.navigationController pushViewController:Docprofile animated:YES];
}


- (IBAction)backView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - API Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetDoctorListByDoctorName], keyRequestType,nil];
    //NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.firstName,fName,self.middleName,mName,self.lastName,lName,pgIndex,PageIndex,nil];
//    NSLog(@"DocData = %@",self.DocData);
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.DocData,@"DocData",pgIndex,PageIndex,nil];

//    NSLog(@"dataDic for GetDoctorListByDoctorName: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetDoctorListByDoctorName;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");

}

#pragma mark - API Calling

-(void)ApiCallingForHospital{
    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetDoctorListByDoctorName], keyRequestType,nil];
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.firstName,fName,self.middleName,mName,self.lastName,lName,pgIndex,PageIndex,nil];
    
//    NSLog(@"dataDic for GetDoctorListByDoctorName: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetDoctorListByDoctorName;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");

}

#pragma mark - API Calling

-(void)ApiCallingForProcedure{
    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetDoctorListByDoctorName], keyRequestType,nil];
  //  NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.firstName,fName,self.middleName,mName,self.lastName,lName,pgIndex,PageIndex,nil];
//    NSLog(@"DocData = %@",self.DocData);
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.DocData,@"DocData",pgIndex,PageIndex,nil];

//    NSLog(@"dataDic for GetDoctorListByDoctorName: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetDoctorListByDoctorName;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
    
}


#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
//    NSLog(@"docsearch Controller requestFinished");
}


#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response

{
//    NSLog(@"response = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    resposeCode =[[NSMutableArray alloc]init];
   resposeCode=[response objectForKey:@"Doctor List"];
    maindata =[response objectForKey:@"Doctor List"];
//    dataarr =  [resposeCode valueForKey:@"HospitalList"];
    
    
    if ([resposeCode count]==0 || (!resposeCode) || resposeCode==nil)  {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:AppName message:@"We are unalbe to fetch data. Please retry or search again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
         [self mainView];
    }
   
    
}

- (void) requestError
{
//    NSLog(@"Doctor list  error");
    [[AppDelegate MyappDelegate] hideIndicator];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
