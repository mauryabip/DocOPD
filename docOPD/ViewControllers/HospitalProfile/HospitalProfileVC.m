//
//  HospitalProfileVC.m
//  docOPD
//
//  Created by Ashutosh Kumar on 8/4/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "HospitalProfileVC.h"
#import "UIImageView+WebCache.h"
#import "Hospital.h"
//#import "UINavigationBar+Awesome.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "DocProfileVC.h"
#import "MHFacebookImageViewer.h"
#import "HDNotificationView.h"

#import "HospitalProfileTableViewCell.h"
typedef enum{
    kTAG_DoctorBtn = 1,
    kTAG_TreatementBtn,
}ALLTAGS;
#define NAVBAR_CHANGE_POINT 50
@interface HospitalProfileVC ()

@end

@implementation HospitalProfileVC
@synthesize HospitalImage,HospitalView,HospitalAddLbl,HospitalNameLbl;
@synthesize ButtonHolder,DoctorBtn,TreatmentBtn,LastClicked,hosData;
- (void)viewDidLoad {
    [super viewDidLoad];
  //  [self setupErrorview];
    [self.navigationController setNavigationBarHidden:YES];
    

    [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.000];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.HospitalView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    NSLog(@"Enter in viewdidload");
    HospitalNameLbl.text = self.hosname;
    self.LblTopTitle.text = self.hosname;
   
    self.ViewBorderImg.backgroundColor = [UIColor dOPDImgBorderColor];
    self.ViewBorderImg.layer.cornerRadius = self.ViewBorderImg.layer.frame.size.width/2;
    self.ViewBorderImg.layer.masksToBounds = YES;

    NSString*caption;
    if ([[self.hosData valueForKey:@"HospitalAboutUs"] isKindOfClass:[NSNull class]]) {
        caption = @"";
    }else caption=[self.hosData valueForKey:@"HospitalAboutUs"] ;
    
    [self displayImage:self.ImgHospLogo withImage:self.ImgHospLogo.image ImageCaption:caption];
   

    self.DoctorBtn.tag = kTAG_DoctorBtn;
    self.TreatmentBtn.tag = kTAG_TreatementBtn;
    LastClicked = DoctorBtn;

    NSString *hospitalAddress=[NSString stringWithFormat:@"%@, %@",[self.hosData valueForKey:@"HospitalAddressline1"],[self.hosData valueForKey:@"HospitalAddressline2"]];
    if(![self.hosData valueForKey:@"HospitalAddressline1"] && ![self.hosData valueForKey:@"HospitalAddressline2"]){
        hospitalAddress=[NSString stringWithFormat:@"%@, %@",[self.hosData valueForKey:@"HospitalAddressLine1"],[self.hosData valueForKey:@"HospitalAddressLine2"]];
    }
    self.HospitalAddLbl.text = hospitalAddress;
    self.HospitalAddLbl.numberOfLines =2;
    self.HospitalAddLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.HospitalAddLbl sizeToFit];


    CGRect phyFrame = self.ic_physian.frame;
    phyFrame.origin.y = self.HospitalAddLbl.frame.size.height + self.HospitalAddLbl.frame.origin.y + 8;
    self.ic_physian.frame = phyFrame;
    
    phyFrame = self.LblNoOfPhysician.frame;
    phyFrame.origin.y = self.ic_physian.frame.origin.y -2;
    self.LblNoOfPhysician.frame = phyFrame;

    
    
    
    [self.HospitalImage sd_setImageWithURL:[NSURL URLWithString:[self.hosData valueForKey:@"HosPicURL"]]
                 placeholderImage:[UIImage imageNamed:@"def-hospital.png"] options:SDWebImageRefreshCached];
    
    
    
    [self displayImage:self.HospitalImage withImage:self.HospitalImage.image ImageCaption:caption];

    
    HospitalDocData = [[NSMutableArray alloc]init];
    HospitalTreatmentData = [[NSMutableArray alloc]init];
  
   // self.tableView.tableFooterView  = [[UIView alloc]initWithFrame:CGRectZero];
    [self ScrollResizer];
    [self setTableViewheightOfTable:self.tableView ByArrayName:HospitalTreatmentData];
    self.tableView.scrollEnabled = false;
    [self AboutPlacing];

    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappingHospview)];
