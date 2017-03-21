//
//  MedicalRecordViewController.m
//  docOPD
//
//  Created by Virinchi Software on 1/23/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "MedicalRecordViewController.h"
#import "SubFolderViewController.h"
#import "HDNotificationView.h"
#import "HHAlertView.h"
#import "ContactVC.h"
#import "MedicalRecordDetailVC.h"


@interface MedicalRecordViewController ()

@end

@implementation MedicalRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        CGSize resulation = [[UIScreen mainScreen] bounds].size;
        
      if (resulation.height <= 568) {
            // 4 inch display - iPhone 5
            NSLog(@"Device is an iPhone 5/S/C");
            self.tipsImageView.image=[UIImage imageNamed:@"emr_5.png"];
        }
        
        else if (resulation.height == 667) {
            // 4.7 inch display - iPhone 6
            NSLog(@"Device is an iPhone 6");//splashPhone6
            self.tipsImageView.image=[UIImage imageNamed:@"emr_6.png"];
        }
        
        else if (resulation.height >= 736) {
            // 5.5 inch display - iPhone 6 Plus
            NSLog(@"Device is an iPhone 6 Plus");
            self.tipsImageView.image=[UIImage imageNamed:@"emr_6s.png"];
            
        }
    }

    
    
    
    sectionIdentity=@"";
    if ([self.viewController isEqualToString:@"home"]) {
        [self.menuBtn setImage:[UIImage imageNamed:@"nav-back.png"] forState:UIControlStateNormal];
    }
    else{
        [self.menuBtn setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    }

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
         result = [[UIScreen mainScreen] bounds].size;
        
           }
    
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // iPad 9.7 or 7.9 inch display.
        NSLog(@"Device is an iPad.");
        
    }
    
    self.syncLbl.text=[NSString stringWithFormat:@"Last Sync : %@",[docOPDNetworkEngine sharedInstance].lastSyncTime];
    userdef = userDefault;
    
    self.titleLbl.text=@"Medical Record";
    selectedAlubID=@"";
    selectedAlbum = [NSMutableArray array];
    [self createDirectory:@"MedicalRecord"];
    ArrFolderDetails = [[NSMutableArray alloc]init];
    DicFolderDetails = [[NSMutableDictionary alloc]init];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    indexNumber =0;
    isIndicatorShow = false;
    
    isSyncTapped = NO;
    // [self setupErrorview];
    
    if (!self.FetchedData || self.FetchedData.count==0) {
        //        NSLog(@"No record found.");
        [self deactivateButton:self.BtnSync];
    }else [self createThumbView];
}



-(void)GetArray{
    NSError *error;
    NSString *localpath = [NSString stringWithFormat:@"%@/",[[AppDelegate MyappDelegate]medicalRecordPath]];
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localpath error:&error];
    ArrAllFolder = paths.mutableCopy;
    //   [self.collectionView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"MedicalRecordScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    isSyncTapped = NO;
    [self activateButton:self.BtnSync];
    [Localytics tagEvent:@"MedicalRecordScreen"];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    //    indexNumber =0;
    //   isIndicatorShow = false;
    //    [self loadData];
    isSyncTapped = NO;
    
    if (!self.FetchedData || self.FetchedData.count==0) {
        //        NSLog(@"No record found.");
        [self deactivateButton:self.BtnSync];
    }else{
        // [self createThumbView];
        
        NSString *query = [NSString stringWithFormat:@"SELECT rowid,upload_image, image_name, report_type, album_name,image_id,image_tag FROM medicalRecord WHERE user_id='%@' AND upload_status='0'",[userdef valueForKey:User_id]];
        //        NSLog(@"Fetch Query: %@",query);
        // Get the results.
        if (self.SyncData != nil) {
            self.SyncData = nil;
        }
        self.SyncData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        if (!self.SyncData || self.SyncData.count==0) {
            //            NSLog(@"No record found.");
            [self deactivateButton:self.BtnSync];
        }
        
    }
    
}
- (BOOL)canBecomeFirstResponder {
    return true;
}

- (IBAction)didPressAddButton:(id)sender {
    self.tipsImageView.hidden=YES;
    [Localytics tagEvent:@"MedicalRecordAddAlbumClick"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Create New Album" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alert.textFields[0];
        AlbumName = textField.text;
        NSString *emailRegex = @"[a-zA-z]+([ '-][a-zA-Z]+)*$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL isValid = [emailTest evaluateWithObject:AlbumName];
        if (!isValid) {
            [self errorWithTitle:@"" detailMessage:@"Please enter valid folder name"];
        }
        else{
            DicFolderDetails = [[NSMutableDictionary alloc]init];
            AlbumName = [self RemoveLeadingAndTrailingSpace:AlbumName];
            if (![AlbumName isEqualToString:@""]) {
                if ([self findDirectory:AlbumName]) {
                    //                [DicFolderDetails setObject:AlbumName forKey:FolderName];
                    //                [ArrFolderDetails addObject:DicFolderDetails];
                    
                    //                NSString *medicalDir = [NSString stringWithFormat:@"MedicalRecord/%@",AlbumName];
                    //[self createDirectory:medicalDir];
                    [self saveInfo];
                 //   [self loadData];
                    [self.collectionView reloadData];
                    [self.sharedCollectionView reloadData];

                    [self createThumbView];
                }else{
                    [textField resignFirstResponder];
                    [self showalert:@"Folder already exist"];
                }
            }else{
                [self showalert:@"Write valid folder name"];
            }
        }
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //        NSLog(@"Cancel pressed");
       

    }]];
    
  [self presentViewController: alert animated: YES completion:^{
         alert.view.superview.userInteractionEnabled = YES;
         [alert.view.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(DismissAlertByTab)]];
     }];
    //[self presentViewController:alert animated:YES completion:nil];
    
}
- (void)DismissAlertByTab
{
    [self dismissViewControllerAnimated:YES completion: nil];
}
- (void)errorWithTitle:(NSString*)title detailMessage:(NSString*)detail {
    [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:title detail:detail cancelButton:nil Okbutton:nil];
}

-(void)showalert:(NSString *)msg{
    UIAlertController *alerts = [UIAlertController alertControllerWithTitle:AppName message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [alerts addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alerts animated:YES completion:nil];
}

#pragma mark - SlideNavigationController Methods

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    if ([self.viewController isEqualToString:@"home"]) {
        return NO;
    }
    else
        return YES;
}

