//
//  FindDocVC.m
//  docOPD
//
//  Created by Ashutosh Kumar on 8/1/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "FindDocVC.h"
#import "SearchVC.h"
#import "UIImageView+WebCache.h"
#import "ProcedureListViewController.h"
#import "CustomSearchViewController.h"
#import "HDNotificationView.h"
#import "ViewController.h"
typedef enum{
    kTAG_DoctorBtn = 1,
    kTAG_HospitalBtn,
    kTAG_ProcedureBtn,
    kTAG_MoreSectionview,
}ALLTAGS;

@interface FindDocVC ()


@end

@implementation FindDocVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.Scroller setAutoresizesSubviews:YES];
   // [self setupErrorview];
//     [self.navigationController setNavigationBarHidden:YES];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    folderDetails = [[NSMutableArray alloc]init];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.BounceMenu];
    self.DoctorBtn.tag = kTAG_DoctorBtn;
    self.ProcedureBtn.tag = kTAG_ProcedureBtn;
    self.HospitalBtn.tag = kTAG_HospitalBtn;
//    [self setpadding:self.SearchBoxTF];
//    [self setBorderCorner:self.ButtonHolderView];
//    [self Setborder:self.ProcedureBtn];
//    [self Setborder:self.DoctorBtn];
//    [self Setborder:self.HospitalBtn];
    masksList = [[NSMutableArray alloc]init];
    [self performSelector:@selector(getdata) withObject:nil afterDelay:0.000];
    self.MoreSectionView.tag = kTAG_MoreSectionview;
    userdef = userDefault;
    [self MainUI];
    self.LastclickedBtn = self.DoctorBtn;
   // [self scrollResize];
}

-(void)getdata{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Specialist"];
    masksList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *resposeCode=[NSKeyedUnarchiver unarchiveObjectWithData:data];

    for (int i=0; i<resposeCode.count; i++) {
        NSString *imgviewname = [NSString stringWithFormat:@"img%d",i+1];
        NSString *lblname = [NSString stringWithFormat:@"lbl%d",i+1];
        [self setimgforspec:imgviewname withURL:[resposeCode objectAtIndex:i][@"SpecIconUrl"] ChangeSpecName:[resposeCode objectAtIndex:i][@"SpecialistName"] Forlabel:lblname];
    }
    [self MainUI];
}
-(void)MainUI{
    self.BtnRefresh.hidden=true;
    [self setpadding:self.SearchBoxTF];
    [self setBorderCorner:self.ButtonHolderView];
    [self Setborder:self.ProcedureBtn];
    [self Setborder:self.DoctorBtn];
    [self Setborder:self.HospitalBtn];
    [self.SearchBoxTF resignFirstResponder];
    [self createThumbView];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//     [self.navigationController setNavigationBarHidden:YES];
//    [self.view endEditing:YES];
////    [self.SearchBoxTF resignFirstResponder];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear");
    [self setNeedsStatusBarAppearanceUpdate];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"SurgeryScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"SurgeryScreen"];
//    [self.view endEditing:YES];
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}


-(void)setpadding: (UITextField*)textField{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 36)];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(10, 9, 18, 18);
    [searchBtn setImage:[UIImage imageNamed:@"magnifying glass13.png"] forState:UIControlStateNormal];
    [paddingView addSubview:searchBtn];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 1.0;
    
    

    
    
}
-(void)setBorderCorner: (UIView*)UIView{
    UIView.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    UIView.layer.borderWidth = 1.0;
    UIView.layer.cornerRadius = 5.0;
}


