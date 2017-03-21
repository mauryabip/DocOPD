//
//  CustomSearchViewController.m
//  docOPD
//
//  Created by Virinchi Software on 1/5/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "CustomSearchViewController.h"
#import "CustomSearchTableViewCell.h"
#import "ProcedureListViewController.h"
#import "HospitalSearchViewController.h"
#import "SWTableViewCell.h"
#import "HDNotificationView.h"
#import "ViewController.h"
@interface CustomSearchViewController ()

@end

@implementation CustomSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userdef = userDefault;
   // [self setupErrorview];
    searchStart = false;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"docOPD.sqlite"];
    [self loadInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder ];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"SearchScreen"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
   [Localytics tagEvent:@"SearchScreen"];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
//    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@", searchText];
//    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
//    for (int i=0; i<APIDATA.count; i++) {
//        NSMutableDictionary *temp = [APIDATA objectAtIndex:i];
//        NSString *tempName = [temp valueForKey:@"Name"];
//        tempName = [tempName stringByReplacingOccurrencesOfString:@"  " withString:@" "];
//        [tempArr addObject:tempName];
//    }
//    
//        //NSMutableArray *arr =
//        searchResults = [tempArr filteredArrayUsingPredicate:resultPredicate];
//        //  searchResults = [fulldoctorlist filteredArrayUsingPredicate:resultPredicate];
//    
    
    
    NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"Name", searchText];//keySelected is NSString itself
//    NSLog(@"predicate %@",predicateString);
    filteredArray = [NSMutableArray arrayWithArray:[APIDATA filteredArrayUsingPredicate:predicateString]];
//    NSLog(@"Filter array %@",filteredArray);
    
    
    //[filterData removeAllObjects];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [Localytics tagEvent:@"SearchSurgeryClick"];
    [self.searchDisplayController setActive:NO animated:NO];
    //    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
//    NSLog(@"Search string = %@",searchString);
 
    
    return YES;
}


- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
//    NSLog(@"Enter = searchDisplayControllerDidEndSearch");
    searchStart = false;
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    controller.searchBar.showsCancelButton = YES;
    NSLog(@" searchDisplayControllerDidEndSearch");
    
    
}
- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
     NSLog(@"Enter = searchDisplayControllerDidBeginSearch");
    searchStart = true;
 //   [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    //controller.searchBar.showsCancelButton = YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
     NSLog(@"Enter = textDidChange, searchtext= %@",searchText);
    if (searchText.length>=3) {
//        NSLog(@"String length greater than 3");
        SearchString = searchText;
        
        server *obj = [[server alloc] init];
        if(obj.connection){
            obj.connection = nil;
        }
        searchStart = true;
        [self performSelector:@selector(ApiCalling) withObject:nil afterDelay:.000];
    }else{
        server *obj = [[server alloc] init];
        if(obj.connection){
            obj.connection = nil;
        }
    }
    if (searchText.length==0) {
        searchStart = false;
        [filteredArray removeAllObjects];
        [APIDATA removeAllObjects];
 //       _tableView = [[UITableView alloc]init];
         [self loadInfo];
      //  [self.tableView reloadData];
    }else{
        searchStart = true;
    }
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarShouldBeginEditing ");
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor whiteColor],
                                                                                                  NSForegroundColorAttributeName,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
    
    
    return YES;
}