- (IBAction)didPressMenu:(id)sender {
    if ([self.viewController isEqualToString:@"home"]) {
        [Localytics tagEvent:@"MedicalRecordHomeClick"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [Localytics tagEvent:@"MedicalRecordSideBarMenuClick"];
        static Menu menu = MenuLeft;
        [[SlideNavigationController sharedInstance] toggleMenu:menu withCompletion:nil];
    }

}


-(void)GetData{
    
    ArrFolderDetails  = self.FetchedData.mutableCopy;
    
}

- (void)createThumbView
{
    //    [self.ContentView removeFromSuperview];
    //    [self.Scroller addSubview:self.ContentView];
    
    for (UIView *subView in self.ContentView.subviews)
    {
        
        [subView removeFromSuperview];
        
    }
    
    float y_axis = 10;
    int x = 0;
    float width= [UIScreen mainScreen].bounds.size.width/3-20;
    float height = width;
    
    //    NSLog(@"section height : %f, width= %f",height, width);
    //int totalImgs = (int)[ArrFolderDetails count];
    int totalImgs = (int)[self.FetchedData count];
    int tempCnt = 0;
    
    for (int i = 0; i < totalImgs;)
    {
        //        float x_axis = 10;
        float x_axis =(width-30.0)/2;
        x_axis = 10;
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
            UIView *FolderView = [[UIView alloc]initWithFrame:CGRectMake(x_axis, y_axis,width, height)];
            
            FolderView.tag = x;
            
            [self.ContentView addSubview: FolderView];
            
            FolderImg = [[UIImageView alloc]initWithFrame:CGRectMake((FolderView.frame.size.width-50)/2,((FolderView.frame.size.height-50)/2)-10,50,50)];
            // [FolderImg setImage:[UIImage imageNamed:@"folderTricked.png"]];
            
            [FolderImg setImage:[UIImage imageNamed:@"folder.png"]];
            [FolderView addSubview:FolderImg];
            
            UILabel *albumName = [[UILabel alloc]initWithFrame:CGRectMake(2, FolderImg.frame.size.height + FolderImg.frame.origin.y,width-4, 15)];
            //albumName.text = [ArrFolderDetails objectAtIndex:x][FolderName];
            albumName.text = [[self.FetchedData objectAtIndex:x]objectAtIndex:0];
            // [selectedRecipes addObject:[[self.FetchedData objectAtIndex:x]objectAtIndex:1]];
            //            if (x>0) {
            //                selectedAlubID=[selectedAlubID stringByAppendingString:[NSString stringWithFormat:@",%@",[[self.FetchedData objectAtIndex:x]objectAtIndex:1]]];
            //            }
            //            else{
            //                selectedAlubID=[[self.FetchedData objectAtIndex:x]objectAtIndex:1];
            //            }
            albumName.tag = 100;
            albumName.textColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:49.0/255.0 alpha:1.0];
            albumName.font = [UIFont systemFontOfSize:11.0];
            CGRect Oldframe = albumName.frame;
            albumName.numberOfLines =2;
            albumName.lineBreakMode = NSLineBreakByTruncatingTail;
            albumName.textAlignment = NSTextAlignmentCenter;
            [albumName sizeToFit];
            CGRect Newframe = albumName.frame;
            Newframe.size.width = Oldframe.size.width;
            albumName.frame = Newframe;
            albumName.textAlignment = NSTextAlignmentCenter;
            [FolderView addSubview:albumName];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]init];
            [FolderView addGestureRecognizer:tapGesture];
            [tapGesture addTarget:self action:@selector(openFolder:)];
            //photoCount++;
            x_axis += width+10;
            
            
            
            tempCnt++;
            i++;
            x++;
            
        }
        
        y_axis += height;
        CGRect MoreSc = self.ContentView.frame;
        MoreSc.size.height = y_axis;
        self.ContentView.frame = MoreSc;
        
    }
    
    
    [self scrollResizer];
}


-(void)openFolder:(UITapGestureRecognizer*)tap{
    
    if (shareEnabled) {
        [self createThumbView];
    }
    else{
        [Localytics tagEvent:@"Open folder"];
        SubFolderViewController *SFVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SubFolderVC"];
        //   SFVC.parentFolder =[ArrFolderDetails objectAtIndex:tap.view.tag][FolderName];
        SFVC.parentFolder =[[self.FetchedData objectAtIndex:tap.view.tag]objectAtIndex:0];
        //        procedureListVC.specID = [ArrFolderDetails objectAtIndex:tap.view.tag][@"FolderId"];
        //        procedureListVC.ProName = [sortedArray objectAtIndex:tap.view.tag][@"FolderName"];
        //        procedureListVC.ShowDataFor = @"Spec";
        SFVC.folderid = [[self.FetchedData objectAtIndex:tap.view.tag]objectAtIndex:1];
        [self.navigationController pushViewController:SFVC animated:YES];
        
    }
    
}
-(BOOL)getAllDirectory:(NSString*)DirName{
    BOOL valid = true;
    NSError *error;
    NSString *localpath = [NSString stringWithFormat:@"%@/",[[AppDelegate MyappDelegate]medicalRecordPath]];
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localpath error:&error];
    for (int i=0; i<paths.count; i++) {
        if ([[paths objectAtIndex:i]isEqualToString:DirName]) {
            valid = false;
            break;
        }
    }
    return valid;
}

-(BOOL)findDirectory:(NSString*)DirName{
    BOOL valid = true;
    for (int i=0; i<self.FetchedData.count; i++) {
        if ([[[self.FetchedData objectAtIndex:i]objectAtIndex:0] isEqualToString:DirName]) {
            valid = false;
            break;
        }
    }
    return valid;
}




-(void)scrollResizer{
    self.Scroller.contentSize = CGSizeMake(self.Scroller.frame.size.width, self.ContentView.frame.size.height);
}

-(void) createDirectory : (NSString *) dirName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    if ([dirName isEqualToString:@"MedicalRecord"])
    {
        
        [AppDelegate MyappDelegate].medicalRecordPath =(NSMutableString *)[documentsDirectory stringByAppendingPathComponent:dirName];
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:[AppDelegate MyappDelegate].medicalRecordPath withIntermediateDirectories:NO attributes:nil error:&error]) {
            //            NSLog(@"Couldn't create directory error: %@", error);
        }
        else {
            //            NSLog(@"directory created!");
            
        }
        
    }else{
        dataPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:dirName];
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]) {
            //            NSLog(@"Couldn't create directory error: %@", error);
        }
        else {
            //            NSLog(@"directory created!");
        }
    }
    
    //    NSLog(@"dataPath : %@ ",dataPath); // Path of folder created
    if (![dirName isEqualToString:@"MedicalRecord"])
    {
        for (int i=0; i<3; i++) {
            switch (i) {
                case 0:
                    [self createSubDirectory:[NSString stringWithFormat:@"%@/Imagine",dirName]];
                    break;
                case 1:
                    [self createSubDirectory:[NSString stringWithFormat:@"%@/Pathology",dirName]];
                    break;
                case 2:
                    [self createSubDirectory:[NSString stringWithFormat:@"%@/Prescription",dirName]];
                    
                default:
                    break;
            }
        }
    }
}

