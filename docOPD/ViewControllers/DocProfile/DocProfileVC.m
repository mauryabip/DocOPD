
//
//  DocProfileVC.m
//  docOPD
//
//  Created by Ashutosh Kumar on 8/3/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "DocProfileVC.h"
#import "UIImageView+WebCache.h"
//#import "UINavigationBar+Awesome.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "MHFacebookImageViewer.h"
#import "DocProfileHospitalTableViewCell.h"
#import "AllTimingsViewController.h"
#import "HospitalProfileVC.h"
#import "DocBookingViewController.h"
#import "DocEnquiryViewController.h"
#import "ColorUtilities.h"
#import "CAGradientLayer+OPDGradients.h"
#import "AllServicesViewController.h"
#import "OpenEnquiryViewController.h"
#import "HDNotificationView.h"
@interface DocProfileVC ()
#define NAVBAR_CHANGE_POINT 50
#define ARC4RANDOM_MAX  0x100000000
@end

@implementation DocProfileVC
@synthesize docNameLbl,LblDocDegree,LblDocOperation,LblDocPost,LblDocReview,LbldocTitle,LblTitleBar,ImgDoc,imgDocClinic;
@synthesize HospitalAddLbl,HospitalImage,HospitalLbl,HospitalView,HospSurgeryLbl;
@synthesize DocFullData,docFullName;
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setupErrorview];
    self.adviewTopConst.constant=-115;
    self.serviceTopConst.constant=300;
    isslideup = NO;
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.navigationBar.backItem.title = @"";
//    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.0]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.ViewDoctorProfileHolder.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didPressAdEnqiryBtn:)];
    tap.numberOfTapsRequired = 1.0;
    [self.ViewAd addGestureRecognizer:tap];

    ImgDoc.layer.cornerRadius = ImgDoc.layer.frame.size.width/2;
    ImgDoc.layer.masksToBounds = YES;
    HospitalImage.layer.cornerRadius = HospitalImage.layer.frame.size.width/2;
    HospitalImage.layer.masksToBounds = YES;
    ImgDoc.image = [UIImage imageNamed:@"doctor-96.png"];
    
    self.ViewImgBorder.layer.cornerRadius = self.ViewImgBorder.layer.frame.size.width/2;
    self.ViewImgBorder.layer.borderWidth = 2.0f;
    self.ViewImgBorder.layer.borderColor = [UIColor dOPDImgBorderColor].CGColor;
    

    HospitalListArray = [[NSMutableArray alloc]init];
    DocProfileDic = [[NSMutableDictionary alloc]init];
//    NSLog(@"DocfullDic = %@",self.DocFullData);
     [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.000];
    self.BtnAdKnowMore.layer.cornerRadius = 4.0;
}


- (double)randomFloat {
    double val;
    val = ((double)arc4random() / ARC4RANDOM_MAX);
//    NSLog(@"random flot ret: %f",val);
    return val;
}

