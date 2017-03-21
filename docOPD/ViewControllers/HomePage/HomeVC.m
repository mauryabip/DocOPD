//
//  HomeVC.m
//  docOPD
//
//  Created by Virinchi Software on 22/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "HomeVC.h"
#import "UIImageView+WebCache.h"

@interface HomeVC ()

@end

@implementation HomeVC


- (void)viewDidLoad {
    [super viewDidLoad];
    userdef = userDefault;
    
    [self getMedicalRecord];
    [self getData];
    homeArray = [[NSArray alloc]init];
     self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.BounceMenu];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HomeImage"];
    homeArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.referalView addGestureRecognizer:recognizer];
    // Do any additional setup after loading the view.
}
-(void)touch{
    [self.referTXT resignFirstResponder];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BOOL referValid=[[userdef valueForKey:@"IsReferenced"] boolValue];
    if (referValid) {
        self.referalView.hidden=YES;
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"HomeScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"HomeScreen"];
}

-(void)getData{
    [[docOPDNetworkEngine sharedInstance] GetReferenceCodeByUserIdAPI:[userdef objectForKey:User_id] withCallback:^(NSDictionary *responseData) {
        NSString *referenceCode=[responseData valueForKey:@"ReferenceCode"];
        NSString *contactSupport=[responseData valueForKey:ContactSupport];//ContactSupport
         [userdef setObject:referenceCode forKey:ReferenceCode];
        [userdef setObject:contactSupport forKey:ContactSupport];
        [userdef  synchronize];
        [self getfolderdata];
    }];
    
    
}

-(void)getfolderdata{
    [[docOPDNetworkEngine sharedInstance]GetMedicalImageTypeAPI:^(NSDictionary *responseData) {
        NSArray *arr=[responseData objectForKey:@"MedicalImageType"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:arr] forKey:@"MedicalImageType"];
        [userdef  synchronize];
        
        
    }];
}