-(void) createSubDirectory : (NSString *)dirName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    dataPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:dirName];
    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]) {
        //        NSLog(@"Couldn't create directory error: %@", error);
    }
    else {
        //        NSLog(@"directory created!");
    }
    //    NSLog(@"dataPath : %@ ",dataPath); // Path of folder created
    
}

-(void)deleteAlbum{
    //DELETE FROM COMPANY WHERE ID = 7;
    for (int albumID=0; albumID<[selectedAlbum count]; albumID++) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM medicalFolder WHERE album_id='%@'",[selectedAlbum objectAtIndex:albumID]];
        [self.dbManager executeQuery:query];
        [self.shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [self.deleteBtn setImage:[UIImage imageNamed:@"dustbin.png"] forState:UIControlStateNormal];

        // If the query was successfully executed then pop the view controller.
        // if (self.dbManager.affectedRows != 0){
        [self loadData];
        
        // }
        
    }
    
}
-(void)deleteSharedAlbum{
    //DELETE FROM COMPANY WHERE ID = 7;
    for (int albumID=0; albumID<[selectedAlbum count]; albumID++) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM sharedMedicalFolder WHERE album_id='%@'",[selectedAlbum objectAtIndex:albumID]];
        [self.dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        // if (self.dbManager.affectedRows != 0){
        [self loadData];
        
        // }
        
    }
    
}

- (void)saveInfo{
    // Prepare the query string.
    NSString *folId = [userdef objectForKey:FolderID];
    NSString *query = [NSString stringWithFormat:@"INSERT INTO medicalFolder (user_id,album_name,album_id) VALUES('%@','%@','%@')",[userdef objectForKey:User_id],AlbumName,folId];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        //        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        NSInteger folid = folId.integerValue+1;
        [userdef setObject:[NSString stringWithFormat:@"%ld",(long)folid] forKey:FolderID];
        [self loadData];
        [self.collectionView reloadData];
        [self.sharedCollectionView reloadData];

    }
    else{
        //        NSLog(@"Could not execute the query.");
    }
}


-(void)loadData{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT DISTINCT album_name,album_id FROM medicalFolder WHERE user_id='%@'",[userdef valueForKey:User_id]];
    
    // Get the results.
    if (self.FetchedData != nil) {
        self.FetchedData = nil;
    }
    self.FetchedData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    //shared Data
    NSString *sharedQuery = [NSString stringWithFormat:@"SELECT DISTINCT album_name,album_id FROM sharedMedicalFolder WHERE user_id='%@'",[userdef valueForKey:User_id]];
    
    // Get the results.//sharedFetchedData
    if (self.sharedFetchedData != nil) {
        self.sharedFetchedData = nil;
    }
    self.sharedFetchedData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:sharedQuery]];
    [self.collectionView reloadData];
    [self.sharedCollectionView reloadData];
    if (self.FetchedData.count==0 && self.sharedFetchedData.count==0 ) {
        self.editBtn.hidden=YES;
        self.tipsImageView.hidden=NO;
        self.tipsBtn.hidden=NO;
    }
    else{
        self.tipsBtn.hidden=YES;
        self.tipsImageView.hidden=YES;
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


- (IBAction)didPressSyncButton:(UIButton*)sender {
    [Localytics tagEvent:@"MedicalRecordSyncButtonClick"];
    self.tipsImageView.hidden=YES;
    if (!isSyncTapped) {
        NSDate *todayDate = [NSDate date]; // get today date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM d"];
        NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"hh:mm a"];
        NSString *convertedDateString1 = [dateFormatter1 stringFromDate:todayDate];
        
        [docOPDNetworkEngine sharedInstance].lastSyncTime=[NSString stringWithFormat:@"%@, at %@",convertedDateString,convertedDateString1];
        self.syncLbl.text=[NSString stringWithFormat:@"Last Sync : %@",[docOPDNetworkEngine sharedInstance].lastSyncTime];
        
        isSyncTapped = YES;
        NSString *query = [NSString stringWithFormat:@"SELECT rowid,upload_image, image_name, report_type, album_name,image_id,image_tag FROM medicalRecord WHERE user_id='%@' AND upload_status='0'",[userdef valueForKey:User_id]];
        //        NSLog(@"Fetch Query: %@",query);
        // Get the results.
        if (self.SyncData != nil) {
            self.SyncData = nil;
        }
        self.SyncData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        if (!self.SyncData || self.SyncData.count==0) {
            //             NSLog(@"Database have not record. %@",self.SyncData);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"There is nothing to Sync." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:OK];
            [self presentViewController:alert animated:YES completion:nil];
            isSyncTapped = NO;
            
        }else{
            //            NSLog(@"Database have record. %@",self.SyncData);
            [self ViewSlideDown:@"Synchronization is in progress."];
            [self deactivateButton:sender];
            [[AppDelegate MyappDelegate]fetchDataFromDB];
        }
    }
    else{
        [self getMedicalRecordByDate];
    }
}
-(void)getMedicalRecordByDate{
    
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    NSDate *todayDate = [dateFormatter3 dateFromString:[docOPDNetworkEngine sharedInstance].lastSyncTimeDateForAPI]; // get today date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"MMM d"];
    NSString *convertedDateString2 = [dateFormatter2 stringFromDate:todayDate];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"hh:mm a"];
    NSString *convertedDateString1 = [dateFormatter1 stringFromDate:todayDate];
    
    
    [docOPDNetworkEngine sharedInstance].lastSyncTime=[NSString stringWithFormat:@"%@, at %@",convertedDateString2,convertedDateString1];
    
    NSLog(@"Today formatted date is %@ userid %@",[docOPDNetworkEngine sharedInstance].lastSyncTimeDateForAPI,[userdef valueForKey:User_id]);
    
    if ([AppDelegate MyappDelegate].isInternet)
    {
        [[docOPDNetworkEngine sharedInstance]GetMedicalRecordsByDateAPI:[userdef valueForKey:User_id] date:[docOPDNetworkEngine sharedInstance].lastSyncTimeDateForAPI withCallback:^(NSDictionary *response) {
            
            recordStatus=[[response objectForKey:@"Status"] integerValue];
            
            if (recordStatus == 7)
            {
                [self ViewSlideDown:@"No data for synchronization."];
                // [self loadData];
                //            NSLog(@"no record");
            }
            else if (recordStatus == 1)
            {
                 [docOPDNetworkEngine sharedInstance].lastSyncTimeDateForAPI=[response objectForKey:@"SyncDate"];
               // [docOPDNetworkEngine sharedInstance].lastSyncTimeDateForAPI=convertedDateString;
                self.syncLbl.text=[NSString stringWithFormat:@"Last Sync : %@",[docOPDNetworkEngine sharedInstance].lastSyncTime];
                
                [self ViewSlideDown:@"Synchronization is in progress."];
                NSDictionary *MedicalReport=[response objectForKey:@"MedicalReport"];
                NSDictionary *SharedMedicalReport=[response objectForKey:@"SharedMedicalReport"];
                NSMutableArray *AlbumDetail = [MedicalReport objectForKey:@"AlbumDetail"];
                NSMutableArray *SharedAlbumDetail = [SharedMedicalReport objectForKey:@"AlbumDetail"];
                [self saveAlbumInfo:AlbumDetail sharedAlbumInfo:SharedAlbumDetail];
                
            }
            else if (recordStatus == 10){
                userdef =userDefault;
                [userdef setObject:@"No" forKey:isLogin];
                ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_Login"];
                [self.navigationController pushViewController:login animated:YES];
            }
            
        }];

    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Either server is too busy or check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
        //            alert.tag = kTAGWiFiAlert;
        [alert show];
        
        
    }

}

