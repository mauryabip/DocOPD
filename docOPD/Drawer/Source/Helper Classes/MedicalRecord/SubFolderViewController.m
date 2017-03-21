    //
//  SubFolderViewController.m
//  docOPD
//
//  Created by Virinchi Software on 1/23/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "SubFolderViewController.h"
#import "SubFolderTableViewCell.h"
#import "MedicalImageViewController.h"
#import "docOPDNetworkEngine.h"


@interface SubFolderViewController ()

@end

@implementation SubFolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    recordArr=[[NSMutableArray alloc]init];
    self.lblParentFolder.text = self.parentFolder;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self getdata];
   
}

-(void)viewWillAppear:(BOOL)animated{
      [activityIndicator stopAnimating];
    [super viewWillAppear:animated];
    [self getCount];
    [self.tableView reloadData];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"SubAlbumScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
      [Localytics tagEvent:@"SubAlbumScreen"];
}

-(void)getdata{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"MedicalImageType"];
    recordArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    [self.tableView reloadData];
}
- (IBAction)didPressBackMenu:(id)sender {
      [Localytics tagEvent:@"SubAlbumMedicalRecordClick"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return recordArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubFolderTableViewCell *cell = (SubFolderTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"SubFolder"];
    NSInteger indexOfRType = [self.dbManager.arrColumnNames indexOfObject:@"report_type"];
    NSString *path=[[recordArr valueForKey:@"ImageUrl"]objectAtIndex:indexPath.row];
    [cell.SubFolderImage sd_setImageWithURL:[NSURL URLWithString:path]
                            placeholderImage:[UIImage imageNamed:@""]];
    cell.SubFolderImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.SubFolderImage.clipsToBounds = YES;
    cell.SubFolderName.text = [[recordArr valueForKey:@"ImageType"]objectAtIndex:indexPath.row];
    
    for (int i=0; i<self.FetchedData.count; i++) {
        NSString *rtype = [[self.FetchedData objectAtIndex:i] objectAtIndex:indexOfRType];
        NSString *rtypeCount = [[self.FetchedData objectAtIndex:i] objectAtIndex:0];
        if ([rtype isEqualToString:cell.SubFolderName.text]) {
            cell.SubFolderImageCount.text =[NSString stringWithFormat:@"[%@]",rtypeCount];
            break;
        }else{
            cell.SubFolderImageCount.text =[NSString stringWithFormat:@"[0]"];
        }
    }

    cell.SubFolderName.textColor=[UIColor dOPDTextFontColor];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
   
      [Localytics tagEvent:@"SubAlbumSubAlbumClick"];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MedicalImageViewController *MIVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MedicalImageVC"];
        
        MIVC.parentFolder = [[recordArr valueForKey:@"ImageType"]objectAtIndex:indexPath.row];
        [Localytics tagEvent:[[recordArr valueForKey:@"ImageType"]objectAtIndex:indexPath.row]];
        MIVC.grandParent = self.lblParentFolder.text;
        MIVC.folderid = self.folderid;
        MIVC.delegate = self;
        if ([self.recordType isEqualToString:@"sharedRecord"]) {
            MIVC.recordType=@"sharedRecord";
        }
        [self.navigationController pushViewController:MIVC animated:YES];
        id object = [recordArr objectAtIndex:indexPath.row];
        [recordArr removeObjectAtIndex:indexPath.row];
        [recordArr insertObject:object atIndex:0];
    });
    
    
}


-(void)getCount{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    NSString *query;
//    if ([self.recordType isEqualToString:@"sharedRecord"]) {
//        query = [NSString stringWithFormat:@"SELECT COUNT(rowid), report_type FROM sharedMedicalRecord  WHERE album_name= '%@' GROUP BY report_type",self.parentFolder];
//
//    }
//    else
    query = [NSString stringWithFormat:@"SELECT COUNT(rowid), report_type FROM medicalRecord  WHERE album_name= '%@' GROUP BY report_type",self.parentFolder];
    if (self.FetchedData != nil) {
        self.FetchedData = nil;
    }
    self.FetchedData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
//    NSLog(@"Fetched data count = %@",self.FetchedData);
    if(self.FetchedData !=nil){
        
    }
        
}
-(void)ImageWasAdded{
    // Reload the data.
//    NSLog(@"ImageWasAdded");
    [self getCount];
    [self.tableView reloadData];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
