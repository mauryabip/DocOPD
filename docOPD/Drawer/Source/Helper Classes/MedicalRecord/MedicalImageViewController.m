//
//  MedicalImageViewController.m
//  docOPD
//
//  Created by Virinchi Software on 1/23/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "MedicalImageViewController.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "photoViwerViewController.h"
#import "NSData+Base64.h"
#import "docOPDNetworkEngine.h"


@interface MedicalImageViewController ()

@end

@implementation MedicalImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.recordType isEqualToString:@"sharedRecord"]){
        self.deleteBtn.hidden=YES;
        self.addBtn.hidden=YES;
        self.editTraillingConst.constant=-35;
        self.shareLeadingConst.constant=(self.view.frame.size.width-40)/2.0;
        //[self.view layoutIfNeeded];
    }
     selectedImageID =@"";
    selectedImage = [NSMutableArray array];

    isUpdate = false;
    self.LblParentFolderName.text = self.parentFolder;
    self.LblGrandParent.text = self.grandParent;
    userdef = userDefault;
      self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    [self GetData];
  //  [self updateImgArray];
//    NSError *error;
//    NSString *localpath = [NSString stringWithFormat:@"%@/%@/%@",[[AppDelegate MyappDelegate]medicalRecordPath],self.grandParent,self.parentFolder];
//
//    
//    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localpath error:&error];
//    
//    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localpath error:&error];
//    NSLog(@"Path %@",paths);
//    ArrImage = paths.mutableCopy;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [self updateImgArray];
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"AlbumImageScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
      [Localytics tagEvent:@"AlbumImageScreen"];
}


-(void)updateMedicalData{
    [[docOPDNetworkEngine sharedInstance]UpdateImageTypeAPI:self.id withCallback:^(NSDictionary *responseData) {
        
    }];
}



-(void)updateImgArray{
    NSError *error;
    NSString *localpath = [NSString stringWithFormat:@"%@/%@/%@",[[AppDelegate MyappDelegate]medicalRecordPath],self.grandParent,self.parentFolder];
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localpath error:&error];
    ArrImage = paths.mutableCopy;
 //   [self.collectionView reloadData];
}

-(void)updateImage{
    isUpdate = YES;
    [self GetData];
    [self.collectionView reloadData];
}

- (IBAction)didPressBackMenu:(id)sender {
    [Localytics tagEvent:@"AlbumImageSubAlbumClick"];
    isUpdate?[self.delegate ImageWasAdded]:nil;
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   // return ArrImage.count;
    return self.FetchedData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

   // cell.backgroundColor = [UIColor colorWithPatternImage:[self getImage:[ArrImage objectAtIndex:indexPath.row]]];
    UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:100];