-(void)deactivateButton:(UIButton*)sender{
    isSyncTapped = true;
   // [sender setBackgroundColor:[UIColor colorWithRed:185.0/255.0 green:185.0/255.0 blue:185.0/255.0 alpha:1.0]];
   // [sender setTitleColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    sender.enabled = true;
}

-(void)activateButton:(UIButton*)sender{
    isSyncTapped = false;
  //  [sender setBackgroundColor:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0]];
   // [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.enabled = true;
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



- (IBAction)deleteBtnAction:(id)sender {
    [Localytics tagEvent:@"MedicalRecordDeleteButtonClick"];
    if (shareActive) {
        
        if ([sectionIdentity isEqualToString:@"1"]) {
            //RemoveAlbumSharingAPI
            [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:[NSString stringWithFormat:@"Unsharing selected Album"]];
            [[docOPDNetworkEngine sharedInstance]RemoveAlbumSharingAPI:[userdef valueForKey:Mobile]  AlbumId:selectedAlubID withCallback:^(NSDictionary *responseData) {
                self.BtnSync.hidden=NO;
                 self.syncLbl.hidden=NO;
                //[self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];//edit-button.png
                [self.editBtn setImage:[UIImage imageNamed:@"edit-button.png"] forState:UIControlStateNormal];
                
                shareEnabled = NO;
                shareActive=NO;
                self.collectionView.allowsMultipleSelection = NO;
                [self deleteSharedAlbum];
                [self.collectionView reloadData];
                [self.sharedCollectionView reloadData];
                [selectedAlbum removeAllObjects];
                self.sharedCollectionView.userInteractionEnabled=YES;
                self.collectionView.userInteractionEnabled=YES;
                [[AppDelegate MyappDelegate] hideIndicator];
                self.titleLbl.text = @"Medical Record";
            }];
            
        }
        else{
            [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:[NSString stringWithFormat:@"Deleting selected Album"]];
            [[docOPDNetworkEngine sharedInstance]DeleteMultipleAlbumAPI:selectedAlubID withCallback:^(NSDictionary *responseData) {
                self.BtnSync.hidden=NO;
                self.syncLbl.hidden=NO;
                //  [self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
                [self.editBtn setImage:[UIImage imageNamed:@"edit-button.png"] forState:UIControlStateNormal];
                
                shareEnabled = NO;
                shareActive=NO;
                self.collectionView.allowsMultipleSelection = NO;
                self.sharedCollectionView.userInteractionEnabled=YES;
                self.collectionView.userInteractionEnabled=YES;
                [self deleteAlbum];
                [self.collectionView reloadData];
                [selectedAlbum removeAllObjects];
                [[AppDelegate MyappDelegate] hideIndicator];
                self.titleLbl.text = @"Medical Record";
            }];
            
        }
    }
}

- (IBAction)editBtnAction:(id)sender {
    [Localytics tagEvent:@"MedicalRecordEditButtonClick"];
    selectedAlubID=@"";
    [selectedAlbum removeAllObjects];
    if (shareEnabled) {
        self.syncLbl.hidden=NO;
        self.BtnSync.hidden=NO;
        //[self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
        [self.editBtn setImage:[UIImage imageNamed:@"edit-button.png"] forState:UIControlStateNormal];
        
        shareEnabled = NO;
        self.collectionView.allowsMultipleSelection = NO;
        [self.collectionView reloadData];
        self.sharedCollectionView.allowsMultipleSelection = NO;
        [self.sharedCollectionView reloadData];
        self.titleLbl.text = @"Medical Record";
    }
    else{
        self.syncLbl.hidden=YES;
        self.titleLbl.text = @"Select Items";
        self.BtnSync.hidden=YES;
        //[self.editBtn setTitle:@"Cancel" forState:UIControlStateNormal];//white-cancel.png
        [self.editBtn setImage:[UIImage imageNamed:@"white-cancel.png"] forState:UIControlStateNormal];
        shareEnabled = YES;
        self.collectionView.allowsMultipleSelection = YES;
        [self.collectionView reloadData];
        self.sharedCollectionView.allowsMultipleSelection = YES;
        [self.sharedCollectionView reloadData];
    }
}

- (IBAction)shareBtnAction:(id)sender {
    [Localytics tagEvent:@"MedicalRecordShareButtonClick"];
    
    if (shareActive) {
        self.sharedCollectionView.userInteractionEnabled=YES;
        self.collectionView.userInteractionEnabled=YES;
        self.syncLbl.hidden=NO;
        self.BtnSync.hidden=NO;
        //[self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
        [self.editBtn setImage:[UIImage imageNamed:@"edit-button.png"] forState:UIControlStateNormal];
        
        shareEnabled = NO;
        shareActive=NO;
        self.collectionView.allowsMultipleSelection = NO;
        [self.collectionView reloadData];
        self.sharedCollectionView.allowsMultipleSelection = NO;
        [self.sharedCollectionView reloadData];
        self.titleLbl.text = @"Medical Record";
        // ContactVC
        ContactVC *contactVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactVC"];
        contactVC.controllerName=@"MedicalRecord";
        contactVC.id=selectedAlubID;
        [self.navigationController pushViewController:contactVC animated:YES];
    }
    
}

#pragma Collection view

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    // return ArrImage.count;
    NSInteger fetchDataCount=[self.FetchedData count];
    NSInteger sharedDataCount=[self.sharedFetchedData count];

    if (result.height == 480) {
        NSLog(@"Device is an iPhone 4S or below");
        if (collectionView==self.collectionView) {
            self.sharedCollviewTop.constant=20;
            [self.view layoutIfNeeded];

            if (fetchDataCount<=3) {
                self.loadRecordBtn.hidden=YES;
                self.sharedCollviewTop.constant=0;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>3 && fetchDataCount<7 && sharedDataCount<=3){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=220;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>6 && fetchDataCount<10 && sharedDataCount==0){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=310;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>9 && sharedDataCount==0){
                self.loadRecordBtn.hidden=NO;
                self.sharedCollviewTop.constant=55;
                [self.view layoutIfNeeded];

                self.collViewHT.constant=310;
                return self.FetchedData.count;
            }
            else{
                self.loadRecordBtn.hidden=NO;
                return self.FetchedData.count;
            }
            
        }
        else{
            if (sharedDataCount<=3) {
                self.loadSharedRecordBtn.hidden=YES;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>3 && sharedDataCount<7 && fetchDataCount<=3 ){
                self.loadSharedRecordBtn.hidden=YES;
                self.sharedCollViewHT.constant=220;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>6  && fetchDataCount<=3){
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=220;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>9 && fetchDataCount==0){
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=310;
                return self.sharedFetchedData.count;
            }
            else{
                self.sharedCollviewTop.constant=30;
                self.sharedCollViewHT.constant=130;
                self.loadSharedRecordBtn.hidden=NO;
                return self.sharedFetchedData.count;
            }
            
        }

    }
    
    else if (result.height == 568) {
        NSLog(@"Device is an iPhone 5/S/C");
        if (collectionView==self.collectionView) {
            self.sharedCollviewTop.constant=20;
            [self.view layoutIfNeeded];

            if (fetchDataCount<=3) {
                self.loadRecordBtn.hidden=YES;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>3 && fetchDataCount<7 ){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=220;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>6 && fetchDataCount<10 && sharedDataCount<=3){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=310;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>6 && fetchDataCount<10 && sharedDataCount>3){
                self.loadRecordBtn.hidden=NO;
                self.sharedCollviewTop.constant=55;
                [self.view layoutIfNeeded];
                self.collViewHT.constant=220;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>9 && fetchDataCount<13  && sharedDataCount==0){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=400;
                return self.FetchedData.count;
            }
            
            else if (fetchDataCount>12  && sharedDataCount==0){
                self.loadRecordBtn.hidden=NO;
                self.collViewHT.constant=400;
                return self.FetchedData.count;
            }
            
            else{
                self.loadRecordBtn.hidden=NO;
                self.collViewHT.constant=130;
                return self.FetchedData.count;
            }
            
        }
        else{
            if (sharedDataCount<=3) {
                self.loadSharedRecordBtn.hidden=YES;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>3 && sharedDataCount<7  && fetchDataCount<=3){
                self.loadSharedRecordBtn.hidden=YES;
                self.sharedCollViewHT.constant=220;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>3 && sharedDataCount<7 && fetchDataCount>3){
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=130;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>6 && sharedDataCount<10 && fetchDataCount<=3){
                self.loadSharedRecordBtn.hidden=YES;
                self.sharedCollViewHT.constant=310;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>9  && fetchDataCount<=3){
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=310;
                return self.sharedFetchedData.count;
            }
            
            else if (sharedDataCount>12  && fetchDataCount==0){
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=310;
                return self.sharedFetchedData.count;
            }
            else{
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=130;
                return self.sharedFetchedData.count;
            }
            
        }

    }
    
    else if (result.height == 667) {
         NSLog(@"Device is an iPhone 6");
        if (collectionView==self.collectionView) {
            self.sharedCollviewTop.constant=20;
            [self.view layoutIfNeeded];

            if (fetchDataCount<=3) {
                self.loadRecordBtn.hidden=YES;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>3 && fetchDataCount<7){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=220;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>6 && fetchDataCount<10 && sharedDataCount<=3){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=310;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>6 && fetchDataCount<10 && sharedDataCount>3){
                self.loadRecordBtn.hidden=NO;
                self.sharedCollviewTop.constant=55;
                [self.view layoutIfNeeded];

                self.collViewHT.constant=220;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>9 && fetchDataCount<13  && sharedDataCount==0){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=400;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>12 && fetchDataCount<16  && sharedDataCount==0){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=490;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>15  && sharedDataCount==0){
                self.loadRecordBtn.hidden=NO;
                self.collViewHT.constant=490;
                return self.FetchedData.count;
            }

            else{
                self.sharedCollviewTop.constant=55;
                [self.view layoutIfNeeded];

                self.loadRecordBtn.hidden=NO;
                self.collViewHT.constant=130;
                return self.FetchedData.count;
            }
            
        }
        else{
            if (sharedDataCount<=3) {
                self.loadSharedRecordBtn.hidden=YES;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>3 && sharedDataCount<7){
                self.loadSharedRecordBtn.hidden=YES;
                self.sharedCollViewHT.constant=220;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>6 && sharedDataCount<10 && fetchDataCount<=3){
                self.loadSharedRecordBtn.hidden=YES;
                self.sharedCollViewHT.constant=310;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>6 && sharedDataCount<10 && fetchDataCount>3){
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=220;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>9  && fetchDataCount<=3){
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=310;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>15  && fetchDataCount==0){
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=490;
                return self.sharedFetchedData.count;
            }
            else{
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=130;
                return self.sharedFetchedData.count;
            }

        }
       
    }
    else {
        NSLog(@"Device is an iPhone 6 Plus or more");
        if (collectionView==self.collectionView) {
            self.sharedCollviewTop.constant=20;
            [self.view layoutIfNeeded];

            if (fetchDataCount<=3) {
                self.loadRecordBtn.hidden=YES;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>3 && fetchDataCount<7){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=220;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>6 && fetchDataCount<10){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=310;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>9 && fetchDataCount<13 && sharedDataCount>3){
                self.loadRecordBtn.hidden=NO;
                self.sharedCollviewTop.constant=55;
                [self.view layoutIfNeeded];

                self.collViewHT.constant=310;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>9 && fetchDataCount<13  && sharedDataCount<=3){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=400;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>12 && fetchDataCount<16  && sharedDataCount==0){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=490;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>15 && fetchDataCount<19  && sharedDataCount==0){
                self.loadRecordBtn.hidden=YES;
                self.collViewHT.constant=580;
                return self.FetchedData.count;
            }
            else if (fetchDataCount>18  && sharedDataCount==0){
                self.loadRecordBtn.hidden=NO;
                self.collViewHT.constant=580;
                return self.FetchedData.count;
            }
            
            else{
                self.sharedCollviewTop.constant=55;
                [self.view layoutIfNeeded];

                self.loadRecordBtn.hidden=NO;
                self.collViewHT.constant=130;
                return self.FetchedData.count;
            }
            
        }
        else{
            if (sharedDataCount<=3) {
                self.loadSharedRecordBtn.hidden=YES;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>3 && sharedDataCount<7){
                self.loadSharedRecordBtn.hidden=YES;
                self.sharedCollViewHT.constant=220;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>6 && sharedDataCount<10 ){
                self.loadSharedRecordBtn.hidden=YES;
                self.sharedCollViewHT.constant=310;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>9 && sharedDataCount<13 && fetchDataCount>3){
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=310;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>9 && sharedDataCount<13 && fetchDataCount<=3){
                self.loadSharedRecordBtn.hidden=YES;
                self.sharedCollViewHT.constant=400;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>12  && fetchDataCount<=3){
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=490;
                return self.sharedFetchedData.count;
            }
            else if (sharedDataCount>18  && fetchDataCount==0){
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=580;
                return self.sharedFetchedData.count;
            }
            else{
                self.loadSharedRecordBtn.hidden=NO;
                self.sharedCollViewHT.constant=130;
                return self.sharedFetchedData.count;
            }
            
        }

    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    // cell.backgroundColor = [UIColor colorWithPatternImage:[self getImage:[ArrImage objectAtIndex:indexPath.row]]];
        if (collectionView==self.collectionView) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

            UILabel *nameLbl = (UILabel *)[cell viewWithTag:101];

        nameLbl.text=[[self.FetchedData objectAtIndex:self.FetchedData.count-indexPath.row-1]objectAtIndex:0];
            UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:100];
            collectionImageView.image=[UIImage imageNamed:@"folder.png"];
         return cell;
        }
        else{
            UICollectionViewCell *sharedCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sharedCell" forIndexPath:indexPath];

            UILabel *nameLbl = (UILabel *)[sharedCell viewWithTag:101];
            UIImageView *collectionImageView = (UIImageView *)[sharedCell viewWithTag:100];
            collectionImageView.image=[UIImage imageNamed:@"folder.png"];
            nameLbl.text=[[self.sharedFetchedData objectAtIndex:self.sharedFetchedData.count-indexPath.row-1]objectAtIndex:0];
            return sharedCell;
        }
   
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
   
    if (shareEnabled){
          [Localytics tagEvent:@"MedicalRecordAlbumSelectForShareOrDeleteClick"];
             if (collectionView==self.collectionView) {
                  sectionIdentity=@"";
                [selectedAlbum addObject:[[self.FetchedData objectAtIndex:self.FetchedData.count-1-indexPath.row]objectAtIndex:1]];
                
                selectedAlubID=[selectedAlubID stringByAppendingString:[NSString stringWithFormat:@"%@,",[[self.FetchedData objectAtIndex:self.FetchedData.count-indexPath.row-1]objectAtIndex:1]]];
                 self.sharedCollectionView.userInteractionEnabled=NO;
            }
            else{
                sectionIdentity=@"1";
                [selectedAlbum addObject:[[self.sharedFetchedData objectAtIndex:self.sharedFetchedData.count-1-indexPath.row]objectAtIndex:1]];
                selectedAlubID=[selectedAlubID stringByAppendingString:[NSString stringWithFormat:@"%@,",[[self.sharedFetchedData objectAtIndex:self.sharedFetchedData.count-1-indexPath.row]objectAtIndex:1]]];
                self.collectionView.userInteractionEnabled=NO;
                
            }
            
            UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:100];
            collectionImageView.image=[UIImage imageNamed:@"folderTricked.png"];
            if ([selectedAlbum count]==1) {
                self.titleLbl.text = @"1 Album Selected";
                
            }
            else {
                self.titleLbl.text = [NSString stringWithFormat:@"%lu Albums Selected",(unsigned long)[selectedAlbum count]];
            }
            
            if ([selectedAlubID length]>1) {
                [self.shareBtn setImage:[UIImage imageNamed:@"share_On.png"] forState:UIControlStateNormal];
                [self.deleteBtn setImage:[UIImage imageNamed:@"dustbin_On.png"] forState:UIControlStateNormal];
                
                shareActive=YES;
            }
            else{
                [self.shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                [self.deleteBtn setImage:[UIImage imageNamed:@"dustbin.png"] forState:UIControlStateNormal];
                
                shareActive=NO;
            }
            
            
      //  }
//        else{
//            // NSLog(@"failureeeee");
//        }
    }
    else{
        [Localytics tagEvent:@"MedicalRecordOpenAlbumClick"];
        SubFolderViewController *SFVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SubFolderVC"];
         if (collectionView==self.collectionView) {
            SFVC.parentFolder =[[self.FetchedData objectAtIndex:self.FetchedData.count-1-indexPath.row]objectAtIndex:0];
            SFVC.folderid = [[self.FetchedData objectAtIndex:self.FetchedData.count-1-indexPath.row]objectAtIndex:1];
        }
        else{
            SFVC.parentFolder =[[self.sharedFetchedData objectAtIndex:self.sharedFetchedData.count-1-indexPath.row]objectAtIndex:0];
            SFVC.folderid = [[self.sharedFetchedData objectAtIndex:self.sharedFetchedData.count-1-indexPath.row]objectAtIndex:1];
            SFVC.recordType=@"sharedRecord";
        }
        [self.navigationController pushViewController:SFVC animated:YES];
        
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (shareEnabled) {
         if (collectionView==self.collectionView){
            NSString *albumID= [[self.FetchedData objectAtIndex:self.FetchedData.count-1-indexPath.row]objectAtIndex:1];
            [selectedAlbum removeObject:albumID];
            selectedAlubID = [selectedAlubID stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",albumID] withString:@""];
        }
        else{
            NSString *albumID= [[self.sharedFetchedData objectAtIndex:self.sharedFetchedData.count-1-indexPath.row]objectAtIndex:1];
            [selectedAlbum removeObject:albumID];
            selectedAlubID = [selectedAlubID stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",albumID] withString:@""];
        }
        
        
        UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:100];
        collectionImageView.image=[UIImage imageNamed:@"folder.png"];
        
        if ([selectedAlbum count]==0) {
            self.titleLbl.text = @"Select Items";
            self.collectionView.userInteractionEnabled=YES;
            self.sharedCollectionView.userInteractionEnabled=YES;
            
        }
        else if ([selectedAlbum count]==1) {
            self.titleLbl.text = @"1 Album Selected";
            
        }
        else {
            self.titleLbl.text = [NSString stringWithFormat:@"%lu Albums Selected",(unsigned long)[selectedAlbum count]];
        }
        if ([selectedAlubID length]>1) {
            [self.shareBtn setImage:[UIImage imageNamed:@"share_On.png"] forState:UIControlStateNormal];
            [self.deleteBtn setImage:[UIImage imageNamed:@"dustbin_On.png"] forState:UIControlStateNormal];
            
            shareActive=YES;
        }
        else{
            [self.shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
            [self.deleteBtn setImage:[UIImage imageNamed:@"dustbin.png"] forState:UIControlStateNormal];
            shareActive=NO;
        }
    }
    
    
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10); // top, left, bottom, right
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (collectionView==self.collectionView) {
        if (kind == UICollectionElementKindSectionHeader) {
            UICollectionReusableView *HeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            UILabel *nameLbl = (UILabel *)[HeaderView viewWithTag:1001];
            nameLbl.text=@"Own Record";
            if (self.FetchedData.count==0) {
                HeaderView.hidden=YES;
            }
            reusableview = HeaderView;
        }
    }
    else{
        if (kind == UICollectionElementKindSectionHeader) {
            UICollectionReusableView *HeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderViewShared" forIndexPath:indexPath];
            UILabel *nameLbl = (UILabel *)[HeaderView viewWithTag:1001];
            nameLbl.text=@"Shared Record";
            if (_sharedFetchedData.count==0) {
                HeaderView.hidden=YES;
            }
            reusableview = HeaderView;
        }

    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = [UIScreen mainScreen].bounds.size.width / 3.0f-20;
    return CGSizeMake(picDimension, 90);
}
-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    NSPredicate *emailRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9]+\\.[A-Za-z]{2,4}"];
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSString *phoneRegex =@"^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$";// @"^[789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    
    if((![phoneTest evaluateWithObject:mobile.text]) || (mobile.text.length!=10) || ([mobile.text isEqualToString:@""]&& [mobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]) )
    {
        valid = NO;
        [mobile becomeFirstResponder];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Valid Mobile Number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    
    else if(emailID.text.length>0){
        if(![emailTest evaluateWithObject:emailID.text])
        {
            valid = NO;
            [emailID becomeFirstResponder];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Valid Email ID" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
        }
    }
    
    return valid;
}

-(void)saveAlbumInfo:(NSMutableArray*)albumInfo sharedAlbumInfo:(NSMutableArray*)sharedAlbumInfo{
    // Prepare the query string.
    for (int i=0; i<albumInfo.count; i++)
    {
        NSString *albumid =[[albumInfo objectAtIndex:i]valueForKey:@"AlbumId"];
        NSString *albumname =[[albumInfo objectAtIndex:i]valueForKey:@"AlbumName"];
        NSString *albumStatus =[[albumInfo objectAtIndex:i]valueForKey:@"AlbumStatus"];
        NSMutableArray *ImageTypeDetail= [[NSMutableArray alloc]init];
        ImageTypeDetail =[[albumInfo objectAtIndex:i]valueForKey:@"ImageTypeDetail"];
        if ([albumStatus isEqualToString:@"Added"]) {
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
                        }
                        
                    }else{
                        //                    NSLog(@"Enter in ImageTypeDetail is null");
                    }
                }
                else{
                    //                NSLog(@"Could not execute the query  for medicalFolder.");
                }
            }
            else{
                if (![ImageTypeDetail isKindOfClass:[NSNull class]]) {
                    for (int j=0; j<ImageTypeDetail.count; j++) {
                        NSString *imgStatus = [ImageTypeDetail objectAtIndex:j][@"ImageStatus"];
                        if ([imgStatus isEqualToString:@"Added"]) {
                            NSString *imgid = [ImageTypeDetail objectAtIndex:j][@"ImageId"];
                            NSString *imgtype = [ImageTypeDetail objectAtIndex:j][@"ImageType"];
                            NSString *caption=  [ImageTypeDetail objectAtIndex:j][@"ImageTag"];
                            NSString *imageName=  [ImageTypeDetail objectAtIndex:j][@"ImageName"];
                            imgtype = [imgtype stringByReplacingOccurrencesOfString:@"Medical" withString:@""];
                            NSString *imageUrl=  [ImageTypeDetail objectAtIndex:j][@"ImageUrl"];
                            NSString *query = [NSString stringWithFormat:@"INSERT INTO medicalRecord (user_id,album_name,upload_status,report_type,image_url,image_name,image_tag, image_id,album_id,image_download) VALUES('%@', '%@','%@','%@', '%@','%@' ,'%@','%@','%@','0')",[userdef objectForKey:User_id],albumname,@"1",imgtype,imageUrl?imageUrl:@"",imageName,caption?caption:@"",imgid?imgid:@"",albumid?albumid:@""];
                            // Execute the query.
                            [self.dbManager executeQuery:query];
                            NSLog(@"%d",self.dbManager.affectedRows);
                        }
                        else if ([imgStatus isEqualToString:@"Deleted"]){
                             NSString *imgid = [ImageTypeDetail objectAtIndex:j][@"ImageId"];
                            NSString *selectQuery = [NSString stringWithFormat:@"DELETE FROM medicalRecord WHERE image_id='%@'",imgid];
                            [self.dbManager loadDataFromDB:selectQuery];
//                            NSUInteger index = [[ImageTypeDetail valueForKey:@"ImageStatus" ] indexOfObject:imgStatus];
//                            [ImageTypeDetail removeObjectAtIndex:index];
                            
                        }
                        else if ([imgStatus isEqualToString:@"Updated"]){
                            NSString *imgid = [ImageTypeDetail objectAtIndex:j][@"ImageId"];
                            NSString *caption=  [ImageTypeDetail objectAtIndex:j][@"ImageTag"];
                            NSString *udateQuery = [NSString stringWithFormat:@"UPDATE medicalRecord SET image_tag ='%@' WHERE image_id = '%@'" ,caption,imgid];
                            // Execute the query.
                            [self.dbManager executeQuery:udateQuery];
                            NSLog(@"%d",self.dbManager.affectedRows);
                            
                        }
                    }
                }
            }
        }
        else{
            NSString *selectQuery = [NSString stringWithFormat:@"DELETE FROM medicalFolder WHERE album_id='%@'",albumid];
            [self.dbManager loadDataFromDB:selectQuery];
            
        }
        
    }
    [self saveSharedAlbumInfo:sharedAlbumInfo];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"imgdwnldDn" object:nil];
    
}



