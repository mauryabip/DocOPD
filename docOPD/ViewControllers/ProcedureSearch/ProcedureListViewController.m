//
//  ProcedureListViewController.m
//  docOPD
//
//  Created by Virinchi Software on 10/29/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "ProcedureListViewController.h"
#import "ProcedureListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "AllTimingsViewController.h"
#import "DocProfileVC.h"
#import "HospitalProfileVC.h"
#import "DocBookingViewController.h"
#import "DocEnquiryViewController.h"
#import "OpenEnquiryViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import <Google/Analytics.h>
#import "HDNotificationView.h"
@interface ProcedureListViewController ()

@end

@implementation ProcedureListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adviewbottomConst.constant=-500;
     [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak ProcedureListViewController *weakSelf = self;
//    NSLog(@"Show data for: %@",self.ShowDataFor);
//    NSLog(@"Pro id: %@ , Pro Name: %@",self.ProId, self.ProName);
    hosptalData = [[NSMutableArray alloc]init];
    pgIndex= 1;
    if ([self.ShowDataFor isEqualToString:@"pro"])
    {
        [Localytics tagEvent:@"Procedure Search List"];
        [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.000];
        self.lblTitleBar.text = [NSString stringWithFormat:@"Search Results: %@",self.ProName];
        [self.TableView addPullToRefreshWithActionHandler:^{
            [weakSelf ApiCalling];
        } position:SVPullToRefreshPositionBottom];
    }else if([self.ShowDataFor isEqualToString:@"doctor"]){
        [Localytics tagEvent:@"Doctor Search List"];
        [self performSelector:@selector(ApiCallingForDoc) withObject:nil afterDelay:0.000];
         self.lblTitleBar.text = [NSString stringWithFormat:@"Search Results: %@",self.ProName];
        [self.TableView addPullToRefreshWithActionHandler:^{
            [weakSelf ApiCallingForDoc];
        } position:SVPullToRefreshPositionBottom];
    }else if([self.ShowDataFor isEqualToString:@"Spec"]){
        [Localytics tagEvent:@"Specialties Search List"];
        [self performSelector:@selector(ApiCallingForSpec) withObject:nil afterDelay:0.000];
        self.lblTitleBar.text = [NSString stringWithFormat:@"Doctors For: %@",self.ProName];
        [self.TableView addPullToRefreshWithActionHandler:^{
            [weakSelf ApiCallingForSpec];
        } position:SVPullToRefreshPositionBottom];
    }

//    arrayForBool=[[NSMutableArray alloc]init];
//    for (int i=0; i<[hosptalData count]; i++) {
//        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
//    }
     self.BtnKnowMore.layer.cornerRadius = 4.0;
    if ([self.ShowDataFor isEqualToString:@"pro"] || [self.ShowDataFor isEqualToString:@"Spec"]) {
        self.ViewAd.hidden= false;
        self.LblAdTitle.text = self.ProName;
    }else{
//        self.ViewAd.hidden= true;
//        CGRect tableviewRect = self.TableView.frame;
//        tableviewRect.size.height = tableviewRect.size.height + self.ViewAd.frame.size.height;
//        self.TableView.frame = tableviewRect;
        [self HideAdView];
    }

  //  [self setupErrorview];
    

    [self.TableView setShowsPullToRefresh:YES];

}
-(void)pullrefresh:(NSString*)str{
    
}


-(void)setupErrorview{
    errorView = [[UIView alloc]init];
    errorView.frame  = CGRectMake(0, -84, [UIScreen mainScreen].bounds.size.width,84);
    [self.view addSubview:errorView];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, (errorView.frame.size.height-20)/2, 30, 30)];
    icon.image = [UIImage imageNamed:@"round-logo-icon.png"];
    [errorView addSubview:icon];
}

-(void)viewWillAppear:(BOOL)animated{
    NSString *name = [NSString stringWithFormat:@"Doctor-Search"];
    [self.navigationController setNavigationBarHidden:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"SurgeryDocScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"SurgeryDocScreen"];
}

- (IBAction)GoToBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - API Calling

-(void)ApiCalling{
    pgIndex>1?:[[AppDelegate MyappDelegate] showIndicator];
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetProcedureListByProcedureId], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.ProId,ProcedureID,[NSString stringWithFormat:@"%ld",(long)pgIndex],PageIndex,nil];
    
//    NSLog(@"dataDic for GetProcedurelistbyid: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetProcedureListByProcedureId;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling for Procedure list");
    
    
}

-(void)ApiCallingForDoc{
     pgIndex>1?:[[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetDoctorListByDoctorName], keyRequestType,nil];
    //  NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.firstName,fName,self.middleName,mName,self.lastName,lName,pgIndex,PageIndex,nil];
//    NSLog(@"DocData = %@",self.DocData);
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.DocData,@"DocData",[NSString stringWithFormat:@"%ld",(long)pgIndex],PageIndex,nil];
    
//    NSLog(@"dataDic for GetDoctorListByDoctorName: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetDoctorListByDoctorName;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling for Doctor List");
   
}