//    tap.numberOfTapsRequired = 1.0;
//    [self.HospitalView addGestureRecognizer:tap];

    
  
}
//-(void)tappingHospview{
//     [self displayImage:self.HospitalImage withImage:self.HospitalImage.image];
//}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"HospitalScreen"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"HospitalScreen"];
}


-(void)AboutPlacing{
    
    CGRect NewAbout = self.ViewAbout.frame;
    NewAbout.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height;
    self.ViewAbout.frame = NewAbout;
    
    CGRect NewAboutDetail = self.HospAboutLbl.frame;
    NewAboutDetail.origin.y = self.ViewAbout.frame.origin.y+self.ViewAbout.frame.size.height;
    self.HospAboutLbl.frame = NewAboutDetail;
}

#pragma mark - SlideNavigationController Methods -

//
//- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
//{
//    return YES;
//}\

//- (void) viewWillAppear:(BOOL)animated
//{
//    NSLog(@"View will appear calling");
//    self.TopBar.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
//    self.tableView.delegate = self;
//    [self.tableView reloadData];
//   // [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:0.000];
//    self.Scroller.contentOffset = CGPointZero;
////    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
////    self.navigationController.navigationBar.backItem.title = @"";
////    self.navigationItem.title =  self.hosname;
////    //    [self.navigationController.navigationBar setTranslucent:NO];
////    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
////    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:18.0],NSFontAttributeName,
////                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
////                                                                   nil];
//   // self.TopBar.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
//
//}

//- (void)scrollViewScroll:(UIScrollView *)scrollView
//{
////    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
//   UIColor * color = [UIColor dOPDThemeColor];
//
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > NAVBAR_CHANGE_POINT) {
//        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
//       // [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
//         self.TopBar.backgroundColor = [[UIColor dOPDThemeColor]colorWithAlphaComponent:alpha];
//    } else {
////               NSLog(@"Else part of scrollview did scroll");
//            self.TopBar.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
//           //[self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
//    }
//}

//- (void)viewWillAppear:(BOOL)animatedTitle
//{
//    [super viewWillAppear:YES];
//    self.tableView.delegate = self;
//    [self scrollViewDidScroll:self.tableView];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // self.tableView.delegate = nil;
 //   [self.navigationController.navigationBar lt_reset];
}
//- (IBAction)BounceMenu:(id)sender {
////    static Menu menu = MenuLeft;
////    [[SlideNavigationController sharedInstance] toggleMenu:menu withCompletion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (IBAction)GoToBack:(id)sender {
    [Localytics tagEvent:@"HospitalSurgeryDocClick"];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)HospDocList:(id)sender {
    [self selectButton:sender];
     [self AboutPlacing];
    [self.tableView reloadData];
    [self ScrollResizer];
}

- (IBAction)HospTreamentList:(id)sender{
   
    [self selectButton:sender];
     [self AboutPlacing];
    [self.tableView reloadData];
       [self ScrollResizer];
}