//    UIImage *img =[self getImage:[ArrImage objectAtIndex:indexPath.row]];
//    collectionImageView.image = img;
    
    
    NSString *filename;
    filename  = [[self.FetchedData objectAtIndex:indexPath.row]objectAtIndex:0];
    
    NSString *imgCaption =[[self.FetchedData objectAtIndex:indexPath.row]objectAtIndex:1];
    NSData *data = [[NSData alloc] initWithData:[NSData
                                                 dataFromBase64String:filename]];
    collectionImageView.image = [UIImage imageWithData:data];
    //NSInteger indexOfImgtag = [self.dbManager.arrColumnNames indexOfObject:@"image_tag"];
    if (!shareEnabled) {
        UIImageView *collImageView = (UIImageView *)[cell viewWithTag:101];
        UIImageView *upperImageView = (UIImageView *)[cell viewWithTag:102];
        upperImageView.backgroundColor=[UIColor clearColor];
        collImageView.image=[UIImage imageNamed:@""];
      // [self displayImage:collectionImageView withImage:collectionImageView.image ImageCaption:imgCaption];
    }
    else{
       //  [self displayImage:collectionImageView withImage:[UIImage imageNamed:@""] ImageCaption:@""];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    if (shareEnabled) {
        [Localytics tagEvent:@"AlbumImageShareOrDeleteImageClick"];
        if ([[self.FetchedData objectAtIndex:indexPath.item] count]==0x00000003) {
        UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:101];
        UIImageView *upperImageView = (UIImageView *)[cell viewWithTag:102];
        upperImageView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        collectionImageView.image=[UIImage imageNamed:@"Trick"];
        NSLog(@"%ld",(long)indexPath.row);
        NSString *imageID= [[self.FetchedData objectAtIndex:indexPath.row]objectAtIndex:2];
            [selectedImage addObject:imageID];
            
            if ([selectedImage count]==1) {
                self.LblParentFolderName.text = @"1 Photo Selected";

            }
            else {
                self.LblParentFolderName.text = [NSString stringWithFormat:@"%lu Photos Selected",(unsigned long)[selectedImage count]];
            }

            selectedImageID =[selectedImageID stringByAppendingString:[NSString stringWithFormat:@"%@,",imageID]];
            if ([selectedImageID length]>1) {
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
    else{
        [Localytics tagEvent:@"AlbumImageviewImageClick"];
        photoViwerViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PVVC"];
        NSString *localpath = [NSString stringWithFormat:@"%@/%@/%@",[[AppDelegate MyappDelegate]medicalRecordPath],self.grandParent,self.parentFolder];
        NSString *getImagePath = [localpath stringByAppendingPathComponent:[ArrImage objectAtIndex:indexPath.row]];
        NSInteger indexOfImgid = [self.dbManager.arrColumnNames indexOfObject:@"image_id"];
        if ([[self.FetchedData objectAtIndex:indexPath.item] count]==0x00000003) {
            NSString *ss = [[self.FetchedData objectAtIndex:indexPath.item]objectAtIndex:2];
            pvc.imageid =ss;
            
            // pvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            // pvc.getImagePath =getImagePath;
            
            [self presentViewController:pvc animated:YES completion:nil];
        }
        
       
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    if (shareEnabled) {
        UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:101];
        UIImageView *upperImageView = (UIImageView *)[cell viewWithTag:102];
        upperImageView.backgroundColor=[UIColor clearColor];
        collectionImageView.image=[UIImage imageNamed:@""];
        NSString *imageID= [[self.FetchedData objectAtIndex:indexPath.row]objectAtIndex:2];
        [selectedImage removeObject:imageID];
        if ([selectedImage count]==0) {
            self.LblParentFolderName.text = @"Select Items";
        }
        else if ([selectedImage count]==1){
            self.LblParentFolderName.text = @"1 Photo Selected";
        }
        else {
            self.LblParentFolderName.text = [NSString stringWithFormat:@"%lu Photos Selected",(unsigned long)[selectedImage count]];
        }

        selectedImageID = [selectedImageID stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",imageID]
                                             withString:@""];
        if ([selectedImageID length]>1) {
            [self.shareBtn setImage:[UIImage imageNamed:@"share_On.png"] forState:UIControlStateNormal];
            [self.deleteBtn setImage:[UIImage imageNamed:@"dustbin_On.png"] forState:UIControlStateNormal];

            shareActive=YES;
        }
        else{
            [self.shareBtn setImage:[UIImage imageNamed:@"share_On.png"] forState:UIControlStateNormal];
            [self.deleteBtn setImage:[UIImage imageNamed:@"dustbin_On.png"] forState:UIControlStateNormal];
            shareActive=NO;
        }
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = [UIScreen mainScreen].bounds.size.width / 4.0f;
    return CGSizeMake(picDimension-2, picDimension-2);
}
/*
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat leftRightInset = self.view.frame.size.width / 14.0f;
    return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset);
}
*/

/*

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    photoViwerViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PVVC"];
    NSString *localpath = [NSString stringWithFormat:@"%@/%@/%@",[[AppDelegate MyappDelegate]medicalRecordPath],self.grandParent,self.parentFolder];
    NSString *getImagePath = [localpath stringByAppendingPathComponent:[ArrImage objectAtIndex:indexPath.row]];
    NSInteger indexOfImgid = [self.dbManager.arrColumnNames indexOfObject:@"image_id"];
    NSString *ss = [[self.FetchedData objectAtIndex:indexPath.item]objectAtIndex:2];
    pvc.imageid =ss;
    
   // pvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

   // pvc.getImagePath =getImagePath;
    
    [self presentViewController:pvc animated:YES completion:nil];
}
*/

- (IBAction)didPressAddButton:(id)sender {
    [Localytics tagEvent:@"AlbumImageAddImageClick"];
    CaptionViewController *CPVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CPVC"];
    CPVC.grandParent = self.grandParent;
    CPVC.parentFolder = self.parentFolder;
    CPVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    CPVC.delegate= self;
    CPVC.folderid = self.folderid;
    [self presentViewController:CPVC animated:YES completion:nil];
}


- (UIImage*)getImage: (NSString*)filename {
    
    //   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //   NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    NSString *localpath = [NSString stringWithFormat:@"%@/%@/%@",[[AppDelegate MyappDelegate]medicalRecordPath],self.grandParent,self.parentFolder];
    //   localpath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:@"Media"];
    NSString *getImagePath = [localpath stringByAppendingPathComponent:filename];
//    NSLog(@"Get image path: %@",getImagePath);
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
    
}
- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image  {
    [Localytics tagEvent:@"View medical image"];
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setupImageViewer];
    imageView.clipsToBounds = YES;
}

- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image ImageCaption:(NSString*)caption  {
   [Localytics tagEvent:@"View medical image"];
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    if ([caption isKindOfClass:[NSNull class]]) {
        caption = @"";
    }
    [imageView setupImageViewerWithText:caption?caption:@" "];
}




-(void)GetData{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    NSString *query;
//    if ([self.recordType isEqualToString:@"sharedRecord"]){
//        query = [NSString stringWithFormat:@"SELECT upload_image,image_tag,image_id FROM sharedMedicalRecord WHERE album_id='%@' AND report_type='%@'",self.folderid,self.parentFolder];
//  
//    }
//    else
    query = [NSString stringWithFormat:@"SELECT upload_image,image_tag,image_id FROM medicalRecord WHERE album_id='%@' AND report_type='%@'",self.folderid,self.parentFolder];
    
    // Get the results.
    if (self.FetchedData != nil) {
        self.FetchedData = nil;
    }
    
    self.FetchedData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSString*queryUrl = [NSString stringWithFormat:@"SELECT image_url FROM medicalRecord WHERE album_id='%@' AND report_type='%@'",self.folderid,self.parentFolder];
    imgArr = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryUrl]];
    NSLog(@"%@",imgArr);

    if ([self.FetchedData count]>0) {
        self.editBtn.hidden=NO;
    }
    else
        self.editBtn.hidden=YES;

}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (IBAction)backToAlbumAction:(id)sender {
    [Localytics tagEvent:@"AlbumImageMedicalRecordClick"];
     isUpdate?[self.delegate ImageWasAdded]:nil;
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [self.navigationController popToViewController:[navigationArray objectAtIndex:[navigationArray count]-3] animated:YES];
}