-(void)ApiCallingForSpec{
     pgIndex>1?:[[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetDoctorBySpecialist], keyRequestType,nil];
    //  NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.firstName,fName,self.middleName,mName,self.lastName,lName,pgIndex,PageIndex,nil];
//    NSLog(@"DocData = %@",self.DocData);
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.specID,@"SpecId",[NSString stringWithFormat:@"%ld",(long)pgIndex],PageIndex,nil];
    
//    NSLog(@"dataDic for GetDoctorBySpecialist: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetDoctorBySpecialist;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling for Doctor List");
    
}



#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    if (currentRequestType == kGetDoctorListByDoctorName) {
        [self performSelector:@selector(resultForDoc:) withObject:responseData afterDelay:.000];
    }else if(currentRequestType == kGetProcedureListByProcedureId){
        [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
    }else if(currentRequestType == kGetDoctorBySpecialist){
        [self performSelector:@selector(resultForDocSpec:) withObject:responseData afterDelay:.000];
    }
//    NSLog(@"procedure list Controller requestFinished");
}


#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response
{
//    NSLog(@"response = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    
    [self.TableView.pullToRefreshView stopAnimating];
    NSMutableArray *hospitalTempData = [[NSMutableArray alloc]init];
    hospitalTempData = [response objectForKey:@"ProcedureList"];
//    hosptalData = [response objectForKey:@"ProcedureList"];
     if ([[response objectForKey:@"Status"]integerValue]==1)
     {
        if([hospitalTempData count]!=0){
            for (NSMutableDictionary *temp in hospitalTempData) {
                NSMutableArray *HosListCount = [temp valueForKey:@"HospitalList"];
                if (![HosListCount isKindOfClass:[NSNull class]]) {
                    [hosptalData addObject:temp];
                }
                //[hosptalData addObject:temp];
            }
            [self.TableView reloadData];
            self.LblAdPrice.text =[response objectForKey:@"Quotation"];
//            self.LblAdTitle.text =[response objectForKey:@"ProcedureName"];
            [self.LblAdPrice setAdjustsFontSizeToFitWidth:YES];
            self.LblAdPrice.numberOfLines =1;
            if (![self.LblAdPrice.text isEqualToString:@"0"]) {
               self.LblAdPrice.text = [self thousandSep:[response objectForKey:@"Quotation"]];
                //[self HideAdView];
                //[self ViewSlideup];
                pgIndex>1?:[self ViewSlideup];
            }
               pgIndex++;
            if (hospitalTempData.count < 20) {
                [self.TableView setShowsPullToRefresh:NO];
            }
        }else{
        
            [self notFindDataAlert];
        }
     }else  if ([[response objectForKey:@"Status"]integerValue]==7){
         if (pgIndex==1) {
             [self notFindDataAlert];
         }else [self.TableView setShowsPullToRefresh:NO];
     }else{
         [self notFindDataAlert];
     }
}

#pragma mark - result methods for Doc service
- (void) resultForDoc:(NSDictionary *)response
{
//    NSLog(@"response = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    [self.TableView.pullToRefreshView stopAnimating];
    NSMutableArray *hospitalTempData = [[NSMutableArray alloc]init];
    hospitalTempData = [response objectForKey:@"Doctor List"];
    if ([[response objectForKey:@"Status"]integerValue]==1)
    {
        if ([hospitalTempData count]==0 || (!hospitalTempData) || hospitalTempData==nil)  {
          [self notFindDataAlert];
        }else
        {
            pgIndex++;
//            NSLog(@"Array not nil");
            for (NSMutableDictionary *temp in hospitalTempData)
            {
                NSMutableArray *HosListCount = [temp valueForKey:@"HospitalList"];
                if (![HosListCount isKindOfClass:[NSNull class]]) {
                    [hosptalData addObject:temp];
                }
//                [hosptalData addObject:temp];
            }
            [self.TableView reloadData];
            if (hospitalTempData.count < 20) {
                [self.TableView setShowsPullToRefresh:NO];
            }
        }
    }else if ([[response objectForKey:@"Status"]integerValue]==7)
    {
        if (pgIndex==1) {
            [self notFindDataAlert];
        }else [self.TableView setShowsPullToRefresh:NO];
    }else
    {
        [self notFindDataAlert];
    }
}


#pragma mark - result methods for Doc service
- (void) resultForDocSpec:(NSDictionary *)response

