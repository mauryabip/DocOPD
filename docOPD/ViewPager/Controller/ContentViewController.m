//
//  ContentViewController.m
//  CKViewPager
//
//  Created by Lucas Oceano on 11/03/2015.
//  Copyright (c) 2015 Lucas Oceano Martins. All rights reserved.
//

#import "ContentViewController.h"
#import "HostViewController.h"
#import "HostoryTableViewCell.h"
#import "HHAlertView.h"
#import "UIImageView+WebCache.h"
#import "SWTableViewCell.h"
#import "DocEnquiryViewController.h"
#import "ReplyOnEnquiryVC.h"
#import "HDNotificationView.h"
@interface ContentViewController ()
{
    BOOL isnotify;
}
@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    HostViewController *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"HostVC"];
//    hvc.delegates = self;
    lastButton = self.BtnEnquiry;
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self didPressHistory:self.BtnHistory];
    [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.000];
    BookingArray = [[NSMutableArray alloc]init];

 //   _label.text = _labelString;
//    NSLog(@"current tab index = %@",self.labelString);
    self.ViewNotFoundRecord.hidden = true;
  
}

-(void)viewWillAppear:(BOOL)animated{
//    NSLog(@"current tab index = %@",self.labelString);
//    NSLog(@"current tab index = %d",self.currentindex);
 //   [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.000];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"HistoryScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"HistoryScreen"];
}


//-(void)currentIndex:(NSInteger)index{
//    curIndex = index;
//    NSLog(@"deleage tab index: %d",index);
//}


#pragma mark - API Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:@"We are fetching \nbooking & enquiry details"];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetBookingAndEnquiryHistory], keyRequestType,nil];
    NSUserDefaults *userdef = userDefault;
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userdef objectForKey:User_id],User_id,nil];
    
//    NSLog(@"dataDic for GetBookingAndEnquiryHistory profile: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetBookingAndEnquiryHistory;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling for Get BookingAndEnquiryHistory");
}


-(void)ApiCallingForCancelBooking{
    [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:@"We are cancelling \nyour booking request"] ;
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCancelBooking], keyRequestType,nil];
    NSUserDefaults *userdef = userDefault;
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userdef objectForKey:AuthKey],AuthKey,[NSString stringWithFormat:@"%@",bookingID],BookingID ,nil];
    
//    NSLog(@"dataDic for CancelBooking : %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kCancelBooking;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling for Cancel Booking");
    
    
}


#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    if (currentRequestType==kGetBookingAndEnquiryHistory) {
        [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
    }else  if (currentRequestType==kCancelBooking) {
        [self performSelector:@selector(resultForCancelBooking:) withObject:responseData afterDelay:.000];
    }

//    NSLog(@"history Controller requestFinished");
}


#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response