-(void)selected:(UIButton*)UIButton{
    [self.LastclickedBtn setBackgroundColor:[UIColor clearColor]];
    [self.LastclickedBtn setTitleColor:[UIColor dOPDThemeColor] forState:UIControlStateNormal];
    [UIButton setBackgroundColor:[UIColor dOPDThemeColor]];
    [UIButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.LastclickedBtn = UIButton;
   // NSLog(@"find doc: %ld", (long)self.LastclickedBtn.tag);
    
}

-(void)MoreSectionFormatView:(UIView*)UIView{
    UIView.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    UIView.layer.borderWidth = 1.0;
    UIView.layer.cornerRadius = UIView.frame.size.width/2;
}


-(void)Setborder: (UIButton*)UIButton{
    UIButton.layer.borderWidth=1.0;
    UIButton.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
}


- (IBAction)SearchByProcedure:(id)sender {
    self.SearchBoxTF.placeholder = @"Procedure";
    [self selected:sender];
}

- (IBAction)SearchByDoctor:(id)sender {
    [self selected:sender];
    self.SearchBoxTF.placeholder = @"Doctor Name";
}

- (IBAction)SearchByHospital:(id)sender {
    self.SearchBoxTF.placeholder = @"Hospital Name";
    [self selected:sender];

}

- (IBAction)GoBack:(id)sender {
    [Localytics tagEvent:@"SurgeryHomeClick"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)scrollResize{
    CGRect newframe = self.ContentView.frame;
    newframe.size.height = self.MoreSectionView.frame.origin.y + self.MoreSectionView.frame.size.height+5;
    self.ContentView.frame = newframe;
    self.Scroller.contentSize = CGSizeMake(self.Scroller.frame.size.width, self.ContentView.frame.size.height);
}

#pragma mark - SlideNavigationController Methods -


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

- (IBAction)BounceMenu:(id)sender {
    [Localytics tagEvent:@"SurgeryHomeClick"];
    [self.navigationController popViewControllerAnimated:YES];
//    static Menu menu = MenuLeft;
//    menu = MenuLeft;
//    [[SlideNavigationController sharedInstance] toggleMenu:menu withCompletion:nil];
    //[self openOrCloseLeftList];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self sendToSearchScreen];
   

    [textField resignFirstResponder ];
}

-(void)sendToSearchScreen{
    [Localytics tagEvent:@"SurgerySearchClick"];
    CustomSearchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_Search"];
       [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Textfield Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - API Calling

-(void)ApiCalling{
   // [[AppDelegate MyappDelegate] showIndicator];
    [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:@"We are fetching \nSpecilities List"] ;
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetSpecialistList], keyRequestType,nil];

    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:AuthKey,AuthKey,nil];
    
//    NSLog(@"dataDic for verify user: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetSpecialistList;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
}

#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    if (currentRequestType==kGetMedicalRecords) {
        
       // [self performSelector:@selector(resultForGetMedicalRecord:) withObject:responseData afterDelay:.000];
        
    }else{
    
        [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
    }
//    NSLog(@"Find doctor Controller requestFinished");
}

#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response

{
    if (currentRequestType==kGetSpecialistList) {
//        NSLog(@"response = %@",response);
        self.BtnRefresh.hidden=true;
        [[AppDelegate MyappDelegate] hideIndicator];
        NSMutableArray *resposeCode=[response objectForKey:@"Specialist"];
        masksList = [response objectForKey:@"Specialist"];;
        for (int i=0; i<resposeCode.count; i++) {
            NSString *imgviewname = [NSString stringWithFormat:@"img%d",i+1];
            NSString *lblname = [NSString stringWithFormat:@"lbl%d",i+1];
            [self setimgforspec:imgviewname withURL:[resposeCode objectAtIndex:i][@"SpecIconUrl"] ChangeSpecName:[resposeCode objectAtIndex:i][@"SpecialistName"] Forlabel:lblname];
        }
        [self MainUI];
        
    }
}

-(void)setimgforspec:(NSString*)imgview withURL:(NSString*)url ChangeSpecName:(NSString*)specName Forlabel:(NSString*)lblname{
    
}

- (void) requestError
{
//    NSLog(@"RegisterViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
    [self ViewSlideDown:@"Something went wrong"];
    self.BtnRefresh.hidden=false;
}

- (void)createThumbView
{
    
    NSSortDescriptor * brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"SpecPriority.doubleValue" ascending:YES];
    NSArray * sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    sortedArray = [masksList sortedArrayUsingDescriptors:sortDescriptors];
   // NSLog(@"sortedArray %@",sortedArray);
    
    //NSLog(@"initial More section height : %f",self.MoreSectionView.frame.size.height);
    float y_axis = self.lblMoreSec.frame.size.height + self.lblMoreSec.frame.origin.y +10;
    
    int x = 0;
    