{
//    NSLog(@"response = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    [self.TableView.pullToRefreshView stopAnimating];
    NSMutableArray *hospitalTempData = [[NSMutableArray alloc]init];
    hospitalTempData = [response objectForKey:@"DoctorList"];

//    hosptalData=[response objectForKey:@"DoctorList"];
    if ([[response objectForKey:@"Status"]integerValue]==1)
    {
        if ([hospitalTempData count]==0 || (!hospitalTempData) || hospitalTempData==nil)  {
            
             [self notFindDataAlert];
        }
        else{
//            NSLog(@"Array not nil");
            for (NSMutableDictionary *temp in hospitalTempData) {
                NSMutableArray *HosListCount = [temp valueForKey:@"HospitalList"];
                if (![HosListCount isKindOfClass:[NSNull class]]) {
                    [hosptalData addObject:temp];
                }
//                [hosptalData addObject:temp];
            }
            self.LblAdPrice.text =[response objectForKey:@"Quotation"];
           
            self.LblAdPrice.numberOfLines =1;
            self.LblAdPrice.adjustsFontSizeToFitWidth = YES;
            [self.LblAdPrice setAdjustsFontSizeToFitWidth:YES];
         
            if (![self.LblAdPrice.text isEqualToString:@"0"]) {
               // [self HideAdView];
                pgIndex>1?:[self ViewSlideup];
                 self.LblAdTitle.text =[response objectForKey:@"ProcedureName"]?[response objectForKey:@"ProcedureName"]:@"";
               self.LblAdPrice.text = [self thousandSep:[response objectForKey:@"Quotation"]];
              
            }
            [self.TableView reloadData];
             pgIndex++;
            if (hospitalTempData.count < 20) {
                [self.TableView setShowsPullToRefresh:NO];
            }
        }
    }else if ([[response objectForKey:@"Status"]integerValue]==7){
        if (pgIndex==1) {
            [self notFindDataAlert];
        }else [self.TableView setShowsPullToRefresh:NO];
    }else
    {
        [self notFindDataAlert];
    }
}


- (void) requestError
{
//    NSLog(@"hospital ViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
    [self ViewSlideDown:@"Something went wrong"];
}


#pragma mark - ViewSlideup

-(void)ViewSlideup{
    [UIView animateWithDuration:1.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.adviewbottomConst.constant=0;
        [self.view layoutIfNeeded];
       // self.ViewAd.frame  = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-115, [UIScreen mainScreen].bounds.size.width,115);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didPressAdEnquiryBtn:)];
        tap.numberOfTapsRequired = 1.0;
        //[self.ViewAd addGestureRecognizer:tap];
    } completion:^(BOOL finished) {
        
       
        CGRect tableviewRect = self.TableView.frame;
        tableviewRect.size.height = tableviewRect.size.height - self.ViewAd.frame.size.height;
        self.TableView.frame = tableviewRect;
        
    }];
}



#pragma mark - No Network Slider

-(void)ViewSlideDown:(NSString*)Message{
/*    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        errorView.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,84);
        errorView.backgroundColor = [UIColor dOPDThemeColor];
        UILabel *msg = [[UILabel alloc]initWithFrame:CGRectMake(40, (errorView.frame.size.height-30)/2, errorView.frame.size.width-40, 40)];
        msg.text = Message;
        //        msg.textAlignment = NSTextAlignmentCenter;
        msg.numberOfLines =2;
        msg.tag=99;
        //        msg.lineBreakMode = NSLineBreakByWordWrapping;
        //        [msg sizeToFit];
        msg.textColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        msg.font = [UIFont systemFontOfSize:14.0];
        [errorView addSubview:msg];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 delay:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            errorView.frame  = CGRectMake(0, -84, [UIScreen mainScreen].bounds.size.width,84);
            
        } completion:^(BOOL finished) {
            for (UIView *subview in [errorView subviews]) {
                if (subview.tag ==99) {
                    [subview removeFromSuperview];
                }
            }
            
        }];
        
    }];*/
    
    [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"icon.png"]
                                                title:AppName
                                              message:Message
                                           isAutoHide:YES
                                              onTouch:^{
                                                  
                                                  /// On touch handle. You can hide notification view or do something
                                                  [HDNotificationView hideNotificationViewOnComplete:nil];
                                              }];
}


#pragma mark - Tableview Delegate and datasource

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"%@ %@ %@",[hosptalData objectAtIndex:section][@"FirstName"],[hosptalData objectAtIndex:section][@"MiddleName"],[hosptalData objectAtIndex:section][@"LastName"]];
//}

//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"numberOfSectionsInTableView");
    // Return the number of sections.
   // return [hosptalData count];
     return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
     return [hosptalData count];
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
   // NSLog(@"willDisplayCell - %ld",(long)indexPath.section);
    if(indexPath.section % 2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:247.0/255.0 blue:248.0/255.0 alpha:1.0];

        
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
  
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"Cell for row at index path");
   // NSLog(@"cell for row index path - %ld",(long)indexPath.row);
    
    
    ProcedureListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    

    // Configure the cell...
//    NSString *sectionTitle = [hospitalSectionTitles objectAtIndex:indexPath.section];
//    NSArray *sectionHospitals = [hospital objectForKey:sectionTitle];
//    NSString *hospitalName = [sectionHospitals objectAtIndex:indexPath.row];
    //cell.textLabel.text = hospitalName;


    NSMutableDictionary *hosDataValueAtIndex = [hosptalData objectAtIndex:indexPath.row];
    NSMutableArray *HosListCount = [hosDataValueAtIndex valueForKey:@"HospitalList"];
    HospitalDic= [[NSMutableDictionary alloc]init];
    
   // NSString*midname = [hosptalData objectAtIndex:indexPath.section][@"MiddleName"];
    NSString*midname = [hosDataValueAtIndex valueForKey:@"MiddleName"];
    NSString *fullname;
