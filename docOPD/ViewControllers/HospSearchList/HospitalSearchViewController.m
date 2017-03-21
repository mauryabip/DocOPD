//
//  HospitalSearchViewController.m
//  docOPD
//
//  Created by Virinchi Software on 10/29/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "HospitalSearchViewController.h"
#import "HospitalSearchTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "HospitalProfileVC.h"
#import "AllTimingsViewController.h"
#import "DocProfileVC.h"
#import "DocBookingViewController.h"
#import "DocEnquiryViewController.h"
#import "OpenEnquiryViewController.h"
#import "HDNotificationView.h"
@interface HospitalSearchViewController ()
@property (strong, nonatomic) IBOutlet UITableView *TableView;

@end

@implementation HospitalSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adviewTopConst.constant=500;
    sectionIndex=0;
  //  [self setupErrorview];
    [self.navigationController setNavigationBarHidden:YES];
    hospital = [[NSDictionary alloc]init];
    DoctorData = [[NSMutableArray alloc]init];
    pgIndex = @"1";
    [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.000];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"Hospital Search"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"Hospital Search List"];
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

    
    DoctorData = [response objectForKey:@"SuperHospitalList"];
   // NSLog(@"%d",DoctorData.count);
    if(![DoctorData isKindOfClass:[NSNull class]]){
        [self.TableView reloadData];
        [self ViewSlideup];
    }else{
        status = 9;
//        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"docOPD" message:[NSString stringWithFormat:@"Sorry!!! We didnot find the detail for '%@'",self.hosName ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        [self ViewSlideDown:[NSString stringWithFormat:@"Something went wrong with %@",self.hosName]];
    }

}