-(void)ViewBuild{
    if ([[DocProfileDic valueForKey:@"DoctorQuatotion"]integerValue]>0) {
        
        [self ViewSlideup];
        
    }
//    else{
//        CGRect scrollRect = self.Scroller.frame;
//        self.Scroller.scrollEnabled = YES;
//        scrollRect.size.height = scrollRect.size.height + self.ViewAd.frame.size.height;
//        self.Scroller.frame = scrollRect;
//    }
    if ([[DocProfileDic valueForKey:@"MiddleName"] isEqualToString:@""] || [[DocProfileDic valueForKey:@"MiddleName"] isKindOfClass:[NSNull class]] ) {
        docFullName = [NSString stringWithFormat:@"%@ %@",[DocProfileDic valueForKey:@"FirstName"],[DocProfileDic valueForKey:@"LastName"]];
        
    }else{
        docFullName = [NSString stringWithFormat:@"%@ %@ %@",[DocProfileDic valueForKey:@"FirstName"],[DocProfileDic valueForKey:@"MiddleName"],[DocProfileDic valueForKey:@"LastName"]];
    }
    self.LblTopTitle.text= self.docFullName;
    self.LblTitleBar.text = self.docFullName;
    docNameLbl.text = self.docFullName;
    docNameLbl.textColor = [UIColor whiteColor];
    docNameLbl.font = [UIFont boldSystemFontOfSize:18.0];
    
    self.navigationItem.title = docFullName;
//    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:18.0],NSFontAttributeName,
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   nil];
    
    
    
    LblDocReview.text = [NSString stringWithFormat:@"%@ Review",[DocProfileDic objectForKey:@"TotalReview"]];
    
    
    LblDocReview.textColor = [UIColor whiteColor];
    LbldocTitle.textColor = [UIColor whiteColor];
    LbldocTitle.text =  [DocProfileDic objectForKey:@"DoctorTitle"];
    

    HospitalImage.layer.cornerRadius = HospitalImage.layer.frame.size.width/2;
    HospitalImage.layer.masksToBounds = YES;
    

    
    [self.ImgDoc sd_setImageWithURL:[NSURL URLWithString:[DocProfileDic valueForKey:@"DocPicURL"]] placeholderImage:[UIImage imageNamed:@"doctor-96.png"] options:SDWebImageRefreshCached];
    NSString*caption;
    if ([[DocProfileDic valueForKey:@"DoctorDescription"] isKindOfClass:[NSNull class]]) {
        caption = @"";
    }else caption=[DocProfileDic valueForKey:@"DoctorDescription"];
    
    [self displayImage:self.ImgDoc withImage:self.ImgDoc.image ImageCaption:caption];
    self.LblDocDegree.text = [DocProfileDic valueForKey:@"DoctorQualification"];
    self.LblDocDegree.textColor = [UIColor whiteColor];
    
    NSString *exp = [DocProfileDic valueForKey:@"DoctorExperience"];
    if (exp.integerValue>1) {
        self.LblDocExp.text = [NSString stringWithFormat:@"%@ Years Exp",exp];
    }else{
        self.LblDocExp.text = [NSString stringWithFormat:@"%@ Year Exp",exp];
    }
   // self.LblDocExp.textColor =[UIColor dOPDTextFontColor];
    
    NSMutableArray *hosData = [DocProfileDic valueForKey:@"HospitalList"];
    
    if (hosData.count) {
        // self.docInstituteLbl.text = [hosData objectAtIndex:0][@"HospitalName"];
    }
    else{
        //   self.docInstituteLbl.text = @"";
    }
    
    self.LblDocOperation.text = [DocProfileDic valueForKey:@"NoOfOperations"];
    if ((self.LblDocOperation.text.integerValue>1) &&  (self.LblDocOperation.text.integerValue>10000)) {
        
        self.LblDocOperation.text = @"10000+ Operations";
    }
    else if (self.LblDocOperation.text.integerValue>1){
        
         self.LblDocOperation.text = [NSString stringWithFormat:@"%@ Operations",self.LblDocOperation.text];
    }
    else if (self.LblDocOperation.text.integerValue>0){
        self.LblDocOperation.text = [NSString stringWithFormat:@"%@ Operation",self.LblDocOperation.text];
    }
    //self.LblDocOperation.textColor =[UIColor dOPDTextFontColor];
    [self setTableViewheightOfTable:self.TableView ByArrayName:HospitalListArray];
  //  [self scrollResize];
    self.navigationController.navigationBar.backItem.title = @"";
}

- (UIColor*) randomColor{
    int red = arc4random() % 255;
    int green = arc4random() % 255;
    int blue = arc4random() % 255;
    
    CGFloat hue = 0;
    CGFloat saturation = 0;
    CGFloat brightness = 0;
    
    CGFloat minRGB = MIN(red, MIN(green,blue));
    CGFloat maxRGB = MAX(red, MAX(green,blue));
    
    if (minRGB==maxRGB) {
        hue = 0;
        saturation = 0;
        brightness = minRGB;
    } else {
        CGFloat d = (red==minRGB) ? green-blue : ((blue==minRGB) ? red-green : blue-red);
        CGFloat h = (red==minRGB) ? 3 : ((blue==minRGB) ? 1 : 5);
        hue = (h - d/(maxRGB - minRGB)) / 6.0;
        saturation = (maxRGB - minRGB)/maxRGB;
        brightness = maxRGB;
    }
    
    
        return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.7];
    
   // return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}


//-(void)viewWillAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:NO];
//}

- (void) viewWillAppear:(BOOL)animated
{
    self.viewTopBar.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
    self.navigationController.navigationBar.backItem.title = @"";
   // self.Scroller.contentOffset = CGPointZero;
    [self.navigationController setNavigationBarHidden:YES];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//     [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.0]];
    
    self.navigationItem.title =  self.docFullName;
    //    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:18.0],NSFontAttributeName,
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   nil];
    
    
    
    [self.navigationController setNavigationBarHidden:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"Doctor Profile - %@",self.docFullName]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"Doctor profile"];
    
}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.Scroller.delegate = nil;
////     [self.navigationController setNavigationBarHidden:NO];
//    [self.navigationController.navigationBar lt_reset];
//}

- (IBAction)HospProfile:(id)sender {
}