//    if ([midname isEqualToString:@""] || ![midname length] || [midname isEqualToString:@" "]) {
//        fullname =[NSString stringWithFormat:@"%@ %@",[hosptalData objectAtIndex:indexPath.section][@"FirstName"],[hosptalData objectAtIndex:indexPath.section][@"LastName"]];
//    }
//    else{
//        fullname =[NSString stringWithFormat:@"%@ %@ %@",[hosptalData objectAtIndex:indexPath.section][@"FirstName"],[hosptalData objectAtIndex:indexPath.section][@"MiddleName"],[hosptalData objectAtIndex:indexPath.section][@"LastName"]];
//    }
    
    if ([midname isEqualToString:@""] || ![midname length] || [midname isEqualToString:@" "]) {
        fullname =[NSString stringWithFormat:@"%@ %@",[hosDataValueAtIndex valueForKey:@"FirstName"],[hosDataValueAtIndex valueForKey:@"LastName"]];
    }
    else{
        fullname =[NSString stringWithFormat:@"%@ %@ %@",[hosDataValueAtIndex valueForKey:@"FirstName"],[hosDataValueAtIndex valueForKey:@"MiddleName"],[hosDataValueAtIndex valueForKey:@"LastName"]];
    }
    
    
    [cell.LblDocName setText:fullname];

   // NSString*docurl =[hosptalData objectAtIndex:indexPath.section][@"DocPicURL"];
    NSString*docurl =[hosDataValueAtIndex valueForKey:@"DocPicURL"];
    [cell.ImgDoc sd_setImageWithURL:[NSURL URLWithString:docurl] placeholderImage:[UIImage imageNamed:@"doctor-96.png"]];
    cell.ImgDoc.layer.cornerRadius = cell.ImgDoc.layer.frame.size.width/2;
    //cell.ImgDoc.layer.masksToBounds= YES;
    cell.ImgDoc.contentMode = UIViewContentModeScaleAspectFill;
    cell.ImgDoc.clipsToBounds = YES;
    
    NSString*caption;
    if ([[hosDataValueAtIndex valueForKey:@"DoctorDescription"] isKindOfClass:[NSNull class]]) {
        caption = @"";
    }else caption=[hosDataValueAtIndex valueForKey:@"DoctorDescription"] ;
    
    
    
    [self displayImage:cell.ImgDoc withImage:cell.ImgDoc.image ImageCaption:caption];

    
    
    
    
    NSString *DocExpertiseString =[NSString stringWithFormat:@"%@",[hosDataValueAtIndex valueForKey:@"Title"]];
    [cell.LblDocSpec setText:DocExpertiseString];
    [self TextColorForLable:cell.LblDocSpec];
    
    NSString *DocDegString =[NSString stringWithFormat:@"%@",[hosDataValueAtIndex valueForKey:@"Qualification"]];
    [cell.LblDocDegree setText:DocDegString];
    [self TextColorForLable:cell.LblDocDegree];

    
    NSString *DoctorRevString =[NSString stringWithFormat:@"%@",[hosDataValueAtIndex valueForKey:@"TotalReview"]];
    if (DoctorRevString.length)
    {
        if (DoctorRevString.integerValue >1) {
            DoctorRevString = [NSString stringWithFormat:@"%@ Reviews",DoctorRevString];
        }else{
            DoctorRevString = [NSString stringWithFormat:@"%@ Review",DoctorRevString];
        }
    }
    else
    {
        DoctorRevString = @"0 Review";
    }
    
    [cell.LblDocRev setText:DoctorRevString];
    [self TextColorForLable:cell.LblDocRev];
    
    cell.viewDocImage.layer.cornerRadius = cell.viewDocImage.layer.frame.size.width/2;
    cell.viewDocImage.backgroundColor = [UIColor colorWithRed:201.0/255.0 green:202.0/255.0 blue:203.0/255.0 alpha:1.0];
    cell.ImgHosImgBorder.layer.borderColor = [UIColor dOPDTFBorderColor].CGColor;
    cell.ImgHosImgBorder.layer.borderWidth = 2.0;
    

    [cell.BtnAllTimings setTitle:@"ALL TIMINGS" forState:UIControlStateNormal];
   // [cell.BtnAllTimings setTitleColor:[UIColor dOPDThemeColor] forState:UIControlStateNormal];
   // NSString *btnTag = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section+1,(long)indexPath.row];
    NSString *btnTag = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.row+1,(long)indexPath.row];
   
    //  NSLog(@"Btn Tag: %@",btnTag);
    cell.BtnAllTimings.tag = btnTag.integerValue;
    [cell.BtnAllTimings addTarget:self action:@selector(ShowAllTimings:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.BtnHospitalProfile.tag =btnTag.integerValue;
    [cell.BtnHospitalProfile addTarget:self action:@selector(GoToHospitalProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *hospitalName;
    if (HosListCount.count)
    {
       // HospitalDic = [HosListCount objectAtIndex:indexPath.row];
        HospitalDic = [HosListCount objectAtIndex:0];
        hospitalName = [HospitalDic valueForKey:@"HospitalName"];
  
        cell.LblHospitalName.text = hospitalName;
        cell.LblHospitalAddress.text =[NSString stringWithFormat:@"%@, %@",[HospitalDic valueForKey:@"HospitalAddressline1"],[HospitalDic valueForKey:@"HospitalAddressline2"]];

        [self TextColorForLable:cell.LblHospitalAddress];
        cell.HosType.text =[HospitalDic valueForKey:@"HospitalType"];
        [self TextColorForLable:cell.HosType];
        
        NSString *DocFee=[HospitalDic valueForKey:@"DoctorFee"];
        NSString *DocDisFee=[HospitalDic valueForKey:@"DoctorDiscountedFee"];
       int docFee = [DocFee intValue];
       int docDisFee = [DocDisFee intValue];
        NSString *DocafterDisFee=[NSString stringWithFormat:@"%d",(docFee-docDisFee)];
        
        if (DocDisFee.length)
        {
            if ((!DocFee.length))
            {
                cell.LblOldRate.text = NA;
                cell.LblOldRate.hidden = true;
                cell.viewOldRate.hidden = true;
            }else{
                cell.LblOldRate.hidden = false;
                cell.viewOldRate.hidden = false;
                cell.LblOldRate.text = [NSString stringWithFormat:@"\u20B9 %@",DocFee];
                
                cell.LblNewRate.hidden = false;
                cell.LblNewRate.text= [NSString stringWithFormat:@"\u20B9 %@",DocafterDisFee];;
            }
            
            cell.LblOldRate.font = [UIFont systemFontOfSize:12.0];
            cell.LblOldRate.textColor = [UIColor colorWithRed:92.0/255.0 green:91.0/255.0 blue:91.0/255.0 alpha:1.0];
          
            
            NSDictionary* attributes = @{
                                         NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle],NSStrikethroughColorAttributeName: [UIColor dOPDTextFontColor]
                                         };
            
            NSAttributedString* attributeString = [[NSAttributedString alloc] initWithString:cell.LblOldRate.text attributes:attributes];
            cell.LblOldRate.attributedText = attributeString;
        }else
        {
            cell.LblOldRate.hidden = true;
            cell.viewOldRate.hidden = true;
            
            if (DocFee.length) {
                cell.LblNewRate.hidden = false;
                cell.LblNewRate.text= [NSString stringWithFormat:@"\u20B9 %@",DocFee];
            }
            else{
                cell.LblNewRate.hidden = true;
            }
        }
        
       // [self SetButtonBorder:cell.viewEnquiry];
         cell.viewEnquiry.layer.cornerRadius = 3.0f;
        //[self SetButtonBorder:cell.ViewBookAppointment];
       // cell.LblEnquiry.textColor= [UIColor dOPDThemeColor];
        cell.ViewBookAppointment.backgroundColor = [UIColor dOPDThemeColor];
        cell.ViewBookAppointment.layer.cornerRadius = 3.0f;
        cell.LblBookAppointment.textColor= [UIColor whiteColor];
        cell.LblNewRate.textColor = [UIColor dOPDTextFontColor];
        
//        [cell.ImgHospital sd_setImageWithURL:[NSURL URLWithString:[HospitalDic valueForKey:@"HosPicURL"]] placeholderImage:[UIImage imageNamed:@"def-hospital.png"]];
//        [self displayImage:cell.ImgHospital withImage:cell.ImgHospital.image];
//        cell.ImgHospital.layer.cornerRadius = cell.ImgHospital.frame.size.width/2;
//        cell.ImgHospital.layer.masksToBounds = true;
    
        NSString *specialities = [NSString stringWithFormat:@"%@",[HospitalDic valueForKey:@"HospitalCity"]]; //specialities change to hospical city
        if (!specialities.length || [specialities isEqualToString:@"<null>"] || [specialities isKindOfClass:[NSNull class]]) {
             cell.LblHospitalSpec.text = NA;
        }
        else{
           cell.LblHospitalSpec.text = specialities;
           
        }
        [self TextColorForLable:cell.LblHospitalSpec];

        NSString *DocAvail= [HospitalDic valueForKey:@"Availibity"];
        if ([DocAvail isEqualToString:@"Close Today"]) {
            cell.LblAvailability.textColor = [UIColor colorWithRed:205.0/255.0 green:90.0/255.0 blue:59.0/255.0 alpha:1.0];
//            cell.BtnAllTimings.hidden = true;
        }else if ([DocAvail isEqualToString:@"Available Today"] ||[DocAvail isEqualToString:@"Available Now"] ) {
//            cell.BtnAllTimings.hidden = false;
             cell.LblAvailability.textColor = [UIColor dOPDThemeColor];
        }
        cell.LblAvailability.text = DocAvail;
        
            
//        if(indexPath.row % 2 == 0)
//            cell.backgroundColor = [UIColor whiteColor];
//        else
//            cell.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:247.0/255.0 blue:248.0/255.0 alpha:1.0];
        

    }//(HosListCount.count) end
    if (HosListCount.count>1) {
        cell.BtnViewMore.hidden = false;
    }else{
        cell.BtnViewMore.hidden = true;
    }
    return cell;
}

-(void)TextColorForLable:(UILabel*)label{
    label.textColor = [UIColor dOPDTextFontColor];
}


-(void)SetButtonBorder:(UIView *)View{
    View.backgroundColor = [UIColor whiteColor];
    View.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    View.layer.borderWidth = 1.0;
    View.layer.cornerRadius= 2.0;
}


-(void)GetAllTiming: (UIButton*)sender{
//    NSLog(@"Sender Id is: %ld",(long)sender.tag);
}



#pragma mark- Doctor Show All Timings
/*================================================================================================
                            OPEN Doctor Show All Timings
 ================================================================================================== */

- (IBAction)ShowAllTimings:(id)sender {
    [Localytics tagEvent:@"SurgeryDocAllTimingCLick"];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView
                              ];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {

//        NSLog(@"indexPath not nil");
//        NSLog(@"indexpath: Section = %ld, Row = %ld",(long)indexPath.section,(long)indexPath.row);
        AllTimingsViewController *alltime = [self.storyboard instantiateViewControllerWithIdentifier:@"AllTimings"];
       
        NSMutableDictionary *hosDataValueAtIndex = [hosptalData objectAtIndex:indexPath.row];
        NSMutableArray *HosListCount = [hosDataValueAtIndex valueForKey:@"HospitalList"];
        
        NSMutableDictionary *AvailDic = [[NSMutableDictionary alloc]init];
        [AvailDic setObject:[HosListCount objectAtIndex:0][@"DocSunday"] forKey:@"1"];
        [AvailDic setObject:[HosListCount objectAtIndex:0][@"DocMonday"] forKey:@"2"];
        [AvailDic setObject:[HosListCount objectAtIndex:0][@"DocTuesday"] forKey:@"3"];
        [AvailDic setObject:[HosListCount objectAtIndex:0][@"DocWednesday"] forKey:@"4"];
        [AvailDic setObject:[HosListCount objectAtIndex:0][@"DocThursday"] forKey:@"5"];
        [AvailDic setObject:[HosListCount objectAtIndex:0][@"DocFriday"] forKey:@"6"];
        [AvailDic setObject:[HosListCount objectAtIndex:0][@"DocSaturday"] forKey:@"7"];
        alltime.DataFor = [HosListCount objectAtIndex:0][@"HospitalName"];
        alltime.AvailDic = AvailDic;
       
        NSString*midname = [hosptalData objectAtIndex:indexPath.row][@"MiddleName"];
        NSString *fullname;
        if ([midname isEqualToString:@""] || ![midname length] || [midname isEqualToString:@" "]) {
            fullname =[NSString stringWithFormat:@"%@ %@",[hosptalData objectAtIndex:indexPath.row][@"FirstName"],[hosptalData objectAtIndex:indexPath.row][@"LastName"]];
        }
        else{
            fullname =[NSString stringWithFormat:@"%@ %@ %@",[hosptalData objectAtIndex:indexPath.row][@"FirstName"],[hosptalData objectAtIndex:indexPath.row][@"MiddleName"],[hosptalData objectAtIndex:indexPath.row][@"LastName"]];
        }

        
        alltime.DataForDoctor =fullname;
        [self presentViewController:alltime animated:YES completion:nil];
    }else{
//        NSLog(@"indexPath nil");
    }
}


- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image ImageCaption:(NSString*)caption  {
    [Localytics tagEvent:@"SurgeryDocImageClick"];
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
 //   [imageView setupImageViewer];
    imageView.clipsToBounds = YES;
    [imageView setupImageViewerWithText:caption];

}


#pragma mark- OPEN Doctor Profile
/*================================================================================================
                                        OPEN Doctor Profile
 ================================================================================================== */

- (IBAction)didPressDocDetailBtn:(UIButton*)sender {
    [Localytics tagEvent:@"SurgeryDocDocProfileClick"];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        DocProfileVC *DocProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_DocProfile"];
        DocProfile.DocFullData = [hosptalData objectAtIndex:indexPath.row];
//        NSLog(@"data push in doc profile %@", [hosptalData objectAtIndex:indexPath.row]);
        if ([self.ShowDataFor isEqualToString:@"pro"])
        {
            DocProfile.procIDForQuotation = self.ProId;
        }else if([self.ShowDataFor isEqualToString:@"Spec"]){
            DocProfile.specIDForQuotation = self.specID;
        }
        [self.navigationController pushViewController:DocProfile animated:YES];
        
    }
}