- (void) requestError
{
//    NSLog(@"hospital ViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
    [self ViewSlideDown:@"Something went wrong"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [DoctorData count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@" name   %@",[NSString stringWithFormat:@"%@",[DoctorData objectAtIndex:section][@"HospitalName"]]);
    return [NSString stringWithFormat:@"%@",[DoctorData objectAtIndex:section][@"HospitalName"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSMutableDictionary *DocDataValueAtIndex = [DoctorData objectAtIndex:section];
    NSMutableArray *DocListCount = [DocDataValueAtIndex valueForKey:@"DoctorList"];
    NSInteger RowInSection;
    if (DocListCount.count) {
        RowInSection = DocListCount.count;
    }else{
        RowInSection = 0;
    }
    return RowInSection;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HospitalSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    NSMutableDictionary *DocDataValueAtIndex = [DoctorData objectAtIndex:indexPath.section];
    NSMutableArray *DocListCount = [DocDataValueAtIndex valueForKey:@"DoctorList"];
    NSMutableDictionary *DocListDic= [[NSMutableDictionary alloc]init];
    cell.ViewImgBorder.layer.cornerRadius = cell.ViewImgBorder.layer.frame.size.width/2;
    cell.ViewImgBorder.backgroundColor = [UIColor whiteColor];
    cell.ViewImgBorder.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    cell.ViewImgBorder.layer.borderWidth = 2.0;
    
    [cell.BtnAllTimings setTitle:@"ALL TIMINGS" forState:UIControlStateNormal];
//    [cell.BtnAllTimings setTitleColor:[UIColor dOPDThemeColor] forState:UIControlStateNormal];
//    [cell.BtnAllTimings setBackgroundColor:[UIColor yellowColor]];
    NSString *btnTag = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section+1,(long)indexPath.row];
//    NSLog(@"Btn Tag: %@",btnTag);
    cell.BtnAllTimings.tag = btnTag.integerValue;
    [cell.BtnAllTimings addTarget:self action:@selector(GetAllTiming:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString *DoctorName;
    if (DocListCount.count)
    {
        DocListDic = [DocListCount objectAtIndex:indexPath.row];
//        DoctorName = [DocListDic valueForKey:@"HospitalName"];
        
        NSString*midname = [DocListDic valueForKey:@"MiddleName"];
        if ([midname isEqualToString:@""] || ![midname length] || [midname isEqualToString:@" "]) {
            DoctorName =[NSString stringWithFormat:@"%@ %@",[DocListDic valueForKey:@"FirstName"],[DocListDic valueForKey:@"LastName"]];
        }
        else{
            DoctorName =[NSString stringWithFormat:@"%@ %@ %@",[DocListDic valueForKey:@"FirstName"],[DocListDic valueForKey:@"MiddleName"],[DocListDic valueForKey:@"LastName"]];
        }
        cell.LblDoctorName.text = DoctorName;
        cell.LblDoctorName.font = [UIFont boldSystemFontOfSize:15.0];
        
        
        [cell.imgDoctor sd_setImageWithURL:[NSURL URLWithString:[DocListDic valueForKey:@"DocPicURL"]] placeholderImage:[UIImage imageNamed:@"doctor-96.png"] options:SDWebImageRefreshCached];
        cell.imgDoctor.layer.cornerRadius = cell.imgDoctor.frame.size.width/2;
        cell.imgDoctor.layer.masksToBounds = true;
        
        NSString*caption;
        if ([[DocListDic valueForKey:@"DoctorDescription"] isKindOfClass:[NSNull class]]) {
            caption = @"";
        }else caption=[DocListDic valueForKey:@"DoctorDescription"] ;
        
        [self displayImage:cell.imgDoctor withImage:cell.imgDoctor.image ImageCaption:caption];

        
        cell.LblDoctorDegree.text =[DocListDic valueForKey:@"DoctorQualification"];
        NSString *docexp = [DocListDic valueForKey:@"DoctorExperience"];
        if ( docexp.length) {
            if (docexp.integerValue >1) {
                docexp =[NSString stringWithFormat:@"%@ Years Experience",docexp];
            }else{
                docexp =[NSString stringWithFormat:@"%@ Year Experience",docexp];
            }
        }
        cell.LblDoctorExp.text = docexp;
        NSString *docRev = [DocListDic valueForKey:@"DoctorReview"];
        if (docRev.length) {
            if (docRev.integerValue >1) {
                docRev =[NSString stringWithFormat:@"%@ Reviews",docRev];
            }else{
                docRev =[NSString stringWithFormat:@"%@ Review",docRev];
            }
        }

        
        
        cell.LblDoctorReview.text = docRev;
        
        NSString *DocFee=[DocListDic valueForKey:@"ConsultationFee"];
        NSString *DocDisFee=[DocListDic valueForKey:@"DiscountedFee"];
        
        if (DocDisFee.length)
        {
            if ((!DocFee.length))
            {
                cell.LblDoctorOldRate.text = NA;
                cell.LblDoctorOldRate.hidden = true;
                cell.viewOldRate.hidden = true;
            }else{
                cell.LblDoctorOldRate.hidden = false;
                cell.viewOldRate.hidden = false;
                cell.LblDoctorOldRate.text = [NSString stringWithFormat:@"\u20B9 %@",DocFee];
                cell.LblDoctorNewRate.hidden = false;
                cell.LblDoctorNewRate.text= [NSString stringWithFormat:@"\u20B9 %@",DocDisFee];
            
            }
            
            cell.LblDoctorOldRate.font = [UIFont systemFontOfSize:12.0];
            cell.LblDoctorOldRate.textColor = [UIColor dOPDTextFontColor];
            
            
            NSDictionary* attributes = @{
                                         NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle],NSStrikethroughColorAttributeName: [UIColor dOPDTextFontColor]
                                         };
            
            NSAttributedString* attributeString = [[NSAttributedString alloc] initWithString:cell.LblDoctorOldRate.text attributes:attributes];
            cell.LblDoctorOldRate.attributedText = attributeString;
    
        }else
        {
            cell.LblDoctorOldRate.hidden = true;
            cell.viewOldRate.hidden = true;
            if (DocFee.length) {
                cell.LblDoctorNewRate.hidden = false;
                cell.LblDoctorNewRate.text= [NSString stringWithFormat:@"\u20B9 %@",DocFee];
            }
            else{
                cell.LblDoctorNewRate.hidden = true;
            }
        }
        
      
        //[self SetButtonBorder:cell.viewEnquiry];
        cell.viewEnquiry.layer.cornerRadius = 3.0f;
        //[self SetButtonBorder:cell.viewBookAppointment];
        cell.viewBookAppointment.backgroundColor = [UIColor dOPDThemeColor];
        cell.viewBookAppointment.layer.cornerRadius = 3.0f;
        cell.LblEnquiry.textColor= [UIColor dOPDThemeColor];
        cell.LblBookAppointment.textColor= [UIColor whiteColor];
        cell.LblDoctorNewRate.textColor = [UIColor dOPDTextFontColor];
        

        NSString *DocAvail= [DocListDic valueForKey:@"Availibity"];
        if ([DocAvail isEqualToString:@"Close Today"]) {
            cell.LblDoctorAvailibility.textColor =  [UIColor colorWithRed:205.0/255.0 green:90.0/255.0 blue:59.0/255.0 alpha:1.0];
        }else if ([DocAvail isEqualToString:@"Available Today"] ||[DocAvail isEqualToString:@"Available Now"] ) {
            cell.LblDoctorAvailibility.textColor = [UIColor dOPDThemeColor];
        }
        cell.LblDoctorAvailibility.text = DocAvail;
        
        [self TextColorForLable:cell.LblDoctorDegree];
        [self TextColorForLable:cell.LblDoctorExp];
        [self TextColorForLable:cell.LblDoctorOldRate];
        [self TextColorForLable:cell.LblDoctorReview];
        [self TextColorForLable:cell.LblDoctorName];
    
        cell.BtnDoctorProfile.tag =btnTag.integerValue;
        [cell.BtnDoctorProfile addTarget:self action:@selector(GoToDoctorProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    
    }//(HosListCount.count) end
    
    
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 110.0)];
    //[view setBackgroundColor:[UIColor dOPDTblSectionBGColor]]; //your background color...
    [view setBackgroundColor:[UIColor colorWithRed:98.0/255.0 green:210.0/255.0 blue:196.0/255.0 alpha:1.0]];
    /* Create custom view to display section header... */
    sectionIndex=section;
    
    UIView *HospLeftsideview = [[UIView alloc]init];
    HospLeftsideview.frame= CGRectMake(0, 0, view.frame.size.width/4 ,110);
    [view addSubview:HospLeftsideview];
    
    UIView *borderimgView = [[UIView alloc]initWithFrame:CGRectMake(8, 14, 74, 74)];

    [HospLeftsideview addSubview:borderimgView];
    
    
    borderimgView.layer.cornerRadius = borderimgView.layer.frame.size.width/2;
    borderimgView.backgroundColor = [UIColor whiteColor];
    borderimgView.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    borderimgView.layer.borderWidth = 2.0;
    
    
    
    UIImageView *HospImage = [[UIImageView alloc]init];
    if ([UIScreen mainScreen].bounds.size.width <= 320 ) {
        HospImage.frame= CGRectMake(12.0, 18.0, 66, 66);
        
    }
    else{
        HospImage.frame= CGRectMake(12.0, 18.0, 66, 66);
    }
    HospImage.layer.cornerRadius = 33.0;
    HospImage.layer.masksToBounds = YES;
    [HospLeftsideview addSubview:HospImage];
    
    NSString*HospUrl =[DoctorData objectAtIndex:section][@"HospitalLogoPath"];
    [HospImage sd_setImageWithURL:[NSURL URLWithString:HospUrl] placeholderImage:[UIImage imageNamed:@"def-hospital.png"] options:SDWebImageRefreshCached];
  
    NSString*caption;
    if ([[DoctorData objectAtIndex:section][@"HospitalAboutUs"] isKindOfClass:[NSNull class]]) {
        caption = @"";
    }else caption=[DoctorData objectAtIndex:section][@"HospitalAboutUs"] ;
    
    [self displayImage:HospImage withImage:HospImage.image ImageCaption:caption];
    
    UIView *HospRightsideview = [[UIView alloc]init];
    HospRightsideview.frame= CGRectMake(HospLeftsideview.frame.origin.x+HospLeftsideview.frame.size.width, 0, view.frame.size.width-view.frame.size.width/4 ,110);
    [view addSubview:HospRightsideview];
    
    
    
    
    UILabel *HospName = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, HospRightsideview.frame.size.width-10, 18)];
    [HospName setFont:[UIFont boldSystemFontOfSize:15]];
    
    NSString*Hname = [DoctorData objectAtIndex:section][@"HospitalName"];
    HospName.textColor = [UIColor dOPDTextFontColor];
    [HospName setText:Hname];
    [HospRightsideview addSubview:HospName];
    
    
    UIImageView *HospLocationImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, HospName.frame.origin.y + HospName.frame.size.height+10, 13, 13)];
    HospLocationImg.image = [UIImage imageNamed:@"location.png"];
  //  [HospRightsideview addSubview:HospLocationImg];
    
   // UILabel *HospLocation = [[UILabel alloc] initWithFrame:CGRectMake(HospLocationImg.frame.origin.x+HospLocationImg.frame.size.width+4, HospLocationImg.frame.origin.y, HospRightsideview.frame.size.width-(HospLocationImg.frame.origin.x+HospLocationImg.frame.size.width+4+26), 16)];
    UILabel *HospLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, HospName.frame.origin.y + HospName.frame.size.height+10, HospRightsideview.frame.size.width-20-26, 16)];
    [HospLocation setFont:[UIFont systemFontOfSize:13]];
    NSString *HospLocString =[NSString stringWithFormat:@"%@ %@",[DoctorData objectAtIndex:section][@"HospitalAddressline1"],[DoctorData objectAtIndex:section][@"HospitalAddressline2"]];
    [HospLocation setText:HospLocString];
    [self TextColorForLable:HospLocation];
    HospLocation.numberOfLines =2;