{
//    NSLog(@"response = %@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    BookingArray=[response objectForKey:@"BookingHistory"];
    EnquiryArray = [response objectForKey:@"EnquiryHistory"];

    if (BookingArray.count == 0) {
        if (self.currentindex==0) {
//            self.ViewNotFoundRecord.hidden = false;
//            self.LblNotFoundRecord.text = @"We didn't find any booking record.";
//            self.LblNotFoundRecord.textAlignment = NSTextAlignmentCenter;
//
            
            self.ViewNotFoundRecord.hidden = false;
            self.LblTitleForEmpty.text = @"No Appointment";
            //self.LblNotFoundRecord.text = @"You can book an appointment for any Doctor or Speciality.";
            [self showEmptyMessage:@"You can book an appointment for any Doctor or Speciality."];
            self.ImgEmpty.image = [UIImage imageNamed:@"emptyMeeting.png"];
//            self.LblNotFoundRecord.textAlignment = NSTextAlignmentCenter;
       
            
            
        }
    }else{
        self.ViewNotFoundRecord.hidden = true;
        [self.tableView reloadData];
    }
    
}
-(void)showEmptyMessage:(NSString*)txt{
    CGRect frame = self.LblNotFoundRecord.frame;
    frame.size.width = [UIScreen mainScreen].bounds.size.width-20;
    frame.origin.x = 10;
   
    self.LblNotFoundRecord.text = txt;
    self.LblNotFoundRecord.numberOfLines = 0;
    self.LblNotFoundRecord.lineBreakMode = NSLineBreakByWordWrapping;
    [self.LblNotFoundRecord sizeToFit];
    self.LblNotFoundRecord.textAlignment = NSTextAlignmentCenter;
     self.LblNotFoundRecord.frame =frame;
}
#pragma mark - result methods for login service
- (void) resultForCancelBooking:(NSDictionary *)response
{
//    NSLog(@"response = %@",response);
    status = [[response valueForKey:@"Deleted Status"][@"Status"]integerValue];
    if (currentRequestType==kCancelBooking) {
        [[AppDelegate MyappDelegate] hideIndicator];
        if (status==1) {
           

            NSMutableDictionary *BookingHistoryDic = [[NSMutableDictionary alloc]init];
            BookingHistoryDic = [BookingArray objectAtIndex:clickedCell];
            [BookingHistoryDic setObject:@"5" forKey:@"Status"];
//            bookingID = [BookingHistoryDic valueForKey:@"UserCanceled"];
            // [self.tableView reloadData];
            
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[clickedIndexpath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            
            
        }else if(status==0){
             [self ViewSlideDown:@"Something went wrong"];
             [self.tableView reloadData];
        }
        
    }
    
    
}

- (void) requestError
{
//    NSLog(@"history ViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
    [self ViewSlideDown:@"Something went wrong"];
}



- (void)errorWithTitle:(NSString*)title detailMessage:(NSString*)detail {
    [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:title detail:detail cancelButton:nil Okbutton:@"OK"];
}

- (void)success:(NSString*)title detailMessage:(NSString*)detail {
    [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:title detail:detail cancelButton:nil Okbutton:@"OK" block:^(HHAlertButton buttonindex) {
        if (buttonindex == HHAlertButtonOk) {
//            NSLog(@"ok Button is seleced use block");
            
        }
        else
        {
//            NSLog(@"cancel Button is seleced use block");
            
        }
    }];
}




#pragma mark - TableUpdate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1.0;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (self.currentindex==0) {
        count = BookingArray.count;
    }else if (self.currentindex==1) {
        count = EnquiryArray.count;
    }
    return count;
}