- (IBAction)didPressViewMore:(UIButton*)sender {
    [Localytics tagEvent:@"SurgeryDocDocProfileClick"];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        DocProfileVC *DocProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_DocProfile"];
        DocProfile.DocFullData = [hosptalData objectAtIndex:indexPath.row];
//        NSLog(@"data push in doc profile %@", [hosptalData objectAtIndex:indexPath.row]);
        [self.navigationController pushViewController:DocProfile animated:YES];
        
    }
}

/*================================================================================================
                    This is not using now
================================================================================================== */


-(void)GoToDoctorProfile:(UIButton*)sender{
      [Localytics tagEvent:@"SurgeryDocDocProfileClick"];
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
//    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    DocProfileVC *DocProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_DocProfile"];
    DocProfile.DocFullData = [hosptalData objectAtIndex:sender.tag-1];
//    NSLog(@"data push in doc profile %@", [hosptalData objectAtIndex:sender.tag-1]);
//    DocProfile.docID = [hosptalData objectAtIndex:indexPath.section][@"DoctorId"];
 
    
    if ([self.ShowDataFor isEqualToString:@"pro"])
    {
        DocProfile.procIDForQuotation = self.ProId;
    }else if([self.ShowDataFor isEqualToString:@"Spec"]){
        DocProfile.specIDForQuotation = self.specID;
    }
    [self.navigationController pushViewController:DocProfile animated:YES];
    
}