//    HospLocation.lineBreakMode = NSLineBreakByWordWrapping;
//    [HospLocation sizeToFit];
    [HospRightsideview addSubview:HospLocation];
    
    UIImageView *HospTypeImg = [[UIImageView alloc]initWithFrame:CGRectMake(HospLocationImg.frame.origin.x, HospLocationImg.frame.origin.y + HospLocationImg.frame.size.height+10, 13, 13)];
    HospTypeImg.image = [UIImage imageNamed:@"surgery.png"];
    //[HospRightsideview addSubview:HospTypeImg];
    
//    UILabel *HospType = [[UILabel alloc] initWithFrame:CGRectMake(HospTypeImg.frame.origin.x+HospTypeImg.frame.size.width+4, HospTypeImg.frame.origin.y, HospRightsideview.frame.size.width-(HospTypeImg.frame.origin.x+HospTypeImg.frame.size.width+4), 16)];
    UILabel *HospType = [[UILabel alloc] initWithFrame:CGRectMake(10, HospLocation.frame.origin.y +HospLocation.frame.size.height+5, HospRightsideview.frame.size.width-20-26, 16)];
    [HospType setFont:[UIFont systemFontOfSize:13]];
    
    NSString *HospTypeString =[NSString stringWithFormat:@"%@",[DoctorData objectAtIndex:section][@"HopitalType"]];
    [HospType setText:HospTypeString];
    [HospRightsideview addSubview:HospType];
    [self TextColorForLable:HospType];
    
    
    UIView *SectionAccView = [[UIView alloc]initWithFrame:CGRectMake(tableView.frame.size.width-26, (view.frame.size.height-26)/2, 26, 26)];
    [view addSubview:SectionAccView];
    
    UIImageView *sectionAccImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 16, 16)];
    sectionAccImg.image = [UIImage imageNamed:@"right-arrow.png"];
    [SectionAccView addSubview:sectionAccImg];
    
    
    UIButton *HospDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    HospDetailBtn.frame= CGRectMake(0, 0, HospRightsideview.frame.size.width ,HospRightsideview.frame.size.height);
    HospDetailBtn.tag = section+1;
    [HospDetailBtn addTarget:self action:@selector(GoToHospitalProfile:) forControlEvents:UIControlEventTouchUpInside];
    [HospRightsideview addSubview:HospDetailBtn];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 110;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
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


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image  {
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setupImageViewer];
    imageView.clipsToBounds = YES;
}