//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (![searchBar isFirstResponder]) {
//        // User tapped the 'clear' button.
//        //shouldBeginEditing = NO;
//        [self.searchDisplayController setActive:NO];
//        // [self.mapView removeAnnotation:selectedPlaceAnnotation];
//    }
//}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger tablecount;
    if (searchStart) {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            tablecount = [filteredArray count];
        }
    }else{
        tablecount  = self.FetchedData.count;
    }

    return tablecount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  // NSLog(@"cellForRowAtIndexPath");
    //CustomSearchTableViewCell *cell;
    static NSString *CellIdentifier = @"CustomTableCells";
    //UITableViewCell *cell = (UITableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CustomSearchTableViewCell *cell = (CustomSearchTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
  
    // Configure the cell...
    if (cell == nil) {
        
        cell = [[CustomSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        UILabel *lbltype = [[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width-85, (cell.frame.size.height-20)/2, 75, 20)];
        lbltype.tag = 222;
        lbltype.backgroundColor = [UIColor whiteColor];
        lbltype.textColor = [UIColor colorWithRed:214.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0];
        lbltype.font = [UIFont systemFontOfSize:15.0];
        lbltype.textAlignment = NSTextAlignmentRight;
         [cell.contentView addSubview:lbltype];
        CGRect frame = cell.textLabel.frame;
        frame.size.width =cell.frame.size.width-90;
        UILabel *lblName = [[UILabel alloc]init];
        lblName.frame = CGRectMake(15, (cell.frame.size.height-22)/2, self.tableView.frame.size.width-95, 22);
        lblName.tag = 221;
        lblName.backgroundColor = [UIColor whiteColor];
        lblName.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
        lblName.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightLight];
        lblName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
//    NSString *Datatype;
    NSInteger type;
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
    if (searchStart) {
        type = [[[filteredArray objectAtIndex:indexPath.row]valueForKey:@"Type"]integerValue];
        UILabel *lbltype = (UILabel*)[cell viewWithTag:222];
        UILabel *lblname = (UILabel*)[cell viewWithTag:221];
        lblname.text =[filteredArray objectAtIndex:indexPath.row][@"Name"];
        lblname.text= [self RemoveLeadingAndTrailingSpace:lblname.text];
        lbltype.text = [self getValueBasedOnType:type];
      //  lblname.backgroundColor = [UIColor yellowColor];
        return cell;
    }else{
        UILabel *lbltype = [cell viewWithTag:222];
        UILabel *lblname = [cell viewWithTag:221];
        
        NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"name"];
//        NSInteger indexOfID = [self.dbManager.arrColumnNames indexOfObject:@"id"];
        NSInteger indexOfType = [self.dbManager.arrColumnNames indexOfObject:@"type"];
        
        lblname.text =[[self.FetchedData objectAtIndex:indexPath.row]objectAtIndex:indexOfName];
        lblname.text= [self RemoveLeadingAndTrailingSpace:lblname.text];
        lbltype.text = [self getValueBasedOnType:[[[self.FetchedData objectAtIndex:indexPath.row]objectAtIndex:indexOfType]integerValue]];
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:70.0f];
        cell.delegate = self;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ProcedureListViewController *docList= [self.storyboard instantiateViewControllerWithIdentifier:@"ProcedureListViewController"];
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    if (searchStart) {
        tempArr = APIDATA;
        searchName = [APIDATA objectAtIndex:indexPath.row][@"Name"];
        searchtype = [APIDATA objectAtIndex:indexPath.row][@"Type"];
        searchtypeid = [APIDATA objectAtIndex:indexPath.row][@"Id"];
         [self saveInfo];
    }else{
//        NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"Name"];
//        NSInteger indexOfID = [self.dbManager.arrColumnNames indexOfObject:@"id"];
//        NSInteger indexOfType = [self.dbManager.arrColumnNames indexOfObject:@"Type"];
//        tempArr = self.FetchedData.mutableCopy;
        
        for (int i=0; i<self.FetchedData.count; i++) {
            NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"name"];
            NSInteger indexOfID = [self.dbManager.arrColumnNames indexOfObject:@"id"];
            NSInteger indexOfType = [self.dbManager.arrColumnNames indexOfObject:@"type"];
            NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
            [temp setObject:[[self.FetchedData objectAtIndex:i]objectAtIndex:indexOfName] forKey:@"Name"];
            [temp setObject:[[self.FetchedData objectAtIndex:i]objectAtIndex:indexOfType] forKey:@"Type"];
            [temp setObject:[[self.FetchedData objectAtIndex:i]objectAtIndex:indexOfID] forKey:@"Id"];            
            [tempArr addObject:temp];
        }
    }
    
    if (([[tempArr objectAtIndex:indexPath.row][@"Type"]integerValue])==1)
      {
        NSArray *words = [[tempArr objectAtIndex:indexPath.row][@"Name"] componentsSeparatedByString: @" "];
//        NSLog(@"Array word count: %ld",(long)words.count);
        NSMutableDictionary *newDicOfDocDetails = [[NSMutableDictionary alloc]init];
        if (words.count>2) {
            [newDicOfDocDetails setObject:[words objectAtIndex:0] forKey:@"FirstName"];
            // NSString *midName=@"";
            NSString *midName = [[NSString alloc] init];
            for (int i=1; i<words.count-1; i++) {
                //[midName appendString:[words objectAtIndex:i]];
                midName = [midName stringByAppendingString:[NSString stringWithFormat:@"%@ ",[words objectAtIndex:i]]];
            }
            [newDicOfDocDetails setObject:midName forKey:@"MiddleName"];
            [newDicOfDocDetails setObject:[words objectAtIndex:[words count]-1] forKey:@"LastName"];
        }
        else if(words.count==2){
            [newDicOfDocDetails setObject:[words objectAtIndex:0] forKey:@"FirstName"];
            [newDicOfDocDetails setObject:[words objectAtIndex:1] forKey:@"LastName"];
            
        }else if(words.count==1){
            [newDicOfDocDetails setObject:[words objectAtIndex:0] forKey:@"FirstName"];
        }
        
        docList.DocData = newDicOfDocDetails;
//        NSLog(@"Doctor data sent to doclist view %@",newDicOfDocDetails);
        docList.ShowDataFor = @"doctor";
        docList.ProName = [tempArr objectAtIndex:indexPath.row][@"Name"];
//        NSInteger  type = [[[filteredArray objectAtIndex:indexPath.row]valueForKey:@"Type"]integerValue];
//          NSString *typeString=[self getValueBasedOnType:type];
//          if ([typeString isEqualToString:@"Procedure"]) {
//              
//          }
//          else if ([typeString isEqualToString:@"Hospital"]) {
//              
//          }
//          else if ([typeString isEqualToString:@"Doctor"]) {
//              
//          }
//          else{
//              
//          }
          [Localytics tagEvent:@"SearchSurgeryDocClick"];
        [self.navigationController pushViewController:docList animated:YES];
      }

    else if (([[tempArr objectAtIndex:indexPath.row][@"Type"]integerValue])==2) {
        [Localytics tagEvent:@"SearchHospitalClick"];
        HospitalSearchViewController *HospitalList = [self.storyboard instantiateViewControllerWithIdentifier:@"HospitalSearchList"];
//        NSLog(@"search result: %@",[tempArr objectAtIndex:indexPath.row][@"Name"]);
        HospitalList.hosName = [tempArr objectAtIndex:indexPath.row][@"Name"];
        [self.navigationController pushViewController:HospitalList animated:YES];

    }
    
    else if (([[tempArr objectAtIndex:indexPath.row][@"Type"]integerValue])==3) {
        [Localytics tagEvent:@"SearchSurgeryDocClick"];
        docList.ShowDataFor = @"pro";
        docList.ProName = [tempArr objectAtIndex:indexPath.row][@"Name"];
        docList.ProId = [tempArr objectAtIndex:indexPath.row][@"Id"];
        [self.navigationController pushViewController:docList animated:YES];
    }
}