#pragma mark- OPEN Hospital Profile
/*================================================================================================
                                        OPEN Hospital Profile
 ================================================================================================== */


-(void)GoToHospitalProfile:(UIButton*)sender{
      [Localytics tagEvent:@"SurgeryDocHospitalClick"];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
      NSMutableDictionary *hosDataValueAtIndex = [hosptalData objectAtIndex:indexPath.row];
        NSMutableArray *HosListCount = [hosDataValueAtIndex valueForKey:@"HospitalList"];
    
        HospitalProfileVC *HosProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_HospitalProfile"];
        HosProfile.hosData = [HosListCount objectAtIndex:0];
        HosProfile.hosname = [HosListCount objectAtIndex:0][@"HospitalName"];
        [self.navigationController pushViewController:HosProfile animated:YES];
        
    
    }else{
//        NSLog(@"indexPath nil");
    }
}

#pragma mark- Alertview delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark- Book Appointment

/*================================================================================================
                                OPEN Book Appointment
 ================================================================================================== */

- (IBAction)didPressBookAppointment:(id)sender {
      [Localytics tagEvent:@"SurgeryDocDocBookingClick"];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    
    NSMutableDictionary *hosDataValueAtIndex = [hosptalData objectAtIndex:indexPath.row];
    NSMutableArray *HosListCount = [hosDataValueAtIndex valueForKey:@"HospitalList"];
    
    
    if (indexPath != nil)
    {
        
        DocBookingViewController *DocBook = [self.storyboard instantiateViewControllerWithIdentifier:@"DocBooking"];
        DocBook.comeFrom = @"search";
        NSString*Docimg =[hosDataValueAtIndex valueForKey:@"DocPicURL"];
        
        
        NSString*midname = [hosptalData objectAtIndex:indexPath.row][@"MiddleName"];
        NSString *fullname;
        if ([midname isEqualToString:@""] || ![midname length] || [midname isEqualToString:@" "]) {
            fullname =[NSString stringWithFormat:@"%@ %@",[hosptalData objectAtIndex:indexPath.row][@"FirstName"],[hosptalData objectAtIndex:indexPath.row][@"LastName"]];
        }
        else{
            fullname =[NSString stringWithFormat:@"%@ %@ %@",[hosptalData objectAtIndex:indexPath.row][@"FirstName"],[hosptalData objectAtIndex:indexPath.row][@"MiddleName"],[hosptalData objectAtIndex:indexPath.row][@"LastName"]];
        }
        
        
        [DocBook DoctorDataName:fullname DocSpecility:[hosptalData objectAtIndex:indexPath.row][@"Title"] DoctorDegree:[hosptalData objectAtIndex:indexPath.row][@"Qualification"] DocImg:Docimg];
        
        NSString*hosname = [[HosListCount objectAtIndex:0]valueForKey:@"HospitalName"];
        NSString*hostype = [[HosListCount objectAtIndex:0]valueForKey:@"HospitalType"];

        NSString*hosAdd = [NSString stringWithFormat:@"%@",[[HosListCount objectAtIndex:0] valueForKey:@"HospitalAddressline2"]];
        
        hosAdd =[[HosListCount objectAtIndex:0] valueForKey:@"HospitalAddressline2"];
        NSString*hosimg =[[HosListCount objectAtIndex:0] valueForKey:@"HosPicURL"];
        DocBook.docid =[[hosptalData objectAtIndex:indexPath.row] valueForKey:@"DoctorId"];
        DocBook.HospitalData = [HosListCount objectAtIndex:0];
        [DocBook HospitalDataName:hosname HospitalType:hostype HospitalAddress:hosAdd HospitalImg:hosimg];
        [self.navigationController pushViewController:DocBook animated:YES];
        
    }else{
    }

}