-(void)GoToDoctorProfile:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        
        NSMutableDictionary *hosDataValueAtIndex = [DoctorData objectAtIndex:indexPath.section];
        NSMutableArray *DocListCount = [hosDataValueAtIndex valueForKey:@"DoctorList"];
        
        DocProfileVC *DocProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_DocProfile"];
        DocProfile.DocFullData = [DocListCount objectAtIndex:indexPath.row];
       
        //    DocProfile.docID = [hosptalData objectAtIndex:indexPath.section][@"DoctorId"];
        [self.navigationController pushViewController:DocProfile animated:YES];
        
        
    }else{
//        NSLog(@"indexPath nil");
    }
}


-(void)GoToHospitalProfile:(UIButton*)sender{
    HospitalProfileVC *HosProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_HospitalProfile"];
    HosProfile.hosData = [DoctorData objectAtIndex:sender.tag-1];
    HosProfile.hosname = [DoctorData objectAtIndex:sender.tag-1][@"HospitalName"];
    
    
    
//    NSLog(@"last");
    //    testViewController *test = [self.storyboard instantiateViewControllerWithIdentifier:@"test"];
    //    [self.navigationController pushViewController:test animated:YES];
    
    [self.navigationController pushViewController:HosProfile animated:YES];

}


-(void)GetAllTiming: (UIButton*)sender{
//    NSLog(@"Sender Id is: %ld",(long)sender.tag);
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView
                              ];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        