#pragma mark - scroll Methods -



-(void)scrollResize{
    
    self.Scroller.contentSize = CGSizeMake(self.view.frame.size.width, self.tableHTConst.constant+self.servieViewHTConst.constant+270);
    self.scrollViewHTConst.constant=self.tableHTConst.constant+self.servieViewHTConst.constant+270;
    self.contentViewHTConst.constant=self.tableHTConst.constant+self.servieViewHTConst.constant+270;
    [self.view layoutIfNeeded];
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    UIColor * color = [UIColor dOPDThemeColor];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
          self.viewTopBar.backgroundColor = [[UIColor dOPDThemeColor]colorWithAlphaComponent:alpha];
    } else {
        //NSLog(@"Else part of scrollview did scroll");
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        self.viewTopBar.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
//       [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0.0]];
    }
}


#pragma mark- Image Zooming
- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image  {
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setupImageViewer];
    imageView.clipsToBounds = YES;
}

- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image ImageCaption:(NSString*)caption  {
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    if ([caption isKindOfClass:[NSNull class]]) {
        caption = @"";
    }
    [imageView setupImageViewerWithText:caption?caption:@""];
}



#pragma mark - API Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kDoctorProfile], keyRequestType,nil];
    //  NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.firstName,fName,self.middleName,mName,self.lastName,lName,pgIndex,PageIndex,nil];
    
    self.docID = [DocFullData valueForKey:@"DoctorId"];
    
//    NSLog(@"DocData = %@",self.docID);
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:self.docID,DoctorID,self.procIDForQuotation?self.procIDForQuotation:@"",@"pro_id",self.specIDForQuotation?self.specIDForQuotation:@"",@"spec_id",nil];
    
//    NSLog(@"dataDic for doctor profile: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kDoctorProfile;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling to get doctor profile");
    
}


#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
//    NSLog(@"doctor profile Controller requestFinished");
}


#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response

{
//    NSLog(@"response for docprofile = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    DocProfileDic = [response valueForKey:@"DoctorProfile"];
    DocSpecilitiesArr = [[NSMutableArray alloc]init];
    DocSpecilitiesArr = [response valueForKey:@"DoctorSpecilities"];
    HospitalListArray = [DocProfileDic valueForKey:@"HospitalList"];

    if ([HospitalListArray isKindOfClass:[NSNull class]]|| HospitalListArray == nil) {
//        NSLog(@"Returning coz of not data");
        return;
    }else{
        [self ViewBuild];
        
        if (HospitalListArray.count>0) {
           
            //NSLog(@"Hospital list array count %lu",(unsigned long)HospitalListArray.count);
             [self.TableView reloadData];
              [self setTableViewheightOfTable:self.TableView ByArrayName:HospitalListArray];
            self.TableView.scrollEnabled = false;
           [self SetupServiceView];
           // [self scrollResize];

            if ([[DocProfileDic valueForKey:@"DoctorQuatotion"]integerValue]>0) {
                // [self performSelector:@selector(ViewSlideup) withObject:nil afterDelay:1.0];
                //[self ViewSlideup];
                isslideup = YES;
            }
            [self scrollResize];
        }
//        }else{
//            //[self ViewSlideup];
//            self.TableView.scrollEnabled = false;
//          
//            [self setTableViewheightOfTable:self.TableView ByArrayName:HospitalListArray];
//              [self.TableView reloadData];
//            [self SetupServiceView];
//           
//            
//            if ([[DocProfileDic valueForKey:@"DoctorQuatotion"]integerValue]>0) {
//               // [self performSelector:@selector(ViewSlideup) withObject:nil afterDelay:1.0];
//                //[self ViewSlideup];
//                isslideup = YES;
//            }
//             [self scrollResize];
//        }
    }
}

- (void) requestError
{
//    NSLog(@"doctor profile   error");
    [[AppDelegate MyappDelegate] hideIndicator];
    [self ViewSlideDown:@"Something went wrong"];
}