#pragma mark- OPEN Book Enquiry

/*================================================================================================
                                    OPEN Book Enquiry
 ================================================================================================== */


- (IBAction)didPressEnquiryButton:(id)sender {
      [Localytics tagEvent:@"SurgeryDocDocEnquiryClick"];
    
    DocEnquiryViewController *DocEnq = [self.storyboard instantiateViewControllerWithIdentifier:@"DocEnquiry"];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    DocEnq.comeFrom = @"search";
    NSMutableDictionary *hosDataValueAtIndex = [hosptalData objectAtIndex:indexPath.row];
    NSMutableArray *HosListCount = [hosDataValueAtIndex valueForKey:@"HospitalList"];
    
    if (indexPath != nil)
    {
    
            NSMutableDictionary *DocData = [[NSMutableDictionary alloc]init];
            [DocData setObject:[hosDataValueAtIndex valueForKey:@"DocPicURL"] forKey:@"DocPicURL"];
            [DocData setObject:[hosDataValueAtIndex valueForKey:@"DoctorId"] forKey:@"DoctorId"];
        
        NSString*midname = [hosDataValueAtIndex valueForKey:@"MiddleName"];
        NSString *fullname;
        if ([midname isEqualToString:@""] || ![midname length] || [midname isEqualToString:@" "]) {
            fullname =[NSString stringWithFormat:@"%@ %@",[hosDataValueAtIndex valueForKey:@"FirstName"],[hosDataValueAtIndex valueForKey:@"LastName"]];
        }
        else{
            fullname =[NSString stringWithFormat:@"%@ %@ %@",[hosDataValueAtIndex valueForKey:@"FirstName"],[hosDataValueAtIndex valueForKey:@"MiddleName"],[hosDataValueAtIndex valueForKey:@"LastName"]];
        }
        
        
            [DocData setObject:fullname forKey:@"DocName"];
            [DocData setObject:[hosDataValueAtIndex valueForKey:@"Title"] forKey:@"DocSpec"];
            [DocData setObject:[hosDataValueAtIndex valueForKey:@"Qualification"] forKey:@"DocDegree"];
            DocEnq.hospitalDic = [HosListCount objectAtIndex:0];
            DocEnq.doctorDic = DocData;
      
        [self.navigationController pushViewController:DocEnq animated:YES];
        
        
        /*
        
        // NSMutableDictionary *chosDataValue = [HospitalListArray objectAtIndex:sender.tag-1];
        //        NSMutableArray *HosListCount = [hosDataValueAtIndex valueForKey:@"HospitalList"];
        
        DocBookingViewController *DocBook = [self.storyboard instantiateViewControllerWithIdentifier:@"DocBooking"];
        DocBook.comeFrom = @"search";
        NSString*Docimg =[hosDataValueAtIndex valueForKey:@"DocPicURL"];
        
        
        
        
        
        [DocBook DoctorDataName:fullname DocSpecility:[hosptalData objectAtIndex:indexPath.section][@"Title"] DoctorDegree:[hosptalData objectAtIndex:indexPath.section][@"Qualification"] DocImg:Docimg];
        
        NSString*hosname = [[HosListCount objectAtIndex:indexPath.row]valueForKey:@"HospitalName"];
        NSString*hostype = [[HosListCount objectAtIndex:indexPath.row]valueForKey:@"HospitalType"];
        //   NSString*hosAdd = [NSString stringWithFormat:@"%@",[hosData valueForKey:@"HospitalAddressLine1"]];
        
        //         NSString*hosAdd = [NSString stringWithFormat:@"%@, %@",[hosData valueForKey:@"HospitalAddressLine1"],[hosData valueForKey:@"HospitalAddressLine2"]];
        NSString*hosAdd = [NSString stringWithFormat:@"%@, %@, %@",[[HosListCount objectAtIndex:indexPath.row] valueForKey:@"HospitalAddressline1"],[[HosListCount objectAtIndex:indexPath.row] valueForKey:@"HospitalAddressline2"],[[HosListCount objectAtIndex:indexPath.row] valueForKey:@"HospitalCity"]];
        NSLog(@"hosadd in doc profile: %@",hosAdd);
        NSString*hosimg =[[HosListCount objectAtIndex:indexPath.row] valueForKey:@"HosPicURL"];
        DocBook.docid =[[hosptalData objectAtIndex:indexPath.section] valueForKey:@"DoctorId"];
        DocBook.HospitalData = [HosListCount objectAtIndex:indexPath.row];
        [DocBook HospitalDataName:hosname HospitalType:hostype HospitalAddress:hosAdd HospitalImg:hosimg];
        [self.navigationController pushViewController:DocBook animated:YES];*/
        
    }else{
//        NSLog(@"indexPath nil");
    }
    
}