-(void)saveSharedAlbumInfo:(NSMutableArray*)albumInfo{
    
    if ([albumInfo isKindOfClass:[NSNull class]]) {
        
    }
    else{
        for (int i=0; i<albumInfo.count; i++)
        {
            NSString *albumid =[[albumInfo objectAtIndex:i]valueForKey:@"AlbumId"];
            NSString *albumname =[[albumInfo objectAtIndex:i]valueForKey:@"AlbumName"];
            NSString *albumStatus =[[albumInfo objectAtIndex:i]valueForKey:@"AlbumStatus"];
            NSMutableArray *ImageTypeDetail= [[NSMutableArray alloc]init];
            ImageTypeDetail =[[albumInfo objectAtIndex:i]valueForKey:@"ImageTypeDetail"];
            if ([albumStatus isEqualToString:@"Added"]){
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
                                
                                
                                
                            }
                        }else{
                            //                    NSLog(@"Enter in ImageTypeDetail is null");
                        }
                    }
                    else{
                        //                NSLog(@"Could not execute the query  for medicalFolder.");
                    }
                }
                else{
                    if (![ImageTypeDetail isKindOfClass:[NSNull class]]) {
                        for (int j=0; j<ImageTypeDetail.count; j++) {
                            NSString *imgStatus = [ImageTypeDetail objectAtIndex:j][@"ImageStatus"];
                            if ([imgStatus isEqualToString:@"Added"]) {
                                NSString *imgid = [ImageTypeDetail objectAtIndex:j][@"ImageId"];
                                NSString *imgtype = [ImageTypeDetail objectAtIndex:j][@"ImageType"];
                                NSString *caption=  [ImageTypeDetail objectAtIndex:j][@"ImageTag"];
                                NSString *imageName=  [ImageTypeDetail objectAtIndex:j][@"ImageName"];
                                imgtype = [imgtype stringByReplacingOccurrencesOfString:@"Medical" withString:@""];
                                NSString *imageUrl=  [ImageTypeDetail objectAtIndex:j][@"ImageUrl"];
                                NSString *query = [NSString stringWithFormat:@"INSERT INTO medicalRecord (user_id,album_name,upload_status,report_type,image_url,image_name,image_tag, image_id,album_id,image_download) VALUES('%@', '%@','%@','%@', '%@','%@' ,'%@','%@','%@','0')",[userdef objectForKey:User_id],albumname,@"1",imgtype,imageUrl?imageUrl:@"",imageName,caption?caption:@"",imgid?imgid:@"",albumid?albumid:@""];
                                // Execute the query.
                                [self.dbManager executeQuery:query];
                                NSLog(@"%d",self.dbManager.affectedRows);
                            }
                            else if ([imgStatus isEqualToString:@"Deleted"]){
                                NSString *imgid = [ImageTypeDetail objectAtIndex:j][@"ImageId"];
                                NSString *selectQuery = [NSString stringWithFormat:@"DELETE FROM medicalRecord WHERE image_id='%@'",imgid];
                                [self.dbManager loadDataFromDB:selectQuery];
//                                NSUInteger index = [[ImageTypeDetail valueForKey:@"ImageStatus" ] indexOfObject:imgStatus];
//                                [ImageTypeDetail removeObjectAtIndex:index];
                                
                            }
                            else if ([imgStatus isEqualToString:@"Updated"]){
                                NSString *imgid = [ImageTypeDetail objectAtIndex:j][@"ImageId"];
                                NSString *caption=  [ImageTypeDetail objectAtIndex:j][@"ImageTag"];
                                NSString *udateQuery = [NSString stringWithFormat:@"UPDATE medicalRecord SET image_tag ='%@' WHERE image_id = '%@'" ,caption,imgid];
                                // Execute the query.
                                [self.dbManager executeQuery:udateQuery];
                                NSLog(@"%d",self.dbManager.affectedRows);
                                
                            }
                        }
                    }
                }
                
            }
            else{
                NSString *selectQuery = [NSString stringWithFormat:@"DELETE FROM sharedMedicalFolder WHERE album_id='%@'",albumid];
                [self.dbManager loadDataFromDB:selectQuery];
                
            }
        }
        
    }
    [self loadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"imgdwnldDn" object:nil];
    
}



- (IBAction)loadRecordAction:(id)sender {
    [Localytics tagEvent:@"MedicalRecordOwnMoreButtonClick"];
    MedicalRecordDetailVC *MedicalRecordDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MedicalRecordDetailVC"];
    MedicalRecordDetailVC.FetchedData=self.FetchedData;
    MedicalRecordDetailVC.titleName=@"Own Record";
    [self.navigationController pushViewController:MedicalRecordDetailVC animated:YES];
}

- (IBAction)loadSharedRecordAction:(id)sender {
    [Localytics tagEvent:@"MedicalRecordShareMoreButtonClick"];
    MedicalRecordDetailVC *MedicalRecordDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MedicalRecordDetailVC"];
    MedicalRecordDetailVC.FetchedData=self.sharedFetchedData;
    MedicalRecordDetailVC.titleName=@"Shared Record";
    [self.navigationController pushViewController:MedicalRecordDetailVC animated:YES];
}
- (IBAction)tipsAction:(id)sender {
    self.tipsBtn.hidden=YES;
    self.tipsImageView.hidden=YES;
}
@end