//    float width= [UIScreen mainScreen].bounds.size.width/5;
    float width= [UIScreen mainScreen].bounds.size.width/3;
  //  float a= (width-30.0)/2;
    
    float height = width-20;
    if ([UIScreen mainScreen].bounds.size.width>320) {
        height = width;
    }
  //  height = 80; //OLD
  //NSLog(@"section height : %f, width= %f",height, width);
    int totalImgs = (int)[sortedArray count];

    int tempCnt = 0;
    if (totalImgs >9) {
        totalImgs = 9;
    }
    
    for (int i = 0; i < totalImgs;)
    {
//        float x_axis = 10;
        float x_axis =(width-30.0)/2;
        x_axis = 0;
        int loopCount = 0;
        
        if (totalImgs - tempCnt >= (3))
        {
            loopCount = (3);
        }
        else
        {
            loopCount = totalImgs % (3);
        }
        
        for (int j = 0; j < loopCount; j++)
        {
         //   NSLog(@"loopcount - %d, j=%d, i=%d",loopCount,j,i);
            UIView *specView = [[UIView alloc]initWithFrame:CGRectMake(x_axis, y_axis,width, height)];
//            specView.backgroundColor = [UIColor yellowColor];
            if (j==3) {
                [self UpperSideBorder:specView];
            }else{
              [self twoSidedBorder:specView];
            }
//            if (i>5) {
//                [self LowerSideBorder:specView];
//            }
            specView.tag = x;
          
            // specView.backgroundColor = [UIColor greenColor];
            [self.MoreSectionView addSubview: specView];
            
//            UIImageView *specImg = [[UIImageView alloc]initWithFrame:CGRectMake((specView.frame.size.width-36)/2,((specView.frame.size.height-40)/2)-10,36,40)];
            UIImageView *specImg = [[UIImageView alloc]init];
            if ([UIScreen mainScreen].bounds.size.width>320) {
                specImg.frame =CGRectMake((specView.frame.size.width-55)/2,((specView.frame.size.height-55)/2),50,50);
            }else{
                specImg.frame =CGRectMake((specView.frame.size.width-40)/2,((specView.frame.size.height-40)/2)-10,46,40);
            }
            
            
            [specView addSubview:specImg];

//            UILabel *specName = [[UILabel alloc]initWithFrame:CGRectMake(0, specView.frame.size.height-15,width, 15)];
            UILabel *specName = [[UILabel alloc]initWithFrame:CGRectMake(2, specImg.frame.size.height + specImg.frame.origin.y +5,width-4, 15)];
            specName.text = [sortedArray objectAtIndex:x][@"SpecialistName"];
       
            specName.tag = 100;
            specName.textColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:49.0/255.0 alpha:1.0];
            specName.font = [UIFont systemFontOfSize:11.0];
            CGRect Oldframe = specName.frame;
//            specName.numberOfLines =2;
//            //specName.lineBreakMode = NSLineBreakByTruncatingTail;
//            //[specName sizeToFit];
            specName.numberOfLines =2;
            specName.lineBreakMode = NSLineBreakByTruncatingTail;
            specName.textAlignment = NSTextAlignmentCenter;
            [specName sizeToFit];
            CGRect Newframe = specName.frame;
            Newframe.size.width = Oldframe.size.width;
            specName.frame = Newframe;
            specName.textAlignment = NSTextAlignmentCenter;
            if (x==8) {
                specImg.image = [UIImage imageNamed:@"more.png"];
                specName.text = @"More";
            }else{
                // [specImg sd_setImageWithURL:[NSURL URLWithString:[sortedArray objectAtIndex:x][@"SpecIconUrl"]] placeholderImage:[UIImage imageNamed:@"specialities-icon-96.png"] options:SDWebImageRefreshCached];
                [specImg sd_setImageWithURL:[NSURL URLWithString:[sortedArray objectAtIndex:x][@"SpecIconUrl"]]
                             placeholderImage:[UIImage imageNamed:@"specialities-icon-96.png"]
                                      options:SDWebImageRefreshCached];
            }
            
           
            
            //            specName.numberOfLines = 0;
//            specName.lineBreakMode = NSLineBreakByWordWrapping;
//            [specName sizeToFit];
//            
//            
//            CGRect NewSpcName = specName.frame;
//            NewSpcName.size.width = width;
//            specName.frame = NewSpcName;
        
            
            [specView addSubview:specName];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]init];
            [specView addGestureRecognizer:tapGesture];
            [tapGesture addTarget:self action:@selector(SearchForProcedure:)];
            //photoCount++;
            x_axis += width;
            
            tempCnt++;
            i++;
            x++;
        }
        
        y_axis += height;
        CGRect MoreSc = self.MoreSectionView.frame;
        MoreSc.size.height = y_axis;
        self.MoreSectionView.frame = MoreSc;
        //        scroll View.contentSize = CGSizeMake(320.0, y_axis);
    }
   // NSLog(@"More section height : %f",self.MoreSectionView.frame.size.height);
  //  [self scrollResize];
}