#pragma mark - SlideNavigationController Methods -


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (IBAction)BounceMenu:(id)sender {
    [Localytics tagEvent:@"HomeSidebarMenuClick"];
    static Menu menu = MenuLeft;
    menu = MenuLeft;
    [[SlideNavigationController sharedInstance] toggleMenu:menu withCompletion:nil];
}
#pragma Collection view

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [homeArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *specName = (UILabel *)[cell viewWithTag:101];
    UILabel *specType = (UILabel *)[cell viewWithTag:102];
     UILabel *rhtLbl = (UILabel *)[cell viewWithTag:1001];
    specName.textColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:49.0/255.0 alpha:1.0];
    specName.font = [UIFont systemFontOfSize:14.0];
    specType.textColor = [UIColor lightGrayColor];
    specType.font = [UIFont systemFontOfSize:11.0];
    specType.text=[[homeArray valueForKey:@"ImageDescription"]objectAtIndex:indexPath.row];
    specName.text=[[homeArray valueForKey:@"ImageName"]objectAtIndex:indexPath.row];
    
    if (indexPath.row%2==0) {
        rhtLbl.hidden=NO;
    }
    else
        rhtLbl.hidden=YES;
    UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:100];
    //collectionImageView.image=[UIImage imageNamed:@"folder.png"];
    NSString *path=[[homeArray valueForKey:@"ImageUrl"]objectAtIndex:indexPath.row];

    [collectionImageView sd_setImageWithURL:[NSURL URLWithString:path]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    collectionImageView.contentMode = UIViewContentModeScaleAspectFit;
    collectionImageView.clipsToBounds = YES;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   // UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
//IdentityName
    NSString *IdentityName=[[homeArray valueForKey:@"IdentityName"]objectAtIndex:indexPath.row];;
    
    if ([IdentityName isEqualToString:@"OPD"]) {
        [Localytics tagEvent:@"HomeOPDClick"];
        PhysioVC *PhysioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhysioVC"];
        PhysioVC.specID = @"spec_9";
        PhysioVC.ProName = @"Interventional Cardiology";
        PhysioVC.ShowDataFor = @"Spec";
        [self.navigationController pushViewController:PhysioVC animated:YES];
    }
    else if ([IdentityName isEqualToString:@"Surgery"]) {
        [Localytics tagEvent:@"HomeSurgeryClick"];
        FindDocVC *findDoc = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_FindDoc"];
        [self.navigationController pushViewController:findDoc animated:YES];
    }
    else if ([IdentityName isEqualToString:@"Home Health"]) {
        [Localytics tagEvent:@"HomeHealthClick"];
        FreehealthServicesVC *FreehealthServicesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FreehealthServicesVC"];
        FreehealthServicesVC.viewController=@"homehealth";
        [self.navigationController pushViewController:FreehealthServicesVC animated:YES];
    }
    else if ([IdentityName isEqualToString:@"Free Health"]) {
        [Localytics tagEvent:@"HomeFreeHealthClick"];
        FreehealthServicesVC *FreehealthServicesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FreehealthServicesVC"];
        [self.navigationController pushViewController:FreehealthServicesVC animated:YES];
    }
    else if ([IdentityName isEqualToString:@"Radiology & Pathology"]) {
        [Localytics tagEvent:@"HomeRadio&PathClick"];
        GeneralDocBookingVC *DocBook = [self.storyboard instantiateViewControllerWithIdentifier:@"GeneralDocBookingVC"];
        DocBook.controllerName=@"radiology&pathology";
        [self.navigationController pushViewController:DocBook animated:YES];
    }
    else if ([IdentityName isEqualToString:@"EMR"]) {
        [Localytics tagEvent:@"HomeEMRClick"];
       MedicalRecordViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier: @"MedicalRecord"];
        vc.viewController=@"home";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([IdentityName isEqualToString:@"Doctor On Call"]){
        [Localytics tagEvent:@"HomeDocOnCallClick"];
        GeneralDocBookingVC *DocBook = [self.storyboard instantiateViewControllerWithIdentifier:@"GeneralDocBookingVC"];
        DocBook.controllerName=@"doctoroncall";
        [self.navigationController pushViewController:DocBook animated:YES];
    }

    else if ([IdentityName isEqualToString:@"Emergency"]){
        [Localytics tagEvent:@"HomeEmergencyClick"];
        FreehealthServicesVC *FreehealthServicesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FreehealthServicesVC"];
        FreehealthServicesVC.viewController=@"emergency";
        [self.navigationController pushViewController:FreehealthServicesVC animated:YES];
    }
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
   // UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
   
    
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = [UIScreen mainScreen].bounds.size.width / 2.0f;
    CGFloat ht = ([UIScreen mainScreen].bounds.size.height-112) / 4.0f;

    return CGSizeMake(picDimension, ht);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
        if (kind == UICollectionElementKindSectionHeader) {
            UICollectionReusableView *HeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            UILabel *nameLbl = (UILabel *)[HeaderView viewWithTag:102];
            nameLbl.text=[NSString stringWithFormat:@"Welcome %@",[userdef valueForKey:Username]];
           
            reusableview = HeaderView;
        }
    
    return reusableview;
}

-(void)getMedicalRecord{
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetMedicalRecords], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userdef objectForKey:User_id],User_id,nil];
    
    //    NSLog(@"dataDic for GetMedicalRecords: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetMedicalRecords;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
    //    NSLog(@"APICalling for GetMedicalRecords");
}


