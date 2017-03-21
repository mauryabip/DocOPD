//
//  AllTimingsViewController.m
//  docOPD
//
//  Created by Virinchi Software on 10/31/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "AllTimingsViewController.h"
#import "AllTimingsTableViewCell.h"
#import "GAI.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
@interface AllTimingsViewController ()

@end

@implementation AllTimingsViewController
@synthesize AvailDic;
- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES];
    self.LblSeperator.backgroundColor = [UIColor dOPDTFBorderColor];
    self.LblHeaderTitle.text = self.DataFor;
    self.LblDoctorName.text = self.DataForDoctor;
}
-(void)viewWillAppear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:YES];
   // NSString *name = [NSString stringWithFormat:@"Pattern~Doctor-Search"];
//    self.trackedViewName = @"About Screen";
//    [self.navigationController setNavigationBarHidden:YES];
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker set:kGAIScreenName value:self.trackedViewName];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"Doctor all timing"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //self.trackedViewName =[NSString stringWithFormat:@"All Timing Screen for %@",self.LblDoctorName.text];
    [[GAI sharedInstance] defaultTracker];
    self.screenName =[NSString stringWithFormat:@"All Timing Screen for %@",self.LblDoctorName.text];
    [self.tracker set:kGAIScreenName
           value:self.screenName];
    
    // manual screen tracking
    [self.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


-(void)viewWillDisappear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)DismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;


}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllTimingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [self configureView:cell.ViewDayBack];
    cell.LblDayNameInitial.textColor = [UIColor whiteColor];
    cell.LblDayNameInitial.text = [self SetValueForDayInitial:indexPath.row];
    
//    NSRange range = [[allday objectAtIndex:indexPath.row]rangeOfString:@","];
    NSRange range = [[AvailDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]]rangeOfString:@","];
    if (range.location != NSNotFound)
    {
        if ([self findDay]==indexPath.row+1) {
            cell.LblDayTiming.font = [UIFont boldSystemFontOfSize:16.0];
            cell.LblDayNameInitial.font =[UIFont boldSystemFontOfSize:19.0];
        }
        
    //    NSLog(@"found");
        items = [[AvailDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]] componentsSeparatedByString:@","];
        NSString *d,*f;
        for (int i=0; i<items.count; i++) {
            d= [items objectAtIndex:i];
            if (i==0) {
            f=  d;
            }else{
                f=  [NSString stringWithFormat:@"%@ \n%@",f,d];
            }
            
        }
       // NSLog(@"%@",f);
        
        cell.LblDayTiming.text = f;
        cell.LblDayTiming.numberOfLines=0;
        [cell.LblDayTiming sizeToFit];
  
    }
    else{
        if ([self findDay]==indexPath.row+1) {
            cell.LblDayTiming.font = [UIFont boldSystemFontOfSize:15.0];
            cell.LblDayNameInitial.font =[UIFont boldSystemFontOfSize:21.0];
        }
        cell.LblDayTiming.text = [AvailDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]];
       // NSLog(@"Not found");
    }
    
    cell.LblDayTiming.textColor = [UIColor dOPDTextFontColor];
        return cell;
}


-(void)configureView:(UIView*)View{
    CGFloat redLevel    = rand() / (float) RAND_MAX;
    CGFloat greenLevel  = rand() / (float) RAND_MAX;
    CGFloat blueLevel   = rand() / (float) RAND_MAX;

    View.backgroundColor = [UIColor colorWithRed: redLevel
                                             green: greenLevel
                                              blue: blueLevel
                                             alpha: 1.0];
    
    
    View.layer.cornerRadius = View.layer.frame.size.width/2;
}

-(NSString*)SetValueForDayInitial:(NSInteger)Day{
    NSString *DayInitial;
    switch (Day) {
        case 0:
            DayInitial = @"S";
            break;

        case 1:
            DayInitial = @"M";
            break;
            
        case 2:
            DayInitial = @"T";
            break;
            
        case 3:
            DayInitial = @"W";
            break;
            
        case 4:
            DayInitial = @"T";
            break;
            
        case 5:
            DayInitial = @"F";
            break;
            
        case 6:
            DayInitial = @"S";
            break;
            
        default:
           // NSLog(@"Invalid Day");
            break;
    }
    return DayInitial;
    
}






-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSRange range = [[AvailDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]] rangeOfString:@","];
    NSInteger size ;
    if (range.location != NSNotFound)
    {
        NSInteger a=  items.count;
        size = a*20+20;
    }
    else{
        size = 60.0;
    }
    return size;
}

-(NSInteger)findDay{

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday];
    return weekday;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end