//        NSLog(@"indexPath not nil");
//        NSLog(@"indexpath: Section = %ld, Row = %ld",(long)indexPath.section,(long)indexPath.row);
        AllTimingsViewController *alltime = [self.storyboard instantiateViewControllerWithIdentifier:@"AllTimings"];
        
        NSMutableDictionary *hosDataValueAtIndex = [DoctorData objectAtIndex:indexPath.section];
        NSMutableArray *DocListCount = [hosDataValueAtIndex valueForKey:@"DoctorList"];
        
        NSMutableDictionary *AvailDic = [[NSMutableDictionary alloc]init];
        [AvailDic setObject:[DocListCount objectAtIndex:indexPath.row][@"Sunday"] forKey:@"1"];
        [AvailDic setObject:[DocListCount objectAtIndex:indexPath.row][@"Monday"] forKey:@"2"];
        [AvailDic setObject:[DocListCount objectAtIndex:indexPath.row][@"Tuesday"] forKey:@"3"];
        [AvailDic setObject:[DocListCount objectAtIndex:indexPath.row][@"Wednesday"] forKey:@"4"];
        [AvailDic setObject:[DocListCount objectAtIndex:indexPath.row][@"Thursday"] forKey:@"5"];
        [AvailDic setObject:[DocListCount objectAtIndex:indexPath.row][@"Friday"] forKey:@"6"];
        [AvailDic setObject:[DocListCount objectAtIndex:indexPath.row][@"Saturday"] forKey:@"7"];
       
        alltime.AvailDic = AvailDic;
        
        NSString *DoctorName;
      