- (void) resultForGetMedicalRecord:(NSDictionary *)response
{
    //    NSLog(@"response = %@",response);
    
    if (currentRequestType==kGetMedicalRecords) {
        NSDictionary *MedicalReport=[response objectForKey:@"MedicalReport"];
        NSDictionary *SharedMedicalReport=[response objectForKey:@"SharedMedicalReport"];
        
        //  NSString *message=[response objectForKey:@"Message"];
        status=[[response objectForKey:@"Status"] integerValue];
        
        if (status == 0)
        {
            //            NSLog(@"On the find doctor Vc");
        }
        else if (status == 1)
        {
            // SyncDate = "11/10/2016 4:45:13 PM";
            [docOPDNetworkEngine sharedInstance].lastSyncTimeDateForAPI=[response objectForKey:@"SyncDate"];
            NSLog(@"Today formatted date is %@ userid %@",[docOPDNetworkEngine sharedInstance].lastSyncTimeDateForAPI,[userdef valueForKey:User_id]);
            NSMutableArray *AlbumDetail = [MedicalReport objectForKey:@"AlbumDetail"];
            NSMutableArray *SharedAlbumDetail = [SharedMedicalReport objectForKey:@"AlbumDetail"];
            BOOL medicalRecordsByDateFlag=[docOPDNetworkEngine sharedInstance].medicalRecordsByDateFlag;
            if (medicalRecordsByDateFlag) {
                [self saveAlbumInfo:AlbumDetail sharedAlbumInfo:SharedAlbumDetail];
                [docOPDNetworkEngine sharedInstance].medicalRecordsByDateFlag=NO;
            }
            
            
            //            for (int i=0; i<AlbumDetail.count; i++)
            //            {
            //                NSString *albumid =[[AlbumDetail objectAtIndex:i]valueForKey:@"AlbumId"];
            //                NSString *albumname =[[AlbumDetail objectAtIndex:i]valueForKey:@"AlbumName"];
            //                NSMutableArray *ImageTypeDetail =[[AlbumDetail objectAtIndex:i]valueForKey:@"ImageTypeDetail"];
            //                NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
            //                [temp setValue:albumid forKey:FolderID];
            //                [temp setValue:albumname forKey:FolderName];
            //                [temp setValue: ImageTypeDetail forKey:@"ImageTypeDetail"];
            //                [temp setValue:userid forKey:User_id];
            //                [folderDetails addObject:temp];
            //            }
        }
        else if (status == 10){
            userdef =userDefault;
            [userdef setObject:@"No" forKey:isLogin];
            ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_Login"];
            [self.navigationController pushViewController:login animated:YES];
        }
    }
}




-(void)saveAlbumInfo:(NSMutableArray*)albumInfo sharedAlbumInfo:(NSMutableArray*)sharedAlbumInfo{
    
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    NSDate *todayDate = [dateFormatter3 dateFromString:[docOPDNetworkEngine sharedInstance].lastSyncTimeDateForAPI];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d"];
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"hh:mm a"];
    NSString *convertedDateString1 = [dateFormatter1 stringFromDate:todayDate];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    NSString *convertedDateString2 = [dateFormatter2 stringFromDate:todayDate];
    NSLog(@"%@",convertedDateString2);
    
    [docOPDNetworkEngine sharedInstance].lastSyncTime=[NSString stringWithFormat:@"%@, at %@",convertedDateString,convertedDateString1];    // Prepare the query string.
    NSString *deleteFolderQuery = @"DELETE  FROM medicalFolder";
    [self.dbManager executeQuery:deleteFolderQuery];
    NSString *deleteRecordQuery = @"DELETE  FROM medicalRecord";
    [self.dbManager executeQuery:deleteRecordQuery];
    
    
    for (int i=0; i<albumInfo.count; i++)
    {
        NSString *albumid =[[albumInfo objectAtIndex:i]valueForKey:@"AlbumId"];
        NSString *albumname =[[albumInfo objectAtIndex:i]valueForKey:@"AlbumName"];
        NSMutableArray *ImageTypeDetail= [[NSMutableArray alloc]init];
        ImageTypeDetail =[[albumInfo objectAtIndex:i]valueForKey:@"ImageTypeDetail"];
        
        NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM medicalFolder WHERE album_name='%@'",albumname];
        // Get the results.
        if (self.albumFetch != nil) {
            self.albumFetch = nil;
        }
        self.albumFetch = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:selectQuery]];
        if (self.albumFetch == nil || [self.albumFetch count] == 0) {
            NSString *query = [NSString stringWithFormat:@"INSERT INTO medicalFolder (user_id,album_name,album_id) VALUES('%@', '%@','%@')",[userdef objectForKey:User_id],albumname,albumid];
            // Execute the query.
            [self.dbManager executeQuery:query];
            
            if (self.dbManager.affectedRows != 0)
            {
                //                NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
                if (![ImageTypeDetail isKindOfClass:[NSNull class]]) {
                    //                    NSLog(@"Enter in ImageTypeDetail is not null");
                    for (int j=0; j<ImageTypeDetail.count; j++) {
                        NSString *imgid = [ImageTypeDetail objectAtIndex:j][@"ImageId"];
                        NSString *imgtype = [ImageTypeDetail objectAtIndex:j][@"ImageType"];
                        NSString *caption=  [ImageTypeDetail objectAtIndex:j][@"ImageTag"];
                        NSString *imageName=  [ImageTypeDetail objectAtIndex:j][@"ImageName"];
                        imgtype = [imgtype stringByReplacingOccurrencesOfString:@"Medical" withString:@""];
                        NSString *imageUrl=  [ImageTypeDetail objectAtIndex:j][@"ImageUrl"];
                        NSString *query = [NSString stringWithFormat:@"INSERT INTO medicalRecord (user_id,album_name,upload_status,report_type,image_url,image_name,image_tag, image_id,album_id,image_download) VALUES('%@', '%@','%@','%@', '%@','%@' ,'%@','%@','%@','0')",[userdef objectForKey:User_id],albumname,@"1",imgtype,imageUrl?imageUrl:@"",imageName,caption?caption:@"",imgid?imgid:@"",albumid?albumid:@""];
                        // Execute the query.
                        [self.dbManager executeQuery:query];
                        
                        //  NSString *uniqueQuery=@"INSERT INTO medicalRecord select 'val' where not exists(select id from tbl where c_name ='val')";
                        
                        
                    }
                    
                }else{
                    //                    NSLog(@"Enter in ImageTypeDetail is null");
                }
            }
            else{
                //                NSLog(@"Could not execute the query  for medicalFolder.");
            }
        }
    }
    [self saveSharedAlbumInfo:sharedAlbumInfo];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"imgdwnldDn" object:nil];
    
}



