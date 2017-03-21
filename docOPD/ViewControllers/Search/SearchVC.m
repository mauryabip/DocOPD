//
//  SearchVC.m
//  docOPD
//
//  Created by Ashutosh Kumar on 8/3/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "SearchVC.h"
#import "DocProfileVC.h"
#import "DoctorsListVC.h"
//#import  "HospitalTableViewCell.h"
#import "HospListVC.h"
#import "HospitalSearchViewController.h"
#import "ProcedureListViewController.h"
typedef enum{
    kTAG_DoctorBtn = 1,
    kTAG_HospitalBtn,
    kTAG_ProcedureBtn,
}ALLTAGS;
@interface SearchVC ()

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES];
//    NSLog(@"come from of : %ld", (long)ShowData);
   filterData = [[NSMutableArray alloc]init];
   searchResults = [[NSArray alloc]init];
    fulldoctorlist = [[NSMutableArray alloc]init];

//    UITextField *textField = [self.searchBar valueForKey: @"_searchField"];
//    [textField setTextColor:[UIColor redColor]];
//    [textField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
    
    //Data for Doctor
    
   // DoctorData = [[NSMutableArray alloc]initWithObjects:@"Sudhir Kumar Sinha",@"Manoj Kumar Mishra",@"Shashi Shekhar Rawat",@"Pramod Singh",@"Manoj Sinha",@"Hardik Kumar",@"Naresh Singh Rawat",@"Sekhar Singh Mishra",@"Neeraj Gupta",@"Rajiv Anand",@"Rajiv Gupta",@"Neeraj Singh",@"Abha Arora",@"Pankaj Aneja", nil];
   
    DoctorData = [[NSMutableArray alloc]init];
    
    NSMutableArray *doclist = [[NSMutableArray alloc]init];
    doclist = [AppDelegate MyappDelegate].allDocList;
    fulldoctorlist = [AppDelegate MyappDelegate].allDocList;
//    NSLog(@"diclist count is = %d",doclist.count);
    NSString *DocFullName;
    for (int i=0; i<doclist.count; i++) {
        
        if ([[doclist objectAtIndex:i][@"MiddleName"] isEqualToString:@""] || [[doclist objectAtIndex:i][@"MiddleName"] isKindOfClass:[NSNull class]] ) {
        
         DocFullName = [NSString stringWithFormat:@"%@ %@",[doclist objectAtIndex:i][@"FirstName"],[doclist objectAtIndex:i][@"LastName"]];
        }
        else{
             DocFullName = [NSString stringWithFormat:@"%@ %@ %@",[doclist objectAtIndex:i][@"FirstName"],[doclist objectAtIndex:i][@"MiddleName"],[doclist objectAtIndex:i][@"LastName"]];
        }
        [DoctorData addObject:DocFullName];
       // NSLog(@"docfull name: %@",DocFullName);
    }
//    
    
    //Data for Hospital
//     HospitalData = [[NSMutableArray alloc]initWithObjects:@"B.L Kapoor",@"Paras HMRI",@"MAX Hospital",@"Fortis Escorts Hospital",@"Indraprastha Apollo Hospital",@"Batra Hospital & Research Center",@"Saket City Hospital",@"Pushpawati Singhania Research Institute",@"Rockland Hospital",@"RG Stone Clinic",@"Sushrut Trauma Centre",@"Tirath Ram Shah Charity",@"Vasant Lok Hospital",@"Pushpanjali Medical Center",@"M.G.S Hospital", nil];
    
    HospitalData = [[NSMutableArray alloc]init];

    NSMutableArray *hospList = [[NSMutableArray alloc]init];
    hospList = [AppDelegate MyappDelegate].allHospList;
    
//    NSLog(@"hospitl list count is = %lu",(unsigned long)hospList.count);
    for (int i=0; i<hospList.count; i++) {
        NSString *hospName = [NSString stringWithFormat:@"%@",[hospList objectAtIndex:i][@"HospitalName"]];
        [HospitalData addObject:hospName];
    }
    
    
    //Data for Procedure
//    ProcedureData = [[NSMutableArray alloc]initWithObjects:@"Amyloidosis",@"Balo disease",@"Behcet’s disease",@"Cardiomyopathy",@"Celiac disease",@"Chagas disease",@"Crohn’s disease",@"CREST disease",@"Dermatomyositis",@"Endometriosis",@"Granulomatosis",@"Meniere’s disease",@"Myositis",@"Optic neuritis",@"Interstitial cystitis",@"Neutropenia", nil];

    ProcedureData = [[NSMutableArray alloc]init];
    
    procedureList = [[NSMutableArray alloc]init];
    procedureList = [AppDelegate MyappDelegate].allProcedureList;
    