//        DocListDic = [DocListCount objectAtIndex:indexPath.row];
            //        DoctorName = [DocListDic valueForKey:@"HospitalName"];
            
            NSString*midname = [[DocListCount objectAtIndex:indexPath.row] valueForKey:@"MiddleName"];
            if ([midname isEqualToString:@""] || ![midname length] || [midname isEqualToString:@" "]) {
                DoctorName =[NSString stringWithFormat:@"%@ %@",[[DocListCount objectAtIndex:indexPath.row] valueForKey:@"FirstName"],[[DocListCount objectAtIndex:indexPath.row] valueForKey:@"LastName"]];
            }
            else{
                DoctorName =[NSString stringWithFormat:@"%@ %@ %@",[[DocListCount objectAtIndex:indexPath.row] valueForKey:@"FirstName"],[[DocListCount objectAtIndex:indexPath.row] valueForKey:@"MiddleName"],[[DocListCount objectAtIndex:indexPath.row] valueForKey:@"LastName"]];
            }

         alltime.DataFor = [hosDataValueAtIndex valueForKey:@"HospitalName"];;
        alltime.DataForDoctor = DoctorName;
        [self presentViewController:alltime animated:YES completion:nil];
    }else{
//        NSLog(@"indexPath nil");
    }

}

- (IBAction)didPressBookAppointment:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    
    NSMutableDictionary *hosDataValueAtIndex = [DoctorData objectAtIndex:indexPath.section];
    NSMutableArray *DocListCount = [hosDataValueAtIndex valueForKey:@"DoctorList"];