#pragma mark - Tableview Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return  HospitalListArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    DocProfileHospitalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.Imghospital sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[HospitalListArray objectAtIndex:indexPath.row][@"HospitalLogoPath"]]] placeholderImage:[UIImage imageNamed:@"def-hospital.png"] options:SDWebImageRefreshCached];
   
    NSString*caption;
    if ([[HospitalListArray objectAtIndex:indexPath.row][@"HospitalAboutUs"] isKindOfClass:[NSNull class]]) {
        caption = @"";
    }else caption=[HospitalListArray objectAtIndex:indexPath.row][@"HospitalAboutUs"] ;
    
    [self displayImage:cell.Imghospital withImage:cell.Imghospital.image ImageCaption:caption];
    
    cell.Imghospital.layer.cornerRadius = cell.Imghospital.layer.frame.size.width/2;
    cell.Imghospital.layer.masksToBounds = YES;
    cell.LblHosName.text =[HospitalListArray objectAtIndex:indexPath.row][@"HospitalName"];
   // [self SetTextColor:cell.LblHosName];
    
    cell.LblHosLocation.text =[HospitalListArray objectAtIndex:indexPath.row][@"HospitalAddressLine2"];
    [self SetTextColor:cell.LblHosLocation];
    
    cell.LblHosType.text = [HospitalListArray objectAtIndex:indexPath.row][@"HospitalType"];
//    NSLog(@"Hos type: %@",[HospitalListArray objectAtIndex:indexPath.row][@"HospitalType"]);
    [self SetTextColor:cell.LblHosType];
    
   // cell.LblAvaiability.text = [HospitalListArray objectAtIndex:indexPath.row][@"Availibity"];
    NSString *DocAvail= [HospitalListArray objectAtIndex:indexPath.row][@"Availibity"];
    if ([DocAvail isEqualToString:@"Close Today"]) {
        cell.LblAvaiability.textColor = [UIColor colorWithRed:205.0/255.0 green:90.0/255.0 blue:59.0/255.0 alpha:1.0];
        //            cell.BtnAllTimings.hidd   en = true;
    }else if ([DocAvail isEqualToString:@"Available Today"] ||[DocAvail isEqualToString:@"Available Now"] ) {
        //            cell.BtnAllTimings.hidden = false;
        cell.LblAvaiability.textColor = [UIColor dOPDThemeColor];
    }
    cell.LblAvaiability.text= DocAvail;

    
    
    
    cell.BtnAllTiming.tag = indexPath.row;
    cell.BtnHospDetail.tag = indexPath.row;
    cell.BtnBookAppointment.tag = indexPath.row;
    cell.BtnEnquiry.tag = indexPath.row;
   // [cell.BtnAllTiming setTitleColor:[UIColor dOPDTextFontColor] forState:UIControlStateNormal];

    cell.viewBorderHospitalImg.layer.cornerRadius = cell.viewBorderHospitalImg.layer.frame.size.width/2;
    cell.viewBorderHospitalImg.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    cell.viewBorderHospitalImg.layer.borderWidth = 2.0;

    
    
    NSMutableDictionary *AvailDic = [[NSMutableDictionary alloc]init];
    [AvailDic setObject:[[HospitalListArray objectAtIndex:indexPath.row] valueForKey:@"Sunday"] forKey:@"1"];
    [AvailDic setObject:[[HospitalListArray objectAtIndex:indexPath.row]  valueForKey:@"Monday"] forKey:@"2"];
    [AvailDic setObject:[[HospitalListArray objectAtIndex:indexPath.row]  valueForKey:@"Tuesday"] forKey:@"3"];
    [AvailDic setObject:[[HospitalListArray objectAtIndex:indexPath.row]  valueForKey:@"Wednesday"] forKey:@"4"];
    [AvailDic setObject:[[HospitalListArray objectAtIndex:indexPath.row]  valueForKey:@"Thursday"] forKey:@"5"];
    [AvailDic setObject:[[HospitalListArray objectAtIndex:indexPath.row]  valueForKey:@"Friday"] forKey:@"6"];
    [AvailDic setObject:[[HospitalListArray objectAtIndex:indexPath.row]  valueForKey:@"Saturday"] forKey:@"7"];
        
    NSString *time = [AvailDic objectForKey:[NSString stringWithFormat:@"%ld",(long)[self findDay]]];

    NSRange range = [time rangeOfString:@","];
    NSArray *items = [[NSArray alloc]init];
    if (range.location != NSNotFound)
    {
        
//        NSLog(@"comma found in time");
        //items = [[AvailDic valueForKey:[NSString stringWithFormat:@"%d",(indexPath.row/2)+1]] componentsSeparatedByString:@","];
        items = [time componentsSeparatedByString:@","];
        NSString *d,*f;
        for (int i=0; i<items.count; i++) {
            d= [items objectAtIndex:i];
            d = [self RemoveLeadingAndTrailingSpace:d];
            if (i==0) {
                f=  d;
            }else{
//                NSLog(@"Doc time, multiline");
                f=  [NSString stringWithFormat:@"%@ \n%@",f,d];
            }
            
        }
//        NSLog(@"%@",f);
        cell.LblDocTiming.text = f;
        cell.LblDocTiming.numberOfLines=0;
        [cell.LblDocTiming sizeToFit];
    
    
    }else{
        
        cell.LblDocTiming.text = time;
//        NSLog(@"Not found");
    }
    [self SetTextColor:cell.LblDocTiming];
    
    [cell.viewBookAppointment setBackgroundColor:[UIColor dOPDThemeColor]];
    cell.viewBookAppointment.layer.cornerRadius = 2.0;
    cell.viewBookAppointment.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    cell.viewBookAppointment.layer.borderWidth = 1.0f;
 //   [cell.BtnBookAppointment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[cell.BtnEnquiry setBackgroundColor:[UIColor whiteColor]];
    cell.viewEnquiry.layer.cornerRadius = 2.0;
    cell.viewEnquiry.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    cell.viewEnquiry.layer.borderWidth = 1.0f;
    //[cell.viewEnquiry setTitleColor:[UIColor dOPDThemeColor] forState:UIControlStateNormal];
    