- (void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.tableView.layoutMargins = UIEdgeInsetsZero;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HostoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    cell.layoutMargins = UIEdgeInsetsZero;
    if (self.currentindex==0)
    {
//        NSLog(@"Enter in booking");
        NSMutableDictionary *BookingHistoryDic = [BookingArray objectAtIndex:indexPath.row];
        cell.LblDocName.text = [NSString stringWithFormat:@"Dr. %@",[self RemoveLeadingAndTrailingSpace:[BookingHistoryDic valueForKey:@"DoctorName"]]];
        cell.LblDocDegree.text =[BookingHistoryDic valueForKey:@"DocQualification"];
        
        cell.lblHospital.text = [self RemoveLeadingAndTrailingSpace:[BookingHistoryDic valueForKey:@"HospitalName"]];
        
        //,[self RemoveLeadingAndTrailingSpace:[BookingHistoryDic valueForKey:@"HosCity"]
        
        NSString*enqDate= [self DateFormat:[BookingHistoryDic valueForKey:@"BookingDate"]];
      //  cell.lblDate.text = enqDate;
        
        NSString *detailAppointment;
        detailAppointment = [NSString stringWithFormat:@"%@ on %@",[self RemoveLeadingAndTrailingSpace:[BookingHistoryDic valueForKey:@"BookingTime"]],enqDate];
        
        CGRect OldMeetingInfoFrame = cell.LblMeetingInfo.frame;
        cell.LblMeetingInfo.text = detailAppointment;
        cell.LblMeetingInfo.numberOfLines =0;
        cell.LblMeetingInfo.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.LblMeetingInfo sizeToFit];
        CGRect NewFrameForMeeting = cell.LblMeetingInfo.frame;
        NewFrameForMeeting.size.width = OldMeetingInfoFrame.size.width;
        cell.LblMeetingInfo.frame =NewFrameForMeeting;
        CGRect infoFrame = cell.LblStatus.frame;
        infoFrame.origin.y = cell.LblMeetingInfo.frame.origin.y + cell.LblMeetingInfo.frame.size.height +3;
        cell.LblStatus.frame = infoFrame;
        cellHeight = cell.LblStatus.frame.size.height + cell.LblStatus.frame.origin.y +10;
//        NSLog(@"Cell height: %f",cellHeight);
//        CGRect cellFrame = cell.contentView.frame;
//        cellFrame.size.height = cell.LblStatus.frame.size.height + cell.LblStatus.frame.origin.y +10;
//        cellHeight = cellFrame.size.height;
//        cell.contentView.frame = cellFrame;
        
        
        [cell.ImgDoc sd_setImageWithURL:[NSURL URLWithString:[BookingHistoryDic valueForKey:@"DoctorUrl"]]
                       placeholderImage:[UIImage imageNamed:@"doctor-96.png"]
                                options:SDWebImageRefreshCached];
        
        cell.viewImgBackRound.layer.cornerRadius = cell.viewImgBackRound.layer.frame.size.width/2;
        cell.viewImgBackRound.layer.masksToBounds = YES;
        cell.viewImgBackRound.layer.borderColor=[UIColor dOPDImgBorderColor].CGColor;
        cell.viewImgBackRound.layer.borderWidth=3.0f;
        
        cell.ImgDoc.layer.cornerRadius = cell.ImgDoc.layer.frame.size.width/2;
        cell.ImgDoc.layer.masksToBounds = YES;

        
        
        
        
/*=================================================================================================================================================================
                                Setup Image and background color. If expired then slide not allow. Using delegate method
 =================================================================================================================================================================*/
        cell.LblStatus.hidden = false;
        NSString *AdminCancel = [NSString stringWithFormat:@"%@",[BookingHistoryDic valueForKey:@"AdminCanceled"]];
        NSString *usrCancel =[NSString stringWithFormat:@"%@", [BookingHistoryDic valueForKey:@"UserCanceled"]];
        NSDate *date = [NSDate date];
        NSDateFormatter * myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate * dateFromString = [myDateFormatter dateFromString:[BookingHistoryDic valueForKey:@"BookingDate"]];

        cell.LblAppointmentStatic.textColor = [UIColor dOPDThemeColor];
        NSString *stat =[self CompareDate:date toDate:dateFromString];
        if ([stat isEqualToString:@"O"])
        {
            [cell.ImgStatus setImage:[UIImage imageNamed:@"upcoming-booking.png"]];
            //cell.LblStatus.hidden = true;
            cell.LblStatus.textColor = [UIColor dOPDThemeColor];
            cell.LblAppointmentStatic.textColor = [UIColor colorWithRed:0.0/255.0 green:161.0/255.0 blue:119.0/255.0 alpha:1.0];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:70.0f];
             cell.delegate = self;
        }else if([stat isEqualToString:@"S"])
        {
           [cell.ImgStatus setImage:[UIImage imageNamed:@"upcoming-booking.png"]];
            cell.LblStatus.text=@"";
           // cell.LblStatus.hidden = false;
            cell.LblStatus.textColor = [UIColor dOPDThemeColor];
            cell.LblAppointmentStatic.textColor = [UIColor colorWithRed:0.0/255.0 green:161.0/255.0 blue:119.0/255.0 alpha:1.0];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:70.0f];
            cell.delegate = self;
        }else if([stat isEqualToString:@"A"]){//O
            [cell.ImgStatus setImage:[UIImage imageNamed:@"expired-booking.png"]];
            cell.LblStatus.text=@"Appointment Completed";
            cell.LblStatus.textColor = [UIColor dOPDThemeColor];
            cell.LblStatus.hidden = false;
            cell.LblAppointmentStatic.textColor = [UIColor colorWithRed:161.0/255.0 green:162.0/255.0 blue:163.0/255.0 alpha:1.0];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:247.0 alpha:1.0]];
            [cell setRightUtilityButtons:nil];
            cell.delegate = nil;
        }
        
        
        NSString *current_status = [BookingHistoryDic valueForKey:@"Status"];
        if (current_status.integerValue==0) {
            if (![stat isEqualToString:@"A"]) {
                [cell.ImgStatus setImage:[UIImage imageNamed:@"review-booking.png"]];
                cell.LblStatus.text=@"Appointment under review";
                cell.LblStatus.textColor = [UIColor colorWithRed:222.0/255.0 green:150.0/255.0 blue:55.0/255.0 alpha:1.0];
                cell.LblAppointmentStatic.textColor = [UIColor colorWithRed:222.0/255.0 green:150.0/255.0 blue:55.0/255.0 alpha:1.0];
            }
            
        }else if(current_status.integerValue==1){
            if (![stat isEqualToString:@"A"]) {
                cell.LblStatus.text=@"Appointment confirmed";
                
            }
            
        }else if(current_status.integerValue==2){
            if (![stat isEqualToString:@"A"]) {
                cell.LblStatus.text=@"Spam Appointment";

            }
        }
        else if(current_status.integerValue==3){
            [cell.ImgStatus setImage:[UIImage imageNamed:@"cancelled-booking.png"]];
            cell.LblStatus.text=@"Doctor cancelled appointment";
            cell.LblStatus.hidden = false;
            cell.LblAppointmentStatic.textColor = [UIColor colorWithRed:161.0/255.0 green:162.0/255.0 blue:163.0/255.0 alpha:1.0];
            cell.LblStatus.textColor = [UIColor colorWithRed:242.0/255.0 green:101.0/255.0 blue:102.0/255.0 alpha:1.0];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:247.0 alpha:1.0]];
            cell.delegate = nil;
            [cell setRightUtilityButtons:nil];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:247.0 alpha:1.0]];
            cell.delegate = nil;
            [cell setRightUtilityButtons:nil];
        }
        else if(current_status.integerValue==4){
           [cell.ImgStatus setImage:[UIImage imageNamed:@"cancelled-booking.png"]];
            cell.LblStatus.text=@"Admin cancelled appointment";
            cell.LblStatus.hidden = false;
            cell.LblAppointmentStatic.textColor = [UIColor colorWithRed:161.0/255.0 green:162.0/255.0 blue:163.0/255.0 alpha:1.0];
            cell.LblStatus.textColor = [UIColor colorWithRed:242.0/255.0 green:101.0/255.0 blue:102.0/255.0 alpha:1.0];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:247.0 alpha:1.0]];
            cell.delegate = nil;
            [cell setRightUtilityButtons:nil];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:247.0 alpha:1.0]];
            cell.delegate = nil;
            [cell setRightUtilityButtons:nil];
            
             cell.LblStatus.hidden = false;
            
        }else if(current_status.integerValue==5){
            [cell.ImgStatus setImage:[UIImage imageNamed:@"cancelled-booking.png"]];
            cell.LblStatus.text=@"You cancelled appointment";
            cell.LblStatus.hidden = false;
            cell.LblAppointmentStatic.textColor = [UIColor colorWithRed:161.0/255.0 green:162.0/255.0 blue:163.0/255.0 alpha:1.0];
            cell.LblStatus.textColor = [UIColor colorWithRed:242.0/255.0 green:101.0/255.0 blue:102.0/255.0 alpha:1.0];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:247.0 alpha:1.0]];
            cell.delegate = nil;
            [cell setRightUtilityButtons:nil];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:247.0 alpha:1.0]];
            cell.delegate = nil;
            [cell setRightUtilityButtons:nil];
        }else{
            [cell.ImgStatus setImage:nil];
            cell.LblStatus.text=@"";
        }
        