-(NSString*)getValueBasedOnType:(NSInteger)type{
    NSString *Datatype;
    if (type==1) {
        Datatype = @"Doctor";
    }else if (type==2){
        Datatype = @"Hospital";
    }else if(type==3){
        Datatype = @"Procedure";
    }else{
        Datatype = @"";
    }
    return Datatype;
}


#pragma mark - API Calling

-(void)ApiCalling{
   // [[AppDelegate MyappDelegate] showIndicator];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kGetSearchList], keyRequestType,nil];
    
    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userdef objectForKey:AuthKey],AuthKey,SearchString,@"search",nil];
    
//    NSLog(@"dataDic for custom Search: %@",dataDic);
    server *obj = [[server alloc] init];
    currentRequestType = kGetSearchList;
    obj.delegate = self;
    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"APICalling");
}
#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
//    NSLog(@"custom Search Controller requestFinished for %d",currentRequestType);
}

#pragma mark - result methods for login service
- (void) result:(NSDictionary *)response

{
//   NSLog(@"response = %@",response);
    
//    NSLog(@"custom Search status1 message");
    
    
    if (currentRequestType==kGetSearchList) {
        NSMutableArray *resposeCode=[response objectForKey:@"SearchList"];
        [[AppDelegate MyappDelegate]hideIndicator];
        status = [[response objectForKey:@"Status"]integerValue];
        if (status==1) {
            if ([resposeCode count]>0)
            {
//                NSLog(@"Search have data");//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
                APIDATA = resposeCode;
                [self searchDisplayController:self.searchDisplayController shouldReloadTableForSearchString:SearchString];
                _tableView = self.searchDisplayController.searchResultsTableView;
                 [self.tableView reloadData];
            }else{
                
            }
        }else if (status==7){
            NSString *msg = [response objectForKey:@"Message"];
            [self ViewSlideDown:msg];
            [APIDATA removeAllObjects];
        }else if (status==0){
            NSString *msg = [response objectForKey:@"Message"];
            [self ViewSlideDown:msg];
        }
        else if (status == 10){
            userdef =userDefault;
            [userdef setObject:@"No" forKey:isLogin];
            ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_Login"];
            [self.navigationController pushViewController:login animated:YES];
        }

    }
}