-(void)SearchForProcedure:(UITapGestureRecognizer*)tap{
    
   // NSLog(@"%@",[sortedArray objectAtIndex:tap.view.tag]);
    ProcedureListViewController *procedureListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"ProcedureListViewController"];
    CustomSearchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_Search"];
    if (tap.view.tag==8) {
        self.LastclickedBtn.tag = kTAG_ProcedureBtn;
      //  [controller showDataof:self.LastclickedBtn.tag];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController pushViewController:controller animated:NO];
    }else{
        [Localytics tagEvent:[NSString stringWithFormat:@"Surgery%@Click",[sortedArray objectAtIndex:tap.view.tag][@"SpecialistName"]]];
        procedureListVC.specID = [sortedArray objectAtIndex:tap.view.tag][@"SpecialistId"];
        procedureListVC.ProName = [sortedArray objectAtIndex:tap.view.tag][@"SpecialistName"];
        procedureListVC.ShowDataFor = @"Spec";
       [self.navigationController pushViewController:procedureListVC animated:YES];
    }

}


#pragma mark - API Calling To Get Search List

-(void)GetDoctorList{
  [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetDocList], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userdef objectForKey:AuthKey],AuthKey,nil];
    
//    NSLog(@"dataDic for Reg: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetDocList;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
    
    
}
- (IBAction)didPressRefreshButton:(id)sender {
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag==9999) {
            [subview removeFromSuperview];
        }
    }
  //  [self setupErrorview];
    [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:.000];
}


-(void)GetHospitalList{
   [[AppDelegate MyappDelegate] showIndicator];
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
  [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetProcedureList], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userdef objectForKey:AuthKey],AuthKey,nil];
    
//    NSLog(@"dataDic for Reg: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetProcedureList;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
}


- (void) openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    NSLog(@"viewWillDisappear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}




#pragma mark - TextField Setup

-(void)twoSidedBorder:(UIView*)view{
    CALayer *upperBorder = [CALayer layer];
    upperBorder.frame = CGRectMake(0.0f, 0.0f, view.frame.size.width, 1.0f);
    upperBorder.backgroundColor = [UIColor dOPDTFBorderColor].CGColor;
    [view.layer addSublayer:upperBorder];
    
    CALayer *sidedBorder = [CALayer layer];
    sidedBorder.frame = CGRectMake(view.frame.size.width-1, 0.0f, 1, view.frame.size.height);
    sidedBorder.backgroundColor = [UIColor dOPDTFBorderColor].CGColor;
    [view.layer addSublayer:sidedBorder];
    
}

-(void)UpperSideBorder:(UIView*)view{
    CALayer *upperBorder = [CALayer layer];
    upperBorder.frame = CGRectMake(0.0f, 0.0f, view.frame.size.width, 1.0f);
    upperBorder.backgroundColor = [UIColor dOPDTFBorderColor].CGColor;
    [view.layer addSublayer:upperBorder];
}

-(void)LowerSideBorder:(UIView*)view{
    CALayer *upperBorder = [CALayer layer];
    upperBorder.frame = CGRectMake(0.0f, view.frame.size.height-1, view.frame.size.width, 1.0f);
    upperBorder.backgroundColor = [UIColor dOPDTFBorderColor].CGColor;
    [view.layer addSublayer:upperBorder];
}


//#pragma mark - Scroll Resizer
//
//-(void)ScrollResizer{
//    CGRect Newframe = self.ContentView.frame;
//    
//    Newframe.size.height = self.MoreSectionView.frame.size.height+self.MoreSectionView.frame.origin.y+10;
//    self.ContentView.frame = Newframe;
//    //[self.Scroller setContentSize:self.ContentView.frame.size];
//    self.Scroller.contentSize = CGSizeMake(self.Scroller.frame.size.width, self.ContentView.frame.size.height);
//    //    self.HospitalAddLbl.text = [self.hosData valueForKey:@"HospitalAddress"];
//    
//}


#pragma mark - Setup Error View
-(void)setupErrorview{
    errorView = [[UIView alloc]init];
    errorView.frame  = CGRectMake(0, -84, [UIScreen mainScreen].bounds.size.width,84);
    [self.view addSubview:errorView];
    errorView.tag = 9999;
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
