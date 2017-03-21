//
//  MedicalRecordDetailVC.m
//  docOPD
//
//  Created by Virinchi Software on 20/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "MedicalRecordDetailVC.h"
#import "ContactVC.h"
#import "SubFolderViewController.h"

@interface MedicalRecordDetailVC ()

@end

@implementation MedicalRecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    userdef = userDefault;
    self.titleLbl.text=self.titleName;
    selectedAlubID=@"";
    selectedAlbum = [NSMutableArray array];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Medical Record Details"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shareBtnAction:(id)sender {
    if (shareActive) {
        ContactVC *contactVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactVC"];
        contactVC.controllerName=@"MedicalRecord";
        contactVC.id=selectedAlubID;
        [self.navigationController pushViewController:contactVC animated:YES];
    }
}
- (IBAction)deleteBtnAction:(id)sender {
    if (shareActive) {
        if (![self.titleName isEqualToString:@"Own Record"]) {
            //RemoveAlbumSharingAPI
            [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:[NSString stringWithFormat:@"Unsharing selected Album"]];
            [[docOPDNetworkEngine sharedInstance]RemoveAlbumSharingAPI:[userdef valueForKey:Mobile]  AlbumId:selectedAlubID withCallback:^(NSDictionary *responseData) {
                //[self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];//edit-button.png
                [self.editBtn setImage:[UIImage imageNamed:@"edit-button.png"] forState:UIControlStateNormal];
                
                shareEnabled = NO;
                shareActive=NO;
                self.collectionView.allowsMultipleSelection = NO;
                [self deleteSharedAlbum];
                [self.collectionView reloadData];
                [selectedAlbum removeAllObjects];
                [[AppDelegate MyappDelegate] hideIndicator];
                self.titleLbl.text = self.titleName;
            }];
            
        }
        else{
            [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:[NSString stringWithFormat:@"Deleting selected Album"]];
            [[docOPDNetworkEngine sharedInstance]DeleteMultipleAlbumAPI:selectedAlubID withCallback:^(NSDictionary *responseData) {
                [self.editBtn setImage:[UIImage imageNamed:@"edit-button.png"] forState:UIControlStateNormal];
                
                shareEnabled = NO;
                shareActive=NO;
                self.collectionView.allowsMultipleSelection = NO;
                [self deleteAlbum];
                [self.collectionView reloadData];
                [selectedAlbum removeAllObjects];
                [[AppDelegate MyappDelegate] hideIndicator];
               self.titleLbl.text = self.titleName;
            }];
            
        }

    }
}
- (IBAction)editAction:(id)sender {
    selectedAlubID=@"";
    [selectedAlbum removeAllObjects];
    if (shareEnabled) {
        [self.shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [self.deleteBtn setImage:[UIImage imageNamed:@"dustbin.png"] forState:UIControlStateNormal];

        [self.editBtn setImage:[UIImage imageNamed:@"edit-button.png"] forState:UIControlStateNormal];
        shareActive=NO;
        shareEnabled = NO;
        self.collectionView.allowsMultipleSelection = NO;
        [self.collectionView reloadData];
        self.titleLbl.text = self.titleName;
    }
    else{
        self.titleLbl.text = @"Select Items";
        [self.editBtn setImage:[UIImage imageNamed:@"white-cancel.png"] forState:UIControlStateNormal];
        shareEnabled = YES;
        self.collectionView.allowsMultipleSelection = YES;
        [self.collectionView reloadData];
    }

}

#pragma Collection view

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.FetchedData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        UILabel *nameLbl = (UILabel *)[cell viewWithTag:101];
        
        nameLbl.text=[[self.FetchedData objectAtIndex:self.FetchedData.count-indexPath.row-1]objectAtIndex:0];
        UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:100];
        collectionImageView.image=[UIImage imageNamed:@"folder.png"];
        return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
if (shareEnabled){
    [selectedAlbum addObject:[[self.FetchedData objectAtIndex:self.FetchedData.count-1-indexPath.row]objectAtIndex:1]];
    
    selectedAlubID=[selectedAlubID stringByAppendingString:[NSString stringWithFormat:@"%@,",[[self.FetchedData objectAtIndex:self.FetchedData.count-indexPath.row-1]objectAtIndex:1]]];
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
}
else{
    [Localytics tagEvent:@"Open folder"];
    SubFolderViewController *SFVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SubFolderVC"];
        SFVC.parentFolder =[[self.FetchedData objectAtIndex:self.FetchedData.count-1-indexPath.row]objectAtIndex:0];
        SFVC.folderid = [[self.FetchedData objectAtIndex:self.FetchedData.count-1-indexPath.row]objectAtIndex:1];
        [self.navigationController pushViewController:SFVC animated:YES];
}

}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (shareEnabled) {
            NSString *albumID= [[self.FetchedData objectAtIndex:self.FetchedData.count-1-indexPath.row]objectAtIndex:1];
            [selectedAlbum removeObject:albumID];
            selectedAlubID = [selectedAlubID stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",albumID] withString:@""];
        UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:100];
        collectionImageView.image=[UIImage imageNamed:@"folder.png"];
        
        if ([selectedAlbum count]==0) {
            self.titleLbl.text = @"Select Items";
            //sectionFlag=false;
            
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = [UIScreen mainScreen].bounds.size.width / 3.0f-20;
    return CGSizeMake(picDimension, 90);
}
-(void)deleteAlbum{
    //DELETE FROM COMPANY WHERE ID = 7;
    for (int albumID=0; albumID<[selectedAlbum count]; albumID++) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM medicalFolder WHERE album_id='%@'",[selectedAlbum objectAtIndex:albumID]];
        [self.dbManager executeQuery:query];
        
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
-(void)loadData{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    
    NSString *query;
    if ([self.titleName isEqualToString:@"Own Record"]) {
        query= [NSString stringWithFormat:@"SELECT DISTINCT album_name,album_id FROM medicalFolder WHERE user_id='%@'",[userdef valueForKey:User_id]];
    }
    else{
        query = [NSString stringWithFormat:@"SELECT DISTINCT album_name,album_id FROM sharedMedicalFolder WHERE user_id='%@'",[userdef valueForKey:User_id]];
    }
    
    // Get the results.
    if (self.FetchedData != nil) {
        self.FetchedData = nil;
    }
    self.FetchedData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    
    [self.collectionView reloadData];
    
    
}


@end