- (void) requestError
{
//    NSLog(@"RegisterViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
   [self ViewSlideDown:@"Something went wrong"];
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
  /*  [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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

-(NSString *)RemoveLeadingAndTrailingSpace:(NSString*)str{
    NSString *squashed = [str stringByReplacingOccurrencesOfString:@"[ ]+"
                                                        withString:@" "
                                                           options:NSRegularExpressionSearch
                                                             range:NSMakeRange(0, str.length)];
    
    NSString *final = [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return final;
}



- (void)saveInfo{
    // Prepare the query string.
    NSString *query = [NSString stringWithFormat:@"INSERT INTO searchRecord (user_id,id,name,type) VALUES('%@', '%@','%@','%@')",[userdef objectForKey:User_id],searchtypeid?searchtypeid:@"",searchName?searchName:@"",searchtype?searchtype:@""];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
//        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
    }
    else{
//        NSLog(@"Could not execute the query.");
    }
}


- (void)loadInfo{
    // Prepare the query string.
//    NSString *query = [NSString stringWithFormat:@"INSERT INTO searchRecord (user_id,id,Name,Type) VALUES('%@', '%@','%@','%@')",[userdef objectForKey:User_id],searchtypeid?searchtypeid:@"",searchName?searchName:@"",searchtype?searchtype:@""];
    
    
     NSString *fetchQuery = [NSString stringWithFormat:@"SELECT DISTINCT name,type,id  FROM searchRecord WHERE user_id='%@' ORDER BY rowid  DESC  LIMIT 5",[userdef objectForKey:User_id]];
    
    // Execute the query.
    if (self.FetchedData != nil) {
        self.FetchedData = nil;
    }
    self.FetchedData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:fetchQuery]];
}



- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
   
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.00f green:0.1f blue:0.1f alpha:1.0] title:@"Delete"];

    return rightUtilityButtons;
}


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


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    switch (index) {
        case 0:
        {

//            NSLog(@"cancel button was pressed on cell : %ld",(long)cellIndexPath.row);
            
            [self deleteSearchRecord:[[self.FetchedData objectAtIndex:cellIndexPath.row]objectAtIndex:2]];
            break;
           
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


-(void)deleteSearchRecord:(NSString*)identy{
    NSString *query = [NSString stringWithFormat:@"DELETE FROM searchRecord WHERE id='%@'",identy];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
//        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        [self loadInfo];
        [self.tableView reloadData];
        
    }
    else{
//        NSLog(@"Could not execute the query.");
    }

    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