//        if ([AdminCancel isEqualToString:@"1"]) {
//            [cell.ImgStatus setImage:[UIImage imageNamed:@"cancelled-booking.png"]];
//            cell.LblStatus.hidden = false;
//            cell.LblStatus.text=@"Cancel by Doctor";
//            cell.LblStatus.textColor = [UIColor colorWithRed:242.0/255.0 green:101.0/255.0 blue:102.0/255.0 alpha:1.0];
//            cell.LblAppointmentStatic.textColor = [UIColor colorWithRed:161.0/255.0 green:162.0/255.0 blue:163.0/255.0 alpha:1.0];
//            [cell.contentView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:247.0 alpha:1.0]];
//            cell.delegate = nil;
//            [cell setRightUtilityButtons:nil];
//        }else if ([usrCancel isEqualToString:@"1"]) {
//            [cell.ImgStatus setImage:[UIImage imageNamed:@"cancelled-booking.png"]];
//            cell.LblStatus.text=@"Cancel by patient";
//            cell.LblStatus.hidden = false;
//            cell.LblAppointmentStatic.textColor = [UIColor colorWithRed:161.0/255.0 green:162.0/255.0 blue:163.0/255.0 alpha:1.0];
//            cell.LblStatus.textColor = [UIColor colorWithRed:242.0/255.0 green:101.0/255.0 blue:102.0/255.0 alpha:1.0];
//            [cell.contentView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:247.0 alpha:1.0]];
//            cell.delegate = nil;
//            [cell setRightUtilityButtons:nil];
//        }
        cell.LblAppointmentStatic.text = @"Appointment Details";
        cell.ImgStatus.contentMode = UIViewContentModeScaleAspectFill;
        
           // [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:32.0f];
