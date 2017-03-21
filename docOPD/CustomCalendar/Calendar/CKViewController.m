#import <CoreGraphics/CoreGraphics.h>
#import "CKViewController.h"
#import "CKCalendarView.h"

@interface CKViewController () <CKCalendarDelegate>
@property (strong, nonatomic) IBOutlet UILabel *LblDocName;

@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;

//@property(nonatomic) NSInteger minDateMon;//ashutosh
//@property(nonatomic) NSInteger currentVisibleMon;//ashutosh
//@property(nonatomic, strong) NSDateFormatter *visibleMonthFormatter;//ashutosh
@property(nonatomic, strong) NSMutableArray *disabledDates;

@end
@protocol SendInfoToBack <NSObject>

-(void)selectedDate:(NSString*)Date weekDay:(NSInteger)Day;

@end
@implementation CKViewController
@synthesize delegate;
- (id)init {
    self = [super init];
    if (self) {
        self.LblDocName.text = self.doctorname;
        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
        self.calendar = calendar;
        calendar.delegate = self;
        NSDate *date = [NSDate date];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *datefind = [self.dateFormatter stringFromDate:date];
     //   [self.dateFormatter setDateFormat:@"dd-MM-yyyy"];
       // self.minimumDate = [self.dateFormatter dateFromString:datefind];
        self.minimumDate = [date dateByAddingTimeInterval:-1*24*60*60];
        
       
        self.disabledDates = [[NSMutableArray alloc]init];
//        self.disabledDates = @[
//                [self.dateFormatter dateFromString:@"05/10/2015"],
//                [self.dateFormatter dateFromString:@"16/11/2015"],
//                [self.dateFormatter dateFromString:@"07/10/2015"]
//        ];

        calendar.onlyShowCurrentMonth = YES;
        calendar.adaptHeightToNumberOfWeeksInMonth = YES;

        //Calculate the date by the Day i.e Monday = 26-10-25
        NSDate *pickerDate = [NSDate date];
//         NSLog(@"pickerDate: %@", pickerDate);
        
        NSDateComponents *dateComponents;
        NSCalendar *calendarFormonday = [NSCalendar currentCalendar];

        dateComponents = [calendarFormonday components:NSWeekdayCalendarUnit fromDate:pickerDate];
//        NSInteger firstMondayOrdinal = 11 - [dateComponents weekday];
//        dateComponents = [[NSDateComponents alloc] init];
//        [dateComponents setDay:firstMondayOrdinal];
//       
//        
        dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setWeekOfMonth:1];
     ////============================================================================================================================
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        //NSDate *date = [NSDate date];
        NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:pickerDate];
        NSInteger todayWeekday = [weekdayComponents weekday];
        
        for (int bd=0; bd<self.NADay.count; bd++)
        {
            NSInteger daynum= [self findDay:[NSString stringWithFormat:@"%@",[self.NADay objectAtIndex:bd]]] ;
            NSInteger moveDays=daynum-todayWeekday;
            if (moveDays<0) {
                moveDays+=7;
            }
            
            NSDateComponents *components = [NSDateComponents new];
            components.day=moveDays;
            NSCalendar *calendarv=[[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
            NSDate* newDate = [calendarv dateByAddingComponents:components toDate:date options:0];
//            NSLog(@"New Date%@",newDate);
            for (int i=0; i<15; i++) {
                [dateComponents setWeekOfMonth:i];
                 //[dateComponents setWeekday:i];
                NSDate *blockdayDate = [calendarFormonday dateByAddingComponents:dateComponents toDate:newDate options:0];
                NSString *blockdayStr = [self.dateFormatter stringFromDate:blockdayDate];
               // NSDateFormatter *newDateFormat = [[NSDateFormatter alloc] init];
//                [newDateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
               // [self.disabledDates addObject:mondayDate];
               [self.disabledDates addObject:[self.dateFormatter dateFromString:blockdayStr]];
            }
        }
            
            
    //    calendar.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/10, ([UIScreen mainScreen].bounds.size.height-320)/2, [UIScreen mainScreen].bounds.size.width-([UIScreen mainScreen].bounds.size.width/5), 320);
        
      calendar.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 400);
        
        calendar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:calendar];

        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
        [self.view addSubview:self.dateLabel];

        self.view.backgroundColor = [UIColor whiteColor];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self init];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
//        dateItem.backgroundColor = [UIColor redColor];
//        dateItem.textColor = [UIColor whiteColor];
        
        dateItem.textColor = [UIColor lightGrayColor];
        
    }
    
    if([date laterDate:_minimumDate] == _minimumDate) {
      dateItem.textColor = [UIColor grayColor];
       //  dateItem.textColor = [UIColor greenColor];
    }
    
}

//- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
//    if ([date laterDate:minimumDate] == minimumDate) {
//        return NO;
//    }
//    return [calendar dateIsInCurrentMonth:date];
//}


- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    if ([date laterDate:_minimumDate] == _minimumDate) {
        return NO;
    }
    else if([self dateIsDisabled:date]){
     return ![self dateIsDisabled:date];
    }
    else{
        return [calendar dateIsInCurrentMonth:date];
    }
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSDateFormatter *newDateFormat = [[NSDateFormatter alloc] init];
    [newDateFormat setDateFormat:@"dd MMM yyyy"];
    //NSString *finalDate = [newDateFormat stringFromDate:date];
    
    self.dateLabel.text = [newDateFormat stringFromDate:date];
    
//    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    weekday = [comps weekday];

    [delegate selectedDate:self.dateLabel.text weekDay:weekday];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate]== date) {
//        self.calendar.backgroundColor = [UIColor blueColor];ashutosh change
        self.calendar.backgroundColor = [UIColor whiteColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor whiteColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
//    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

- (IBAction)didPressCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressDoneButton:(id)sender {
 
    [delegate selectedDate:self.dateLabel.text weekDay:weekday];
      [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSInteger)findDay:(NSString*)day{
    NSInteger daynumber;
    if ([day isEqualToString:@"Sunday"] || [day isEqualToString:@"DocSunday"]) {
        daynumber = 1;
    }else if ([day isEqualToString:@"Monday"]|| [day isEqualToString:@"DocMonday"]) {
        daynumber = 2;
    }else if ([day isEqualToString:@"Tuesday"]|| [day isEqualToString:@"DocTuesday"]) {
        daynumber = 3;
    }else if ([day isEqualToString:@"Wednesday"]|| [day isEqualToString:@"DocWednesday"]) {
        daynumber = 4;
    }else if ([day isEqualToString:@"Thursday"]|| [day isEqualToString:@"DocThursday"]) {
        daynumber = 5;
    }else if ([day isEqualToString:@"Friday"]|| [day isEqualToString:@"DocFriday"]) {
        daynumber = 6;
    }else if ([day isEqualToString:@"Saturday"]|| [day isEqualToString:@"DocSaturday"]) {
        daynumber = 7;
    }
    
    
    return daynumber;
}


@end