//    NSLog(@"procedure list count is = %d",procedureList.count);
    for (int i=0; i<procedureList.count; i++) {
        NSString *procName = [NSString stringWithFormat:@"%@",[procedureList objectAtIndex:i][@"ProcedureName"]];
        [ProcedureData addObject:procName];
    }

    
     [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder ];
     [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger tablecount;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tablecount = [searchResults count];
    }
    else if (ShowData==kTAG_DoctorBtn)
    {
//    NSLog(@"Doctor data count: %d", DoctorData.count);
//     tablecount = [DoctorData count];
//        NSLog(@"Doctor data count: %d", fulldoctorlist.count);
        tablecount = [fulldoctorlist count];
        
        
    
    }
    else if(ShowData == kTAG_HospitalBtn){
//        NSLog(@"Hospital data count: %d", HospitalData.count);
        tablecount = [HospitalData count];
    }
    else if(ShowData ==kTAG_ProcedureBtn){
//        NSLog(@"Procedure data count: %d", ProcedureData.count);
        tablecount = [ProcedureData count];
    }
    return tablecount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *CellIdentifier = @"CustomTableCell";
    cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if (tableView == self.searchDisplayController.searchResultsTableView) {
         cell.textLabel.text =[searchResults objectAtIndex:indexPath.row];
    }
    else {
        
        if (ShowData==kTAG_DoctorBtn) {
           // cell.textLabel.text =[DoctorData objectAtIndex:indexPath.row];
        
            if ([[fulldoctorlist objectAtIndex:indexPath.row][@"MiddleName"] isEqualToString:@""] || [[fulldoctorlist objectAtIndex:indexPath.row][@"MiddleName"] isKindOfClass:[NSNull class]] ) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[fulldoctorlist objectAtIndex:indexPath.row][@"FirstName"],[fulldoctorlist objectAtIndex:indexPath.row][@"LastName"]];
//                NSLog(@"Middle name not found for %@",cell.textLabel.text);
                
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[fulldoctorlist objectAtIndex:indexPath.row][@"FirstName"],[fulldoctorlist objectAtIndex:indexPath.row][@"MiddleName"],[fulldoctorlist objectAtIndex:indexPath.row][@"LastName"]];
            }
            
            
        }else if(ShowData == kTAG_HospitalBtn) {
            cell.textLabel.text =[HospitalData objectAtIndex:indexPath.row];
        }
        else if(ShowData == kTAG_ProcedureBtn) {
            cell.textLabel.text =[NSString stringWithFormat:@"%@",[procedureList objectAtIndex:indexPath.row][@"ProcedureName"]];
        }

    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    docName = [DoctorData objectAtIndex:indexPath.row];
    
    if (ShowData == kTAG_DoctorBtn) {
 //       DoctorsListVC *docList= [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_DocList"];
        ProcedureListViewController *docList= [self.storyboard instantiateViewControllerWithIdentifier:@"ProcedureListViewController"];
 //       docList.dataShowFor = @"doctor";
        docList.ShowDataFor = @"doctor";
        
        if (searchStart) {
//            NSLog(@"search result: %@",[searchResults objectAtIndex:indexPath.row]);
//            NSUInteger wordcount = [self jacWordCount:[searchResults objectAtIndex:indexPath.row]];
//            NSLog(@"Word count is %d",wordcount);
            NSArray *words = [[searchResults objectAtIndex:indexPath.row] componentsSeparatedByString: @" "];
//            NSLog(@"Array word count: %d",words.count);
            NSMutableDictionary *newDicOfDocDetails = [[NSMutableDictionary alloc]init];
            if (words.count>2) {
                [newDicOfDocDetails setObject:[words objectAtIndex:0] forKey:@"FirstName"];
               // NSString *midName=@"";
                NSMutableString *midName = [[NSMutableString alloc] init];
                for (int i=1; i<words.count-1; i++) {
                    [midName appendString:[words objectAtIndex:i]];
                    //midName = [NSString stringWithFormat:@"%@ %@",midName,[words objectAtIndex:i]];
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
//            NSLog(@"Doctor data sent to doclist view %@",newDicOfDocDetails);
            
        }else{
            
            docList.firstName = [fulldoctorlist objectAtIndex:indexPath.row][@"FirstName"];
            docList.middleName = [fulldoctorlist objectAtIndex:indexPath.row][@"MiddleName"];
            docList.lastName = [fulldoctorlist objectAtIndex:indexPath.row][@"LastName"];
            
            docList.DocData = [fulldoctorlist objectAtIndex:indexPath.row];
//            NSLog(@"Doctor data sent to doclist view %@",[fulldoctorlist objectAtIndex:indexPath.row]);
        }
        
        [self.navigationController pushViewController:docList animated:YES];

    }
    else if (ShowData == kTAG_HospitalBtn){
        
      //  HospListVC *HospitalList= [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_HospList"];
        HospitalSearchViewController *HospitalList = [self.storyboard instantiateViewControllerWithIdentifier:@"HospitalSearchList"];
        if (searchStart) {
//            NSLog(@"search result: %@",[searchResults objectAtIndex:indexPath.row]);
            HospitalList.hosName = [searchResults objectAtIndex:indexPath.row];

        }else{
            HospitalList.hosName = [HospitalData objectAtIndex:indexPath.row];
        }
        [self.navigationController pushViewController:HospitalList animated:YES];

    }
    else if(ShowData == kTAG_ProcedureBtn){
//        DoctorsListVC *docList= [self.storyboard instantiateViewControllerWithIdentifier:@"docOPD_DocList"];
//        docList.dataShowFor = @"procedure";
        ProcedureListViewController *procedureListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"ProcedureListViewController"];
         procedureListVC.ShowDataFor = @"pro";
        if (searchStart) {
//            NSLog(@"search result: %@",[searchResults objectAtIndex:indexPath.row]);
            NSString *proName = [searchResults objectAtIndex:indexPath.row];
            NSString *proID;
            for (int i=0; i<procedureList.count; i++)
            {
                if ([[procedureList objectAtIndex:i][@"ProcedureName"] isEqualToString:proName]) {
                    proID =[procedureList objectAtIndex:i][@"ProcedureId"];
//                    NSLog(@"Found");
                    break;
                }
            }
            procedureListVC.ProId = proID;
            procedureListVC.ProName = proName;
        }else{
            procedureListVC.ProName = [procedureList objectAtIndex:indexPath.row][@"ProcedureName"];
             procedureListVC.ProId = [procedureList objectAtIndex:indexPath.row][@"ProcedureId"];
        }
        
        [self.navigationController pushViewController:procedureListVC animated:YES];

    }
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@", searchText];
    
    if (ShowData == kTAG_DoctorBtn) {
        searchResults = [DoctorData filteredArrayUsingPredicate:resultPredicate];
       //  searchResults = [fulldoctorlist filteredArrayUsingPredicate:resultPredicate];
    }
    else if (ShowData == kTAG_HospitalBtn){
        searchResults = [HospitalData filteredArrayUsingPredicate:resultPredicate];
    }
    else if(ShowData == kTAG_ProcedureBtn){
        searchResults = [ProcedureData filteredArrayUsingPredicate:resultPredicate];
    }
    
    if (searchResults.count) {
//        NSLog(@"Yes, search have data and search start is true");
        searchStart = true;
    }else{
//        NSLog(@"Yes, search have no data and search start is false");
        searchStart = false;
    }
    
    [filterData removeAllObjects];
}