//     NSString *btnTag = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section+1,(long)indexPath.row];
//     cell.BtnHospDetail.tag =btnTag.integerValue;
    [cell.BtnHospDetail addTarget:self action:@selector(GoToHospitalProfile:) forControlEvents:UIControlEventTouchUpInside];

 
    
    
    return cell;
}


- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    // NSLog(@"willDisplayCell - %ld",(long)indexPath.section);
    if(indexPath.row % 2 == 0)
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

-(NSString *)RemoveLeadingAndTrailingSpace:(NSString*)str{
    NSString *squashed = [str stringByReplacingOccurrencesOfString:@"[ ]+"
                                                             withString:@" "
                                                                options:NSRegularExpressionSearch
                                                                  range:NSMakeRange(0, str.length)];
    
    NSString *final = [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return final;
}



-(void)SetTextColor:(UILabel*)label{
    label.textColor = [UIColor dOPDTextFontColor];
}
- (IBAction)didPressBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)ShowAllTimings:(UIButton*)sender {
    
   
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView
                              ];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        
//        NSLog(@"indexPath not nil");
//        NSLog(@"indexpath: Section = %ld, Row = %ld",(long)indexPath.section,(long)indexPath.row);
        AllTimingsViewController *alltime = [self.storyboard instantiateViewControllerWithIdentifier:@"AllTimings"];
        
        NSMutableDictionary *hosDataValueAtIndex = [HospitalListArray objectAtIndex:sender.tag];
        
        
        NSMutableDictionary *AvailDic = [[NSMutableDictionary alloc]init];
        [AvailDic setObject:[hosDataValueAtIndex valueForKey:@"Sunday"] forKey:@"1"];
        [AvailDic setObject:[hosDataValueAtIndex valueForKey:@"Monday"] forKey:@"2"];
        [AvailDic setObject:[hosDataValueAtIndex valueForKey:@"Tuesday"] forKey:@"3"];
        [AvailDic setObject:[hosDataValueAtIndex valueForKey:@"Wednesday"] forKey:@"4"];
        [AvailDic setObject:[hosDataValueAtIndex valueForKey:@"Thursday"] forKey:@"5"];
        [AvailDic setObject:[hosDataValueAtIndex valueForKey:@"Friday"] forKey:@"6"];
        [AvailDic setObject:[hosDataValueAtIndex valueForKey:@"Saturday"] forKey:@"7"];
        alltime.DataFor = [hosDataValueAtIndex valueForKey:@"HospitalName"];
        alltime.DataForDoctor = docFullName;
        alltime.AvailDic = AvailDic;
        [self presentViewController:alltime animated:YES completion:nil];
    }else{
//        NSLog(@"indexPath nil");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row % 2 == 1){
//  
//         NSLog(@"indexPath hight: 10");
//         return 3;
//    }
//    else{
//   
//         NSLog(@"indexPath  hight: 186");
         return 215;
   // }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    NSLog(@"viewForHeaderInSection");
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35.0)];
    [view setBackgroundColor:[UIColor dOPDBlueColor]]; //your background color...
   // [view setBackgroundColor:[UIColor whiteColor]];

    UILabel *seperatorUpper = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    seperatorUpper.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
   // [view addSubview:seperatorUpper];
    UIImageView *HospitalIcon = [[UIImageView alloc]init];
    if (section==0) {
        HospitalIcon.frame= CGRectMake(13.0,seperatorUpper.frame.size.height+ 5 + seperatorUpper.frame.origin.y, 20,20);
        [HospitalIcon setImage:[UIImage imageNamed:@"hospital-white.png"]];
        [view addSubview:HospitalIcon];
        
        UILabel *LblHospital = [[UILabel alloc] initWithFrame:CGRectMake(HospitalIcon.frame.size.width + HospitalIcon.frame.origin.x +10, HospitalIcon.frame.origin.y, [UIScreen mainScreen].bounds.size.width-(HospitalIcon.frame.size.width + HospitalIcon.frame.origin.x +10)*2, 20)];
        LblHospital.text = @"Places and Time of availability";
        LblHospital.textColor = [UIColor whiteColor];
        LblHospital.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        [view addSubview:LblHospital];

    }else if(section==1){
        HospitalIcon.frame= CGRectMake(13.0,seperatorUpper.frame.size.height+ 5 + seperatorUpper.frame.origin.y, 20 ,20);
        [HospitalIcon setImage:[UIImage imageNamed:@"surgery.png"]];
        [view addSubview:HospitalIcon];
        
        UILabel *LblHospital = [[UILabel alloc] initWithFrame:CGRectMake(HospitalIcon.frame.size.width + HospitalIcon.frame.origin.x +5, HospitalIcon.frame.origin.y, [UIScreen mainScreen].bounds.size.width-(HospitalIcon.frame.size.width + HospitalIcon.frame.origin.x +5)*2, 30)];
        LblHospital.text = @"Services";
        LblHospital.font = [UIFont systemFontOfSize:14.0];
        LblHospital.backgroundColor = [UIColor dOPDTextFontColor];
        [view addSubview:LblHospital];

    }
    
    
    UILabel *seperator = [[UILabel alloc] initWithFrame:CGRectMake(0, HospitalIcon.frame.origin.y + HospitalIcon.frame.size.height +5, [UIScreen mainScreen].bounds.size.width, 1)];
    seperator.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    //[view addSubview:seperator];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}