//    
//    Monday = "02:00 PM - 04:00 PM";
//    Saturday = "10:00 AM - 12:00 PM";
//    Sunday = "Not Available";
//    Thursday = "02:00 PM - 04:00 PM";
//    Tuesday = "Not Available";
//    Wednesday = "Not Available";

    
    
    if (indexPath != nil)
    {
        
        // NSMutableDictionary *hosDataValue = [HospitalListArray objectAtIndex:sender.tag-1];
        //        NSMutableArray *HosListCount = [hosDataValueAtIndex valueForKey:@"HospitalList"];
        
        DocBookingViewController *DocBook = [self.storyboard instantiateViewControllerWithIdentifier:@"DocBooking"];
        DocBook.comeFrom = @"search";
        NSString*Docimg =[DocListCount objectAtIndex:indexPath.row][@"DocPicURL"];
        
        
        NSString*midname = [DocListCount objectAtIndex:indexPath.row][@"MiddleName"];
        NSString *fullname;
        if ([midname isEqualToString:@""] || ![midname length] || [midname isEqualToString:@" "]) {
            fullname =[NSString stringWithFormat:@"%@ %@",[DocListCount objectAtIndex:indexPath.row][@"FirstName"],[DocListCount objectAtIndex:indexPath.row][@"LastName"]];
        }
        else{
            fullname =[NSString stringWithFormat:@"%@ %@ %@",[DocListCount objectAtIndex:indexPath.row][@"FirstName"],[DocListCount objectAtIndex:indexPath.row][@"MiddleName"],[DocListCount objectAtIndex:indexPath.row][@"LastName"]];
        }
        
        
        [DocBook DoctorDataName:fullname DocSpecility:[DocListCount objectAtIndex:indexPath.row][@"DoctorTitle"] DoctorDegree:[DocListCount objectAtIndex:indexPath.row][@"DoctorQualification"] DocImg:Docimg];
        
        NSString*hosname = [hosDataValueAtIndex valueForKey:@"HospitalName"];
        NSString*hostype = [hosDataValueAtIndex valueForKey:@"HopitalType"];
        //   NSString*hosAdd = [NSString stringWithFormat:@"%@",[hosData valueForKey:@"HospitalAddressLine1"]];
        
        //         NSString*hosAdd = [NSString stringWithFormat:@"%@, %@",[hosData valueForKey:@"HospitalAddressLine1"],[hosData valueForKey:@"HospitalAddressLine2"]];
        NSString*hosAdd = [NSString stringWithFormat:@"%@, %@, %@",[hosDataValueAtIndex valueForKey:@"HospitalAddressline1"],[hosDataValueAtIndex valueForKey:@"HospitalAddressline2"],[hosDataValueAtIndex valueForKey:@"HospitalCity"]];
        hosAdd =[hosDataValueAtIndex valueForKey:@"HospitalAddressline2"];
//        NSLog(@"hosadd in doc profile: %@",hosAdd);
        NSString*hosimg =[hosDataValueAtIndex valueForKey:@"HosPicURL"];
        DocBook.docid =[[DocListCount objectAtIndex:indexPath.row] valueForKey:@"DoctorId"];
        NSMutableDictionary *hospitaldata = [[NSMutableDictionary alloc]init];
        [hospitaldata setObject:[hosDataValueAtIndex valueForKey:@"HospitalAddressline1"] forKey:@"HospitalAddressline1"];
        [hospitaldata setObject:[hosDataValueAtIndex valueForKey:@"HospitalAddressline2"] forKey:@"HospitalAddressline2"];
        [hospitaldata setObject:[hosDataValueAtIndex valueForKey:@"HospitalCity"] forKey:@"HospitalCity"];
        [hospitaldata setObject:[hosDataValueAtIndex valueForKey:@"HosPicURL"] forKey:@"HosPicURL"];
        [hospitaldata setObject:[hosDataValueAtIndex valueForKey:@"HospitalName"] forKey:@"HospitalName"];
        [hospitaldata setObject:[hosDataValueAtIndex valueForKey:@"HopitalType"] forKey:@"HospitalType"];
        
        [hospitaldata setObject:[DocListCount objectAtIndex:indexPath.row][@"Sunday"] forKey:@"Sunday"];
        [hospitaldata setObject:[DocListCount objectAtIndex:indexPath.row][@"Monday"] forKey:@"Monday"];
        [hospitaldata setObject:[DocListCount objectAtIndex:indexPath.row][@"Tuesday"] forKey:@"Tuesday"];
        [hospitaldata setObject:[DocListCount objectAtIndex:indexPath.row][@"Wednesday"] forKey:@"Wednesday"];
        [hospitaldata setObject:[DocListCount objectAtIndex:indexPath.row][@"Thursday"] forKey:@"Thursday"];
        [hospitaldata setObject:[DocListCount objectAtIndex:indexPath.row][@"Friday"] forKey:@"Friday"];
        [hospitaldata setObject:[DocListCount objectAtIndex:indexPath.row][@"Saturday"] forKey:@"Saturday"];
        
        
        DocBook.HospitalData = hospitaldata;
        [DocBook HospitalDataName:hosname HospitalType:hostype HospitalAddress:hosAdd HospitalImg:hosimg];
        [self.navigationController pushViewController:DocBook animated:YES];
        
    }else{
//        NSLog(@"indexPath nil");
    }
    
}
- (IBAction)didPressEnquiryButton:(id)sender {
    
    DocEnquiryViewController *DocEnq = [self.storyboard instantiateViewControllerWithIdentifier:@"DocEnquiry"];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonPosition];
    DocEnq.comeFrom = @"search";
    NSMutableDictionary *hosDataValueAtIndex = [DoctorData objectAtIndex:indexPath.section];
    NSMutableArray *DocListCount = [hosDataValueAtIndex valueForKey:@"DoctorList"];
    NSMutableDictionary *doctorDataValueAtIndex = [DocListCount objectAtIndex:indexPath.row];
    
    if (indexPath != nil)
    {
        
        NSMutableDictionary *DocData = [[NSMutableDictionary alloc]init];
        [DocData setObject:[doctorDataValueAtIndex valueForKey:@"DocPicURL"] forKey:@"DocPicURL"];
        [DocData setObject:[doctorDataValueAtIndex valueForKey:@"DoctorId"] forKey:@"DoctorId"];
        
        NSString*midname = [doctorDataValueAtIndex valueForKey:@"MiddleName"];
        NSString *fullname;
        if ([midname isEqualToString:@""] || ![midname length] || [midname isEqualToString:@" "]) {
            fullname =[NSString stringWithFormat:@"%@ %@",[doctorDataValueAtIndex valueForKey:@"FirstName"],[doctorDataValueAtIndex valueForKey:@"LastName"]];
        }
        else{
            fullname =[NSString stringWithFormat:@"%@ %@ %@",[doctorDataValueAtIndex valueForKey:@"FirstName"],[doctorDataValueAtIndex valueForKey:@"MiddleName"],[doctorDataValueAtIndex valueForKey:@"LastName"]];
        }
        
        
        [DocData setObject:fullname forKey:@"DocName"];
        [DocData setObject:[doctorDataValueAtIndex valueForKey:@"DoctorTitle"] forKey:@"DocSpec"];
        [DocData setObject:[doctorDataValueAtIndex valueForKey:@"DoctorQualification"] forKey:@"DocDegree"];
        NSMutableDictionary *hospitaldata = [[NSMutableDictionary alloc]init];
        [hospitaldata setObject:[hosDataValueAtIndex valueForKey:@"HospitalAddressline1"] forKey:@"HospitalAddressline1"];
        [hospitaldata setObject:[hosDataValueAtIndex valueForKey:@"HospitalAddressline2"] forKey:@"HospitalAddressline2"];
        [hospitaldata setObject:[hosDataValueAtIndex valueForKey:@"HospitalCity"] forKey:@"HospitalCity"];
        [hospitaldata setObject:[hosDataValueAtIndex valueForKey:@"HosPicURL"] forKey:@"HosPicURL"];
        [hospitaldata setObject:[hosDataValueAtIndex valueForKey:@"HospitalName"] forKey:@"HospitalName"];
        [hospitaldata setObject:[hosDataValueAtIndex valueForKey:@"HopitalType"] forKey:@"HospitalType"];
        DocEnq.hospitalDic = hospitaldata;
        DocEnq.doctorDic = DocData;
        
        [self.navigationController pushViewController:DocEnq animated:YES];
        
        
        /*
         
         // NSMutableDictionary *hosDataValue = [HospitalListArray objectAtIndex:sender.tag-1];
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

-(void)ViewSlideup{
    [UIView animateWithDuration:1.6 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.adviewTopConst.constant=-115;
        [self.viewAD layoutIfNeeded];
       // self.viewAD.frame  = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-115, [UIScreen mainScreen].bounds.size.width,115);
        self.LblAdTitle.text = self.hosName;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didPressEnquirenowButton:)];
        tap.numberOfTapsRequired = 1.0;
        [self.viewAD addGestureRecognizer:tap];
    } completion:^(BOOL finished) {
        
        
        CGRect tableviewRect = self.TableView.frame;
        tableviewRect.size.height = tableviewRect.size.height - self.viewAD.frame.size.height;
        self.TableView.frame = tableviewRect;
        
        
        //        [UIView animateWithDuration:.5 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        //            self.ViewAd.frame  = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width,115);
        //
        //        } completion:^(BOOL finished) {
        //
        //        }];
        
    }];
}

- (IBAction)didPressEnquirenowButton:(UIButton *)sender {
    OpenEnquiryViewController *OEVC= [self.storyboard instantiateViewControllerWithIdentifier:@"OpenEnquiryViewController"];
    OEVC.comeFrom = @"Hosp";
    OEVC.titleName = self.LblAdTitle.text;
    OEVC.hospID = [DoctorData objectAtIndex:sectionIndex][@"HospitalId"];
    NSLog(@"hospital id   %@",OEVC.hospID);
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
    /*[UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
            if(status == 9){
                 [self.navigationController popViewControllerAnimated:YES];
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
    if(status == 9){
        [self performSelector:@selector(GoToBack:) withObject:nil afterDelay:3.0];
    }
    
}




- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image ImageCaption:(NSString*)caption  {
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    if ([caption isKindOfClass:[NSNull class]]) {
        caption = @"";
    }
    [imageView setupImageViewerWithText:caption?caption:@" "];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