-(void)saveSharedAlbumInfo:(NSMutableArray*)albumInfo{
    // Prepare the query string.
    NSString *deleteFolderQuery = @"DELETE  FROM sharedMedicalFolder";
    [self.dbManager executeQuery:deleteFolderQuery];
    NSLog(@"deleted  :  %d",self.dbManager.affectedRows);
    //    NSString *deleteRecordQuery = @"DELETE  FROM sharedMedicalRecord";
    //    [self.dbManager executeQuery:deleteRecordQuery];
    
    if ([albumInfo isKindOfClass:[NSNull class]]) {
        
    }
    else{
        for (int i=0; i<albumInfo.count; i++)
        {
            NSString *albumid =[[albumInfo objectAtIndex:i]valueForKey:@"AlbumId"];
            NSString *albumname =[[albumInfo objectAtIndex:i]valueForKey:@"AlbumName"];
            NSMutableArray *ImageTypeDetail= [[NSMutableArray alloc]init];
            ImageTypeDetail =[[albumInfo objectAtIndex:i]valueForKey:@"ImageTypeDetail"];
            
            NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM sharedMedicalFolder WHERE album_name='%@'",albumname];
            NSLog(@"selectQuery");
            // Get the results.
            if (self.sharedAlbumFetch != nil) {
                self.sharedAlbumFetch = nil;
            }
            self.sharedAlbumFetch = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:selectQuery]];
            if (self.sharedAlbumFetch == nil || [self.sharedAlbumFetch count] == 0) {
                NSString *query = [NSString stringWithFormat:@"INSERT INTO sharedMedicalFolder (user_id,album_name,album_id) VALUES('%@', '%@','%@')",[userdef objectForKey:User_id],albumname,albumid];
                // Execute the query.
                [self.dbManager executeQuery:query];
                NSLog(@"%d",self.dbManager.affectedRows);
                
                if (self.dbManager.affectedRows != 0)
                {
                    //                NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
                    if (![ImageTypeDetail isKindOfClass:[NSNull class]]) {
                        //                    NSLog(@"Enter in ImageTypeDetail is not null");
                        for (int j=0; j<ImageTypeDetail.count; j++) {
                            NSString *imgid = [ImageTypeDetail objectAtIndex:j][@"ImageId"];
                            NSString *imgtype = [ImageTypeDetail objectAtIndex:j][@"ImageType"];
                            NSString *caption=  [ImageTypeDetail objectAtIndex:j][@"ImageTag"];
                            NSString *imageName=  [ImageTypeDetail objectAtIndex:j][@"ImageName"];
                            imgtype = [imgtype stringByReplacingOccurrencesOfString:@"Medical" withString:@""];
                            NSString *imageUrl=  [ImageTypeDetail objectAtIndex:j][@"ImageUrl"];
                            NSString *query = [NSString stringWithFormat:@"INSERT INTO medicalRecord (user_id,album_name,upload_status,report_type,image_url,image_name,image_tag, image_id,album_id,image_download) VALUES('%@', '%@','%@','%@', '%@','%@' ,'%@','%@','%@','0')",[userdef objectForKey:User_id],albumname,@"1",imgtype,imageUrl?imageUrl:@"",imageName,caption?caption:@"",imgid?imgid:@"",albumid?albumid:@""];
                            // Execute the query.
                            [self.dbManager executeQuery:query];
                            
                            //  NSString *uniqueQuery=@"INSERT INTO medicalRecord select 'val' where not exists(select id from tbl where c_name ='val')";
                            
                            
                        }
                    }else{
                        //                    NSLog(@"Enter in ImageTypeDetail is null");
                    }
                }
                else{
                    //                NSLog(@"Could not execute the query  for medicalFolder.");
                }
            }
        }
        
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"imgdwnldDn" object:nil];
    
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