-(void)setTableViewheightOfTable :(UITableView *)tableView ByArrayName:(NSArray *)array{
//     NSLog(@"initial origin of table : %f, table height = %f",self.TableView.frame.origin.y,self.TableView.frame.size.height);
    CGFloat height =215.0;
    CGFloat sectionHeight = 35;
//    NSLog(@"Row height: %f",height);
    if (array==nil) {
        height = 0;
    }else{
       // CGFloat blankHeight = (array.count-1)*3;
        height *= array.count;
//        height = height+blankHeight + sectionHeight;
        height = height + sectionHeight;
//        NSLog(@"final table height: %f",height);
    }
    
    self.tableHTConst.constant=height;
    self.serviceTopConst.constant=0;
    [self.view layoutIfNeeded];
//    CGRect tableFrame = tableView.frame;
//    tableFrame.size.height = height;
//    tableView.frame = tableFrame;
    
//    CGFloat tvHeight = self.TableView.frame.origin.y + self.TableView.frame.size.height;
//        
//   CGRect servicerect = self.viewServices.frame;
//    servicerect.origin.y = tvHeight+10;
//    self.viewServices.frame = servicerect;
    
    
//    CGRect contRect = self.ContentView.frame;
//    contRect.size.height = self.servieViewHTConst.constant + servicerect.origin.y;
//    self.ContentView.frame = contRect;
//    NSLog(@" setTableViewheightOfTable origin of table : %f,  setTableViewheightOfTable final table height = %f",tableFrame.origin.y, tableFrame.size.height);

}

-(NSInteger)findDay{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday];
    return weekday;
}


-(void)GoToHospitalProfile:(UIButton*)sender{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
       // NSMutableDictionary *hosDataValueAtIndex = [HospitalListArray objectAtIndex:sender.tag-1];

        NSMutableDictionary *hosDataValue = [HospitalListArray objectAtIndex:sender.tag];
//        NSMutableArray *HosListCount = [hosDataValueAtIndex valueForKey:@"HospitalList"];
        
        HospitalProfileVC *HosProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_HospitalProfile"];
        HosProfile.hosData =hosDataValue;
        HosProfile.hosname = [hosDataValue valueForKey:@"HospitalName"];
        HosProfile.comeFrom= @"Doctor";
        HosProfile.docID=[DocProfileDic valueForKey:@"DoctorId"];
        if (self.comeFrom == nil)
        {
            [self.navigationController pushViewController:HosProfile animated:YES];
        }else if ([self.comeFrom isEqualToString:@"Hospital"])
        {
            if([self.HospID isEqualToString:[hosDataValue valueForKey:@"HospitalId"]])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                 [self.navigationController pushViewController:HosProfile animated:YES];
            }
            
        }
        
    }else{
//        NSLog(@"indexPath nil");
    }
}
- (IBAction)didPressEnquiry:(id)sender {
   
    DocEnquiryViewController *DocEnq = [self.storyboard instantiateViewControllerWithIdentifier:@"DocEnquiry"];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    DocEnq.comeFrom = @"profile";
    if (indexPath != nil)
    {
        NSMutableDictionary *DocData = [[NSMutableDictionary alloc]init];
        [DocData setObject:[DocProfileDic valueForKey:@"DocPicURL"] forKey:@"DocPicURL"];
        [DocData setObject:[DocProfileDic valueForKey:@"DoctorId"] forKey:@"DoctorId"];
        [DocData setObject:docNameLbl.text forKey:@"DocName"];
        [DocData setObject:LbldocTitle.text forKey:@"DocSpec"];
        [DocData setObject:LblDocDegree.text forKey:@"DocDegree"];
        NSMutableDictionary *hosData = [[DocProfileDic valueForKey:@"HospitalList"]objectAtIndex:indexPath.row];
        DocEnq.hospitalDic = hosData;
        DocEnq.doctorDic = DocData;
    }
   
    [self.navigationController pushViewController:DocEnq animated:YES];
    
}