-(void)selectButton:(UIButton*)sender{
    LastClicked.layer.backgroundColor = [UIColor clearColor].CGColor;
    [LastClicked setTitleColor:[UIColor dOPDThemeColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.layer.backgroundColor = [UIColor dOPDThemeColor].CGColor;
    LastClicked = sender;
    [self.tableView reloadData];
      [self AboutPlacing];
}



#pragma mark - TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"Number of section in table");
//    if (LastClicked.tag==kTAG_TreatementBtn) {
//         [self setTableViewheightOfTable:self.tableView ByArrayName:HospitalTreatmentData];
//        return HospitalTreatmentData.count;
//    }
//    else{
    [self setTableViewheightOfTable:self.tableView ByArrayName:HospitalDocData];
     return HospitalDocData.count;
    //}
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"HospitalCell";
    HospitalProfileTableViewCell *cell = (HospitalProfileTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    //NSLog(@"cellForRowAtIndexPath");
     // Configure the cell...
    if (cell==nil) {
        cell = [[HospitalProfileTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    

    Hospital *hospital = nil;
//    NSLog(@"click Doctor");
//        hospital = [HospitalData objectAtIndex:indexPath.row];
    hospital = [HospitalDocData objectAtIndex:indexPath.row];
    cell.LblDocName.text = hospital.DocName;
    

    
    cell.LblDocDegree.text = hospital.DocPost;
    cell.specalityLbl.text=hospital.Treatment;
/*========================================================================================================================================================
     Checking the discount fee and consultation fee. If discount fee not available, doctor fee will be consultation fee otherwise consultation fee is old 
    and discounted fee is actual fee docfee = discounted, old fees = consultation
 ========================================================================================================================================================*/
    
    if ([hospital.DocFee isEqualToString:@""]) {
        cell.LblOldPrice.hidden = false;
        cell.LblDocFee.hidden = false;
        if (![hospital.DocOldFee isEqualToString:@""]) {
             cell.LblDocFee.text =[NSString stringWithFormat:@"\u20B9 %@",hospital.DocOldFee];
             cell.LblOldPrice.hidden = true;
        }else{
            cell.LblOldPrice.hidden = true;
            cell.LblDocFee.hidden = true;
        }
       
    }else
    {
        cell.LblOldPrice.hidden = false;
        cell.LblDocFee.hidden = false;
        
        if (![hospital.DocOldFee isEqualToString:@""]) {
            cell.LblOldPrice.text =[NSString stringWithFormat:@"\u20B9 %@",hospital.DocOldFee];
            cell.LblDocFee.text =[NSString stringWithFormat:@"\u20B9 %@",hospital.DocFee];
        }else{
            cell.LblOldPrice.hidden = true;
            cell.LblDocFee.text =[NSString stringWithFormat:@"\u20B9 %@",hospital.DocFee];
        }
    }
    
    
//    if ([hospital.DocFee isEqualToString:@""]&&[hospital.DocOldFee isEqualToString:@""]){
//        cell.LblOldPrice.hidden = true;
//        cell.LblDocFee.hidden = true;
//    }else if ([hospital.DocFee isEqualToString:@""]&&![hospital.DocOldFee isEqualToString:@""]){
//        cell.LblOldPrice.hidden = true;
//        cell.LblDocFee.hidden = true;
//        cell.LblDocFee.text =[NSString stringWithFormat:@"\u20B9 %@",hospital.DocFee];
//    }
//    
    

    NSDictionary* attributes = @{
                             NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle],NSStrikethroughColorAttributeName: [UIColor colorWithRed:69.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0]
                             };

    NSAttributedString* attributeString = [[NSAttributedString alloc] initWithString:cell.LblOldPrice.text attributes:attributes];
    cell.LblOldPrice.attributedText = attributeString;

    
  
     /*==========================================================================================================================================================
                                                Doctor Image setting by sdwebimage chache
      ==========================================================================================================================================================*/

    [cell.ImgCell sd_setImageWithURL:[NSURL URLWithString:hospital.DocImage]
                          placeholderImage:[UIImage imageNamed:@"doctor-96.png"] options:SDWebImageRefreshCached];
        
    
    cell.ImgCell.contentMode = UIViewContentModeScaleAspectFit;
    cell.ImgCell.layer.cornerRadius = 44/2;
    cell.ImgCell.clipsToBounds = YES;
    [self displayImage:cell.ImgCell withImage:cell.ImgCell.image ImageCaption:hospital.DocAboutdoctor];
    //NSLog(@"%f", cell.imageView.frame.size.width);
    cell.ViewImageBack.layer.borderWidth = 1.0;
    cell.ViewImageBack.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    //NSLog(@"%f", cell.imageView.frame.size.width);
    cell.ViewImageBack.layer.cornerRadius = 50/2;
    cell.ViewImageBack.clipsToBounds = YES;
    
    /*==========================================================================================================================================================
                    Checking the doctor availibility. If available then color will greenish, if close text color will red
     ==========================================================================================================================================================*/
  
    NSString *DocAvail= hospital.DocAvailibility;
    if ([DocAvail isEqualToString:@"Close Today"]) {
        cell.LblAvailibility.textColor = [UIColor colorWithRed:205.0/255.0 green:90.0/255.0 blue:59.0/255.0 alpha:1.0];
   
    }else if ([DocAvail isEqualToString:@"Available Today"] ||[DocAvail isEqualToString:@"Available Now"] ) {

        cell.LblAvailibility.textColor = [UIColor dOPDThemeColor];
    }
    cell.LblAvailibility.text= DocAvail;

    
    /*==========================================================================================================================================================
        Checking the doctor list. If doctor more than 1 the down connected line will show
     ==========================================================================================================================================================*/
    
    if (DocList.count>1 && indexPath.row<DocList.count-1) {
        cell.LblSepConditional.hidden = false;
    }else{
       cell.LblSepConditional.hidden = true;
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"Didseleect");
//if(LastClicked.tag == kTAG_DoctorBtn){
    Hospital *hospital = nil;
//    NSLog(@"click Doctor cell");
    hospital = [HospitalDocData objectAtIndex:indexPath.row];
    NSString *docid = hospital.DocId;
    
//    NSLog(@"docid didselect: %@",docid);
    DocProfileVC *DocProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_DocProfile"];
    DocProfile.DocFullData = [hospital.doclistarray objectAtIndex:indexPath.row];
   
//   NSLog(@"docid didselect: %@",[hospital.doclistarray objectAtIndex:indexPath.row]);
    DocProfile.comeFrom = @"Hospital";
    DocProfile.HospID = [hosData valueForKey:@"HospitalId"];

    if (self.comeFrom == nil)
    {
      [self.navigationController pushViewController:DocProfile animated:YES];
    }else if ([self.comeFrom isEqualToString:@"Doctor"])
    {
        if([self.docID isEqualToString:docid])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self.navigationController pushViewController:DocProfile animated:YES];
        }
        
    }
    
    

    // }
    

}



#pragma mark - imageWithImage

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - Scroll Resizer

-(void)ScrollResizer{
    CGRect Newframe = self.ContentView.frame;
    
    Newframe.size.height = self.HospAboutLbl.frame.size.height+self.HospAboutLbl.frame.origin.y+10;
    self.ContentView.frame = Newframe;
    //[self.Scroller setContentSize:self.ContentView.frame.size];
    self.Scroller.contentSize = CGSizeMake(self.Scroller.frame.size.width, self.ContentView.frame.size.height);
//    self.HospitalAddLbl.text = [self.hosData valueForKey:@"HospitalAddress"];
    
}

#pragma mark - API Calling

-(void)ApiCalling{
    [[AppDelegate MyappDelegate] showIndicator];
    NSString *hosID = [hosData valueForKey:@"HospitalId"];
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kHospitalProfile], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:hosID,HospitalID,nil];
    
//    NSLog(@"dataDic for GetHospitalListByName: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kHospitalProfile;
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
    NSMutableDictionary *resposeCode=[response objectForKey:@"HospitalProfile"];
//    NSLog(@"response code dic: %@",resposeCode);
//    NSString* hosaddress = [NSString stringWithFormat:@"%@, %@",[resposeCode valueForKey:@"HospitalAddressline1"],[resposeCode valueForKey:@"HospitalAddressline2"]];
    //NSString* hosCity = [NSString stringWithFormat:@"%@, %@",[resposeCode valueForKey:@"HospitalCity"],[resposeCode valueForKey:@"HospitalCountry"]];
//    self.HospitalAddLbl.text = hosaddress;
//    self.HospitalAddLbl.numberOfLines = 0;
//    self.HospitalAddLbl.lineBreakMode = NSLineBreakByWordWrapping;
//    [self.HospitalAddLbl sizeToFit];
    
    self.HospAboutLbl.numberOfLines = 0;
    self.HospAboutLbl.text = [NSString stringWithFormat:@"%@",[resposeCode valueForKey:@"HospitalAboutUs"]];
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 18.f;
    style.maximumLineHeight = 18.f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
    self.HospAboutLbl.attributedText = [[NSAttributedString alloc] initWithString:[resposeCode valueForKey:@"HospitalAboutUs"]
                                                             attributes:attributtes];
    self.HospAboutLbl.lineBreakMode = NSLineBreakByWordWrapping;
    [self.HospAboutLbl sizeToFit];
    self.aboutHTConst.constant=self.HospAboutLbl.frame.size.height;
    
    if (!self.HospAboutLbl.text || [self.HospAboutLbl.text isEqualToString:@""]|| [self.HospAboutLbl.text isEqualToString:@" "]) {
        self.ViewAbout.hidden = true;
        self.HospAboutLbl.hidden = true;
    }else{
        self.ViewAbout.hidden = false;
        self.HospAboutLbl.hidden = false;
    }

    
    
    self.ImgHospLogo.layer.cornerRadius = self.ImgHospLogo.layer.frame.size.width/2;
    self.ImgHospLogo.layer.masksToBounds = YES;
    
    [self.ImgHospLogo sd_setImageWithURL:[NSURL URLWithString:[resposeCode valueForKey:@"HospitalLogoPath"]] placeholderImage:[UIImage imageNamed:@"def-hospital.png"] options:SDWebImageRefreshCached];
    
    
    TreatmentList = [[NSMutableArray alloc]init];
    TreatmentList = [resposeCode valueForKey:@"SpecialistList"];
    if (![TreatmentList isKindOfClass:[NSNull class]])
    {
        if (TreatmentList.count)
        {
            for (int i=0; i<TreatmentList.count; i++)
            {
                Hospital *hospital = [Hospital new];
                hospital.Treatment= [NSString stringWithFormat:@"%@",[TreatmentList objectAtIndex:i][@"ProcedureName"]];
                if([[TreatmentList objectAtIndex:i]valueForKey:@"IconUrl"]){
                    hospital.TreatmentImage = [NSString stringWithFormat:@"%@",[TreatmentList objectAtIndex:i][@"IconUrl"]];
                }
                else {
                    hospital.TreatmentImage = @"specialities-icon-96.png";
                }
                [HospitalTreatmentData addObject:hospital];
            }
        }
    
    }
    
    
    
    DocList = [resposeCode valueForKey:@"DoctorList"];
    if (![DocList isKindOfClass:[NSNull class]])
    {
        if (DocList.count) {
            
//            CGRect phyFrame = self.ic_physian.frame;
//            phyFrame.origin.y = self.HospitalAddLbl.frame.size.height + self.HospitalAddLbl.frame.origin.y + 8;
//            self.ic_physian.frame = phyFrame;
//            
//            phyFrame = self.LblNoOfPhysician.frame;
//            phyFrame.origin.y = self.ic_physian.frame.origin.y -2;
//            self.LblNoOfPhysician.frame = phyFrame;
            
            if (DocList.count>1) {
                self.LblNoOfPhysician.text = [NSString stringWithFormat:@"%ld Physicians",(long)DocList.count];
            }else{
                self.LblNoOfPhysician.text = [NSString stringWithFormat:@"%ld Physician",(long)DocList.count];
            }
            
            for (int i=0; i<DocList.count; i++) {
                Hospital *hospital = [Hospital new];
                hospital.DocName= [NSString stringWithFormat:@"%@ %@ %@",[DocList objectAtIndex:i][@"FirstName"],[DocList objectAtIndex:i][@"MiddleName"],[DocList objectAtIndex:i][@"LastName"]];
                if([[DocList objectAtIndex:i]valueForKey:@"DocPicURL"]){
                    hospital.DocImage = [NSString stringWithFormat:@"%@",[DocList objectAtIndex:i][@"DocPicURL"]];
                }
                else {
                     hospital.DocImage = @"doctor-96.png";
                }
                
                if([[DocList objectAtIndex:i]valueForKey:@"DoctorQualification"]){
                    hospital.DocPost = [NSString stringWithFormat:@"%@",[DocList objectAtIndex:i][@"DoctorQualification"]];
                }
                else {
                    hospital.DocPost = @"";
                }
                
                if([[DocList objectAtIndex:i]valueForKey:@"DoctorId"]){
                    hospital.DocId = [NSString stringWithFormat:@"%@",[DocList objectAtIndex:i][@"DoctorId"]];
                }
                else {
                    hospital.DocId = @"";
                }
                
                if([[DocList objectAtIndex:i]valueForKey:@"ConsultationFee"]){
                    hospital.DocOldFee = [NSString stringWithFormat:@"%@",[DocList objectAtIndex:i][@"ConsultationFee"]];
                }
                else {
                    hospital.DocOldFee = @"";
                }
                
                if([[DocList objectAtIndex:i]valueForKey:@"DiscountedFee"]){
                    hospital.DocFee = [NSString stringWithFormat:@"%@",[DocList objectAtIndex:i][@"DiscountedFee"]];
                }
                else {
                    hospital.DocFee = @"";
                }
                
                
                if([[DocList objectAtIndex:i]valueForKey:@"Availibity"]){
                    hospital.DocAvailibility = [NSString stringWithFormat:@"%@",[DocList objectAtIndex:i][@"Availibity"]];
                }
                else {
                    hospital.DocAvailibility = @"";
                }
                
                
                if([[DocList objectAtIndex:i]valueForKey:@"DoctorDescription"]){
                    if ([[[DocList objectAtIndex:i]valueForKey:@"DoctorDescription"] isKindOfClass:[NSNull class]]) {
                        hospital.DocAboutdoctor = @"";
                    }else
                    hospital.DocAboutdoctor = [NSString stringWithFormat:@"%@",[DocList objectAtIndex:i][@"DoctorDescription"]];
                }
                else {
                    hospital.DocAboutdoctor = @"";
                }
                
                if([[DocList objectAtIndex:i]valueForKey:@"DoctorTitle"]){
                    hospital.Treatment = [NSString stringWithFormat:@"%@",[DocList objectAtIndex:i][@"DoctorTitle"]];
                }
                else {
                    hospital.Treatment = @"";
                }
                //DoctorTitle
                
                
    //            HospitalData = [NSArray arrayWithObjects:hospital, hospital1, hospital2, hospital3, nil];
                [HospitalDocData addObject:hospital];
                hospital.doclistarray = DocList;
            }
            
        }
    }
    
    
//    [self AboutPlacing];
//    [self ScrollResizer];
    [self.tableView reloadData];
    
    [self AboutPlacing];
    [self ScrollResizer];
    
}

- (void) requestError
{
//    NSLog(@"hospital ViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
    [self ViewSlideDown:@"Something went wrong"];
}


-(void)setTableViewheightOfTable :(UITableView *)tableView ByArrayName:(NSArray *)array{
    
    CGFloat height =108.0;
//    NSLog(@"Row height: %f",height);
    height *= array.count;
    self.tableViewHTConst.constant=height;
    CGRect tableFrame = tableView.frame;
    tableFrame.size.height = height;
    tableView.frame = tableFrame;
}

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
    [imageView setupImageViewerWithText:caption?caption:@" "];
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
    [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"icon.png"]
                                                  title:AppName
                                                message:Message
                                             isAutoHide:YES
                                                onTouch:^{
                                                    
                                                    /// On touch handle. You can hide notification view or do something
                                                    [HDNotificationView hideNotificationViewOnComplete:nil];
                                                }];

}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