-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
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
    
    return YES;
}




- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    controller.searchBar.showsCancelButton = YES;
}
- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
  
     [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    //controller.searchBar.showsCancelButton = YES;
}
//
//-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    NSLog(@"searchBarTextDidBeginEditing -Are we getting here??");
////     [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor greenColor]];
//    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
//    
//}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    NSLog(@"searchBarShouldBeginEditing -Are we getting here??");
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor whiteColor],
                                                                                                  NSForegroundColorAttributeName,
                                                                                                  nil] 
                                                                                        forState:UIControlStateNormal];
    
    return YES;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar isFirstResponder]) {
        // User tapped the 'clear' button.
        //shouldBeginEditing = NO;
        [self.searchDisplayController setActive:NO];
        // [self.mapView removeAnnotation:selectedPlaceAnnotation];
    }
}

-(void)showDataof:(NSInteger)Valueof{
    ShowData = Valueof;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{       NSLog(@"textFieldDidBeginEditing-Are we getting here??");
//        [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
//    
//    UIButton *cancelButton = nil;
//    
//    for(UIView *subView in [self.searchBar subviews])
//    {
//        if([subView isKindOfClass:[UIButton class]])
//        {
//            cancelButton = (UIButton*)subView;
//            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [cancelButton setTitle:@"Text" forState:UIControlStateNormal];
//        }
//    }
//    
//    
//}

-(NSUInteger) jacWordCount: (NSString *) string {
    __block NSUInteger wordCount = 0;
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *character, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                wordCount++;
                            }];
    return wordCount;
}
@end