-(void)deleteImage{
    
    for (int imageID=0; imageID<[selectedImage count]; imageID++) {
        NSString *query;
//        if ([self.recordType isEqualToString:@"sharedRecord"]){
//            query = [NSString stringWithFormat:@"DELETE FROM sharedMedicalRecord WHERE image_id='%@'",[selectedImage objectAtIndex:imageID]];
//  
//        }
//        else
        query = [NSString stringWithFormat:@"DELETE FROM medicalRecord WHERE image_id='%@'",[selectedImage objectAtIndex:imageID]];
        [self.dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        // if (self.dbManager.affectedRows != 0){
       
        // }
    }
    isUpdate = YES;
    [self GetData];
    [selectedImage removeAllObjects];
    [self.collectionView reloadData];
    self.LblParentFolderName.text = self.parentFolder;
    self.LblGrandParent.text = self.grandParent;
    self.LblGrandParent.hidden=NO;
}

- (IBAction)deleteBtnAction:(id)sender {
    [Localytics tagEvent:@"AlbumImageDeleteButtonClick"];
    if (shareActive){
        [[docOPDNetworkEngine sharedInstance]DeleteMultipleImageAPI:selectedImageID withCallback:^(NSDictionary *responseData) {
            
            self.backToAlbumBtn.hidden=NO;
            //[self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
            [self.editBtn setImage:[UIImage imageNamed:@"edit-button.png"] forState:UIControlStateNormal];
            shareEnabled = NO;
            self.collectionView.allowsMultipleSelection = NO;
            
           // [self.collectionView reloadData];
            [self deleteImage];
            shareActive=NO;
        }];
    }

}

- (IBAction)shareBtnAction:(id)sender {
    
    [Localytics tagEvent:@"AlbumImageShareButtonClick"];
    if (shareActive) {
        ContactVC *contactVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactVC"];
        contactVC.id=selectedImageID;
        [self.navigationController pushViewController:contactVC animated:YES];

    }
    
    
}
- (IBAction)editBtnAction:(id)sender {
    
    
    selectedImageID=@"";
    if (shareEnabled) {
        [Localytics tagEvent:@"AlbumImageCancelButtonClick"];
        self.LblParentFolderName.text = self.parentFolder;
        self.LblGrandParent.text = self.grandParent;
        self.LblGrandParent.hidden=NO;
        self.backToAlbumBtn.hidden=NO;
       // [self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
        [self.editBtn setImage:[UIImage imageNamed:@"edit-button.png"] forState:UIControlStateNormal];
        shareEnabled = NO;
        self.collectionView.allowsMultipleSelection = NO;
        [self.collectionView reloadData];
    }
    else{
        [Localytics tagEvent:@"AlbumImageEditButtonClick"];
        self.LblParentFolderName.text = @"Select Items";
        self.LblGrandParent.hidden=YES;
        self.backToAlbumBtn.hidden=YES;
       // [self.editBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.editBtn setImage:[UIImage imageNamed:@"white-cancel.png"] forState:UIControlStateNormal];

        shareEnabled = YES;
        self.collectionView.allowsMultipleSelection = YES;
        [self.collectionView reloadData];
    }
    
}




#pragma mark === UIApplicationDidEnterBackgroundNotification ===

- (void)didEnterBackground:(NSNotification *)notification
{
    [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
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

@end