- (void) requestError
{
    //    NSLog(@"RegisterViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
    [self ViewSlideDown:@"Something went wrong"];

}
- (void) requestFinished:(NSDictionary * )responseData
{
    if (currentRequestType==kGetMedicalRecords) {
        
        [self performSelector:@selector(resultForGetMedicalRecord:) withObject:responseData afterDelay:.000];
        
    }
    
}
#pragma mark UITextFieldDelegate methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField ==self.referTXT)
    {
        NSUInteger newLength = [self.referTXT.text length] + [string length] - range.length;
        return newLength <= 6;
    }
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
}


- (IBAction)submitAction:(id)sender {
     [Localytics tagEvent:@"submit"];
    BOOL isvalid=[self CheckForValidation];
    if (isvalid)
    {
        if ([AppDelegate MyappDelegate].isInternet)
        {
            [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:@"Referal code is \n submitting"];
            [[docOPDNetworkEngine sharedInstance]SetUserReferenceAPI:[userdef valueForKey:User_id] referenceCode:self.referTXT.text withCallback:^(NSDictionary *responseData) {
                NSArray *responce=[responseData objectForKey:@"Reference Status"];
                NSInteger referStatus=[[responce valueForKey:@"Status"] intValue];
                NSString* msg=[responce valueForKey:@"Message"];
                [[AppDelegate MyappDelegate] hideIndicator];
                
                if (referStatus==0) {
                   [self ViewSlideDown:msg];
                }
                else if (referStatus==1){
                      [self success:AppName detailMessage:@"successful"];
                     [self performSelector:@selector(skipAction:) withObject:nil afterDelay:0.0];
                }
                else if (referStatus==2){
                    [self ViewSlideDown:msg];
                }
                else if (referStatus==3){
                    [self ViewSlideDown:msg];
                }
                /*
                 "Reference Status" =     {
                 Message = "Reference code is not valid";
                 Status = 0;
                 };
                 */
            }];

            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Either server is too busy or check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
            [alert show];
            
        }
    }

}

- (IBAction)skipAction:(id)sender {
    [self.view endEditing:YES];
    [userdef setObject:@"Yes" forKey:@"IsReferenced"];
    [userdef synchronize];
    [UIView transitionWithView:self.referalView
                      duration:3.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.referalView.hidden = YES;
                    }
                    completion:NULL];
   
}

-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    if (([self.referTXT.text isEqualToString:@""]&& [self.referTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])){
        valid = NO;
        
        [self ViewSlideDown:@"Please enter referal code"];
    }
    
    return valid;
}
- (void)success:(NSString*)title detailMessage:(NSString*)detail {
    [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:title detail:detail cancelButton:nil Okbutton:nil block:^(HHAlertButton buttonindex) {
        if (buttonindex == HHAlertButtonOk) {
            //            NSLog(@"ok Button is seleced use block");
            
        }
        else
        {
            //            NSLog(@"cancel Button is seleced use block");
            
        }
    }];
}

@end