#pragma mark - Table header gesture tapped



- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    
    if (tappedSection!=gestureRecognizer.view.tag) {
        [arrayForBool replaceObjectAtIndex:tappedSection withObject:[NSNumber numberWithBool:NO]];
        [self.TableView reloadSections:[NSIndexSet indexSetWithIndex:tappedSection] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    tappedSection= gestureRecognizer.view.tag;
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[hosptalData count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.TableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}



#pragma mark- Hide AD View

/*================================================================================================
                                    Hide AD View
 ================================================================================================== */


-(void)HideAdView{
    self.ViewAd.hidden= true;
    CGRect tableviewRect = self.TableView.frame;
   // tableviewRect.size.height = tableviewRect.size.height + self.ViewAd.frame.size.height;
    self.TableView.frame = tableviewRect;
}
- (IBAction)didPressAdEnquiryBtn:(id)sender {
      [Localytics tagEvent:@"SurgeryDocOpenEnquiryClick"];
    OpenEnquiryViewController *OEVC= [self.storyboard instantiateViewControllerWithIdentifier:@"OpenEnquiryViewController"];
    OEVC.comeFrom = self.ShowDataFor;
    OEVC.specID = self.specID;
    OEVC.procedureID=self.ProId;
    OEVC.titleName = self.ProName;
    [self presentViewController:OEVC animated:YES completion:nil];
}


#pragma mark- Not Find Data Alert

/*================================================================================================
                                   Not Find Data Alert
 ================================================================================================== */


-(void)notFindDataAlert{
    UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:AppName message:[NSString stringWithFormat:@"Sorry!!! We didnot find the detail for '%@'",self.ProName ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark- Number Formatter

-(NSString *)thousandSep:(NSString*)price{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    double quotePrice = price.doubleValue;
    NSString *Price = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:quotePrice]];
    return Price;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