- (IBAction)didPressBookingAppointment:(UIButton*)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        
     //   NSMutableDictionary *hosDataValue = [HospitalListArray objectAtIndex:sender.tag-1];
        //        NSMutableArray *HosListCount = [hosDataValueAtIndex valueForKey:@"HospitalList"];
        
        DocBookingViewController *DocBook = [self.storyboard instantiateViewControllerWithIdentifier:@"DocBooking"];
        DocBook.comeFrom = @"profile";
        NSString*Docimg =[DocProfileDic valueForKey:@"DocPicURL"];
        [DocBook DoctorDataName:docNameLbl.text DocSpecility:LbldocTitle.text DoctorDegree:LblDocDegree.text DocImg:Docimg];
         NSMutableDictionary *hosData = [[DocProfileDic valueForKey:@"HospitalList"]objectAtIndex:indexPath.row];
        NSString*hosname = [hosData valueForKey:@"HospitalName"];
        NSString*hostype = [hosData valueForKey:@"HospitalType"];
     //   NSString*hosAdd = [NSString stringWithFormat:@"%@",[hosData valueForKey:@"HospitalAddressLine1"]];
        
//         NSString*hosAdd = [NSString stringWithFormat:@"%@, %@",[hosData valueForKey:@"HospitalAddressLine1"],[hosData valueForKey:@"HospitalAddressLine2"]];
        NSString*hosAdd = [NSString stringWithFormat:@"%@",[hosData valueForKey:@"HospitalAddressLine2"]];
//        NSLog(@"hosadd in doc profile: %@",hosAdd);
        NSString*hosimg =[hosData valueForKey:@"HosPicURL"];
        DocBook.docid =[DocProfileDic valueForKey:@"DoctorId"];
        DocBook.HospitalData = hosData;
        [DocBook HospitalDataName:hosname HospitalType:hostype HospitalAddress:hosAdd HospitalImg:hosimg];
        [self.navigationController pushViewController:DocBook animated:YES];
        
    }else{
//        NSLog(@"indexPath nil");
    }
 
}