//            [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:70.0f];
//            cell.delegate = self;

            
    }else if (self.currentindex==1) {
//        NSLog(@"Enter in enquiry");
        cell.LblStatus.hidden = true;
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        NSMutableDictionary *EnquiryHistoryDic = [EnquiryArray objectAtIndex:indexPath.row];
        cell.LblDocName.text = [EnquiryHistoryDic valueForKey:@"Docname"];
        cell.lblHospital.text = [EnquiryHistoryDic valueForKey:@"HospitalName"];
        cell.LblDocDegree.text =[EnquiryHistoryDic valueForKey:@"DocQualification"];
        cell.LblAppointmentStatic.text = @"Enquiry Details";
        cell.LblAppointmentStatic.textColor = [UIColor dOPDThemeColor];
        cell.ImgStatus.image = [UIImage imageNamed:@"enq.png"];
        cell.ImgStatus.contentMode = UIViewContentModeScaleAspectFit;
        NSString*enqDate= [self DateFormat:[EnquiryHistoryDic valueForKey:@"EnquireDate"]];
        NSString *fulldetails= [NSString stringWithFormat:@"You made enquiy on %@ for %@ location",enqDate,[self RemoveLeadingAndTrailingSpace:[EnquiryHistoryDic valueForKey:@"HosCity"]]];
        CGRect OldMeetingInfoFrame = cell.LblMeetingInfo.frame;
        cell.LblMeetingInfo.text = fulldetails;
        cell.LblMeetingInfo.numberOfLines =0;
        cell.LblMeetingInfo.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.LblMeetingInfo sizeToFit];
        CGRect NewFrameForMeeting = cell.LblMeetingInfo.frame;
        NewFrameForMeeting.size.width = OldMeetingInfoFrame.size.width;
        cell.LblMeetingInfo.frame = NewFrameForMeeting;
        cell.LblStatus.text =[self RemoveLeadingAndTrailingSpace:[EnquiryHistoryDic valueForKey:@"UserComment"]];
        [cell.ImgDoc sd_setImageWithURL:[NSURL URLWithString:[EnquiryHistoryDic valueForKey:@"DocPicUrl"]] placeholderImage:[UIImage imageNamed:@"doctor-96.png"] options:SDWebImageRefreshCached];
        cell.viewImgBackRound.layer.cornerRadius = cell.viewImgBackRound.layer.frame.size.width/2;
        cell.viewImgBackRound.layer.masksToBounds = YES;
        cell.viewImgBackRound.layer.borderColor=[UIColor dOPDThemeColor].CGColor;
        cell.viewImgBackRound.layer.borderWidth=3.0f;
        cell.ImgDoc.layer.cornerRadius = cell.ImgDoc.layer.frame.size.width/2;
        cell.ImgDoc.layer.masksToBounds = YES;
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:60.0f];
        cell.delegate = self;
    }
    
    return cell;
    
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    // NSLog(@"willDisplayCell - %ld",(long)indexPath.section);
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger height = 0;
    if (self.currentindex==0) {
        height = 173.0f;
    }else if (self.currentindex==1) {
            height =  155.0f;
    }
    return height;
}