-(void)SetupServiceView{
    self.serviceTopConst.constant=0;
    NSInteger Viewheight = 0;
    NSInteger initialY=40;
    
    
    servicesArray = [[NSMutableArray alloc]init];
    for (int i=0; i<DocSpecilitiesArr.count; i++) {
        NSMutableDictionary *ProcedureDic = [DocSpecilitiesArr  objectAtIndex:i];
        NSMutableArray *tempServiceArr = [ProcedureDic valueForKey:@"ProcedureList"];
        if ([tempServiceArr isKindOfClass:[NSNull class]]) {
    
        }else{
            for (int k=0; k<tempServiceArr.count; k++) {
                [servicesArray addObject:[tempServiceArr objectAtIndex:k]];
            }
        }
    }
    if (![servicesArray isKindOfClass:[NSNull class]]) {
        if (servicesArray.count>0) {
            for (int i =0; i<servicesArray.count; i++) {
                
                UILabel *LblService = [[UILabel alloc]initWithFrame:CGRectMake(13.0, initialY+Viewheight+5, self.viewServices.frame.size.width-26, 20)];
                LblService.textColor = [UIColor dOPDTextFontColor];
                LblService.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
//                LblService.backgroundColor = [UIColor yellowColor];
                LblService.text = [servicesArray objectAtIndex:i][@"ProcedureName"];
                [self.viewServices addSubview:LblService];
                Viewheight = Viewheight + LblService.frame.size.height +5;
                if (i==4) {
                    if (servicesArray.count>5) {
                        UIButton *BtnMoreService = [UIButton buttonWithType:UIButtonTypeCustom];
                        BtnMoreService.frame = CGRectMake(13.0, initialY+Viewheight, self.viewServices.frame.size.width-26, 30);
                        [BtnMoreService setTitleColor:[UIColor dOPDBlueColor] forState:UIControlStateNormal];
                        BtnMoreService.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
                        BtnMoreService.userInteractionEnabled=YES;
                        BtnMoreService.backgroundColor = [UIColor clearColor];
                        [BtnMoreService setTitle:@"All Services" forState:UIControlStateNormal];
                        [BtnMoreService addTarget:self action:@selector(viewMoreServices) forControlEvents:UIControlEventTouchUpInside];
                        [self.viewServices addSubview:BtnMoreService];
                        BtnMoreService.titleLabel.textAlignment = NSTextAlignmentLeft;
                        BtnMoreService.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        Viewheight = Viewheight + LblService.frame.size.height +10;
                    }
                    
                    break;
                }

            }
            self.servieViewHTConst.constant=Viewheight+initialY+10;
            
            
            [self scrollResize];
 
        }else{
            self.viewServices.hidden = true;
            self.servieViewHTConst.constant=0;
            [self scrollResize];

        }
    }
    [self.view layoutIfNeeded];

//    if ([[DocProfileDic valueForKey:@"DoctorQuatotion"]integerValue]>0) {
//        [self ViewSlideup];
//    }
}


-(void)viewMoreServices{
    AllServicesViewController *AllSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AllServices"];
    AllSVC.DataFor =docFullName;
    AllSVC.ServicesArr = servicesArray;
    [self presentViewController:AllSVC animated:YES completion:nil];
}
- (IBAction)didPressAdEnqiryBtn:(id)sender {
    OpenEnquiryViewController *OEVC= [self.storyboard instantiateViewControllerWithIdentifier:@"OpenEnquiryViewController"];
    OEVC.comeFrom = @"Doc";
    OEVC.titleName = self.docFullName;
    OEVC.doctorID= self.docID;
    [self presentViewController:OEVC animated:YES completion:nil];
}


#pragma mark - Setup Error View
-(void)setupErrorview{
    errorView = [[UIView alloc]init];
    errorView.frame  = CGRectMake(0, -84, [UIScreen mainScreen].bounds.size.width,84);
    [self.view addSubview:errorView];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, (errorView.frame.size.height-20)/2, 30, 30)];
    icon.image = [UIImage imageNamed:@"round-logo-icon.png"];
    [errorView addSubview:icon];
    //[self ViewSlideDown:@"Something went wrong"];
}

#pragma mark - No Network Slider

-(void)ViewSlideDown:(NSString*)Message{
   /* [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        errorView.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,84);
        errorView.backgroundColor = [UIColor dOPDThemeColor];
        UILabel *msg = [[UILabel alloc]initWithFrame:CGRectMake(40, (errorView.frame.size.height-30)/2, errorView.frame.size.width-40, 40)];
        msg.text = Message;
        msg.tag = 99;
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

-(void)ViewSlideup{
    [UIView animateWithDuration:1.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //CGRect scrollRect = self.Scroller.frame;
        self.adviewTopConst.constant=0;
        [self.view layoutIfNeeded];
//        scrollRect.size.height = scrollRect.size.height - self.ViewAd.frame.size.height;
//        self.Scroller.frame = scrollRect;
        //self.ViewAd.frame  = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-115, [UIScreen mainScreen].bounds.size.width,115);
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didPressAdEnqiryBtn:)];
//        tap.numberOfTapsRequired = 1.0;
//        [self.ViewAd addGestureRecognizer:tap];
        self.LblAdPrice.text = [DocProfileDic objectForKey:@"DoctorQuatotion"];
        self.LblAdTitle.text = [DocProfileDic objectForKey:@"DoctorQuatotionProcedureName"];
        [self.LblAdPrice setAdjustsFontSizeToFitWidth:YES];
        self.LblAdPrice.numberOfLines =1;
        self.LblAdPrice.text = [self thousandSep:[DocProfileDic objectForKey:@"DoctorQuatotion"]];
       
    } completion:^(BOOL finished) {
//        CGRect scollerviewRect = self.Scroller.frame;
//        scollerviewRect.size.height = scollerviewRect.size.height - self.ViewAd.frame.size.height;
//        self.Scroller.frame = scollerviewRect;
        
    }];
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