-(NSString*)DateFormat:(NSString*)dateString{
  //  NSLog(@"API date: %@",dateString);
    NSDateFormatter * myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate * dateFromString = [myDateFormatter dateFromString:dateString];
    [myDateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *newDateString = [myDateFormatter stringFromDate:dateFromString];
   // NSLog(@"Newchoosen date: %@",newDateString);
    dateString = [myDateFormatter stringFromDate:dateFromString];
   // NSLog(@"choosen date: %@",dateString);
    return newDateString;
}


- (NSString*) CompareDate:(NSDate*)date1 toDate:(NSDate*)date2 {
    NSDateFormatter* fmt = [NSDateFormatter new];
    NSString*ret;
    [fmt setDateFormat:@"yyyyMMdd"];
    // Note that you should set the appropriate timezone if you don't want the default.
    NSString* date1Str = [fmt stringFromDate:date1];
  //  NSLog(@"Date 1 is = %@",date1Str);

    NSString* date2Str = [fmt stringFromDate:date2];
      //  NSLog(@"Date 2 is = %@",date2Str);
    switch ([date1Str compare:date2Str]) {
        case NSOrderedAscending:
           // NSLog(@"Date 1 is earlier");
            ret = @"O";
            break;
        case NSOrderedSame:
            ret = @"S";
           // NSLog(@"Dates are equal");
            break;
        case NSOrderedDescending:
           ret = @"A";
           // NSLog(@"Date 2 is earlier");
            break;
    }
    return ret;
}
- (IBAction)didPressMenuButton:(id)sender {
     [Localytics tagEvent:@"HistorySideBarMenuClick"];
    static Menu menu = MenuLeft;
    menu = MenuLeft;
    [[SlideNavigationController sharedInstance] toggleMenu:menu withCompletion:nil];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
        [Localytics tagEvent:@"HistorySideBarMenuClick"];
    return YES;
}

-(void)setbottomBorder:(UIButton*)btn{
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height-5, btn.frame.size.width, 5)];
    lineView.backgroundColor = [UIColor dOPDThemeColor];
    lineView.tag = 200;
    [btn addSubview:lineView];
    
//    CALayer *bottomBorder = [CALayer layer];
//    bottomBorder.frame = CGRectMake(0.0f, btn.frame.size.height - 5, btn.frame.size.width, 5.0f);
//    bottomBorder.backgroundColor = [UIColor dOPDTFBorderColor].CGColor;
//    [btn.layer addSublayer:bottomBorder];
}
- (IBAction)didPressHistory:(UIButton*)sender {
        [Localytics tagEvent:@"HistoryBookingButtonClick"];
    //[self setbottomBorder:self.BtnHistory];
    [self deselectButton:lastButton];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.currentindex =0;
    lastButton = sender;
    [sender setBackgroundColor:[UIColor colorWithRed:84.0/255.0 green:201.0/255.0 blue:185.0/255.0 alpha:1.0]];
    [self.tableView reloadData];
    if (BookingArray.count==0) {
        if (self.currentindex==0) {
            self.ViewNotFoundRecord.hidden = false;
            self.LblTitleForEmpty.text = @"No Appointment";
//            self.LblNotFoundRecord.text = @"You can book an appointment for any Doctor or Speciality.";
            [self showEmptyMessage:@"You can book an appointment for any Doctor or Speciality."];
            
            self.ImgEmpty.image = [UIImage imageNamed:@"emptyMeeting.png"];
//            self.LblNotFoundRecord.textAlignment = NSTextAlignmentCenter;
        }
    }else{
        self.ViewNotFoundRecord.hidden = true;
        [self.tableView reloadData];
    }
    
}
- (IBAction)didPressEnquiry:(UIButton*)sender {
   // [self setbottomBorder:self.BtnEnquiry];
        [Localytics tagEvent:@"HistoryEnquiryButtonClick"];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self deselectButton:lastButton];
    [sender setBackgroundColor:[UIColor colorWithRed:84.0/255.0 green:201.0/255.0 blue:185.0/255.0 alpha:1.0]];
    self.currentindex =1;
    lastButton = sender;
    if (EnquiryArray.count==0) {
        if (self.currentindex==1) {
//            self.ViewNotFoundRecord.hidden = false;
//            self.LblNotFoundRecord.text = @"We didn't find any enquiry record";
//            self.LblNotFoundRecord.textAlignment = NSTextAlignmentCenter;
       
            self.ViewNotFoundRecord.hidden = false;
            self.LblTitleForEmpty.text = @"No Enquiry";
           // self.LblNotFoundRecord.text = @"Enquiry is very easy. Just search procedure or doctor and send the FREE Enquiry";
            [self showEmptyMessage: @"Enquiry is very easy. Just search procedure or doctor and send the FREE Enquiry"];
            self.ImgEmpty.image = [UIImage imageNamed:@"EmptyEnqyuiry.jpg"];

            
        }
    }else{
        self.ViewNotFoundRecord.hidden = true;
        [self.tableView reloadData];
    }
    
}
-(void)deselectButton:(UIButton*)sender{
    UIView *lineView = [sender viewWithTag:200];
    [sender setTitleColor:[UIColor colorWithRed:62.0/255.0 green:171.0/255.0 blue:156.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor colorWithRed:98.0/255.0 green:210.0/255.0 blue:196.0/255.0 alpha:1.0]];
    [lineView removeFromSuperview];
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    if (self.currentindex==0)
    {
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.00f green:0.1f blue:0.1f alpha:1.0] title:@"Cancel"];
    }else{
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor dOPDThemeColor] title:@"View"];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:8.0/255.0 green:65.0/255.0 blue:254.0/255.0 alpha:1.0]
                                                    title:@"Reply"];

  
    }
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"ticked.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
                                                icon:[UIImage imageNamed:@"clock.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"cross.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                icon:[UIImage imageNamed:@"menu.png"]];
    
    return leftUtilityButtons;
}
#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
//            NSLog(@"utility buttons closed");
            break;
        case 1:
//            NSLog(@"left utility buttons open");
            break;
        case 2:
//            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
//            NSLog(@"left button 0 was pressed");
            break;
        case 1:
//            NSLog(@"left button 1 was pressed");
            break;
        case 2:
//            NSLog(@"left button 2 was pressed");
            break;
        case 3:
//            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    DocEnquiryViewController *docEnqVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DocEnquiry"];
    ReplyOnEnquiryVC *replyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReplyOnEnquiry"];
    
    switch (index) {
        case 0:
        {
            if (self.currentindex==0)
            {
                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                clickedIndexpath = cellIndexPath;
                clickedCell = cellIndexPath.row;
//                NSLog(@"cancel button was pressed on cell : %ld",(long)cellIndexPath.row);
                NSMutableDictionary *BookingHistoryDic = [BookingArray objectAtIndex:cellIndexPath.row];
                bookingID = [BookingHistoryDic valueForKey:@"BookingId"];
//                NSLog(@"booking id : %@",bookingID);
                [cell hideUtilityButtonsAnimated:YES];
                [self ApiCallingForCancelBooking];
                break;
            }
            else if (self.currentindex==1)
            {
                [Localytics tagEvent:@"HistoryViewButtonClick"];
                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//                NSLog(@"View button was pressed on cell : %ld",(long)cellIndexPath.row);
                docEnqVC.comeFrom = @"History";
                NSMutableDictionary *EnqDataforDoctor = [EnquiryArray objectAtIndex:cellIndexPath.row];
                NSMutableDictionary *DocData = [[NSMutableDictionary alloc]init];
                [DocData setObject:[EnqDataforDoctor valueForKey:@"DocPicUrl"] forKey:@"DocPicURL"];
                [DocData setObject:[EnqDataforDoctor valueForKey:@"DoctorId"] forKey:@"DoctorId"];
                [DocData setObject:[EnqDataforDoctor valueForKey:@"Docname"] forKey:@"DocName"];
                [DocData setObject:[EnqDataforDoctor valueForKey:@"DoctorTitle"] forKey:@"DocSpec"];
                [DocData setObject:[EnqDataforDoctor valueForKey:@"DocQualification"] forKey:@"DocDegree"];
                
                
                NSMutableDictionary *HosData = [[NSMutableDictionary alloc]init];
                
                [HosData setObject:[EnqDataforDoctor valueForKey:@"HosPicUrl"] forKey:@"HosPicURL"];
                [HosData setObject:[EnqDataforDoctor valueForKey:@"HospitalId"] forKey:@"HospitalId"];
                [HosData setObject:[EnqDataforDoctor valueForKey:@"HospitalName"] forKey:@"HospitalName"];
                [HosData setObject:[EnqDataforDoctor valueForKey:@"HospitalType"] forKey:@"HospitalType"];
                [HosData setObject:[EnqDataforDoctor valueForKey:@"DocQualification"] forKey:@"DocDegree"];
                 [HosData setObject:[EnqDataforDoctor valueForKey:@"AddressLine1"] forKey:@"HospitalAddressLine1"];
                 [HosData setObject:[EnqDataforDoctor valueForKey:@"AddressLine2"] forKey:@"HospitalAddressLine2"];
                
                
                
                NSMutableDictionary *EnqData = [[NSMutableDictionary alloc]init];
                
                [EnqData setObject:[EnqDataforDoctor valueForKey:@"UserName"] forKey:@"UserName"];
                [EnqData setObject:[EnqDataforDoctor valueForKey:@"UserMobno"] forKey:@"UserMobno"];
                [EnqData setObject:[EnqDataforDoctor valueForKey:@"UserEmailid"] forKey:@"UserEmailid"];
                [EnqData setObject:[EnqDataforDoctor valueForKey:@"UserComment"] forKey:@"UserComment"];
                [EnqData setObject:[EnqDataforDoctor valueForKey:@"UserComment"] forKey:@"UserComment"];
                [EnqData setObject:[EnqDataforDoctor valueForKey:@"UserComment"] forKey:@"UserComment"];
                
                docEnqVC.hospitalDic = HosData;
                docEnqVC.doctorDic =  DocData;
                docEnqVC.enquiryData = EnqData;
                
                [self presentViewController:docEnqVC animated:YES completion:nil];
                break;
            }
        }
        case 1:
        {
            if (self.currentindex==1)
            {
                [Localytics tagEvent:@"HistoryReplyButtonClick"];
                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                NSMutableDictionary *EnqDataforDoctor = [EnquiryArray objectAtIndex:cellIndexPath.row];
//                NSLog(@"Reply button was pressed on cell : %ld",(long)cellIndexPath.row);
//                NSLog(@"Reply Data : %@",EnqDataforDoctor);
                NSMutableDictionary *EnqData = [[NSMutableDictionary alloc]init];
                
                [EnqData setObject:[EnqDataforDoctor valueForKey:@"UserName"] forKey:@"UserName"];
                [EnqData setObject:[EnqDataforDoctor valueForKey:@"UserComment"] forKey:@"UserComment"];
                [EnqData setObject:[EnqDataforDoctor valueForKey:@"DocPicUrl"] forKey:@"DocPicURL"];
                [EnqData setObject:[EnqDataforDoctor valueForKey:@"HospitalName"] forKey:@"HospitalName"];
                [EnqData setObject:[EnqDataforDoctor valueForKey:@"Docname"] forKey:@"Docname"];
                [EnqData setObject:[EnqDataforDoctor valueForKey:@"EnquireId"] forKey:EnquiryID];
                replyVC.enquiryData = EnqData;
                NSLog(@"Reply Data : %@",EnqData);
                [self.navigationController pushViewController:replyVC animated:YES];
                break;
            }
            
           // NSLog(@"Delete button was pressed");
//            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//            
//            [_testArray[cellIndexPath.section] removeObjectAtIndex:cellIndexPath.row];
//            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
          //fai  break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


#pragma mark - Setup Error View
-(void)setupErrorview{
    errorView = [[UIView alloc]init];
    errorView.frame  = CGRectMake(0, -84, [UIScreen mainScreen].bounds.size.width,84);
    [self.view addSubview:errorView];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, (errorView.frame.size.height-20)/2, 30, 30)];
    icon.image = [UIImage imageNamed:@"round-logo-icon.png"];
    [errorView addSubview:icon];
}

#pragma mark - No Network Slider

-(void)ViewSlideDown:(NSString*)Message{
  /*  [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        errorView.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,84);
        //errorView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
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


-(NSString *)RemoveLeadingAndTrailingSpace:(NSString*)str{
    NSString *squashed = [str stringByReplacingOccurrencesOfString:@"[ ]+"
                                                        withString:@" "
                                                           options:NSRegularExpressionSearch
                                                             range:NSMakeRange(0, str.length)];
    
    NSString *final = [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return final;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
