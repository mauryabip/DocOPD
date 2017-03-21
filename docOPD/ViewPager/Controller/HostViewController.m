//
//  HostViewController.m
//  CKViewPager
//
//  Created by Lucas Oceano on 11/03/2015.
//  Copyright (c) 2015 Lucas Oceano Martins. All rights reserved.
//
#import "HostViewController.h"
#import "ContentViewController.h"

@interface HostViewController () <ViewPagerDataSource, ViewPagerDelegate>

@property(nonatomic) NSUInteger numberOfTabs;

@property(nonatomic, strong) NSMutableArray * titlesLabels;
@end

@implementation HostViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.dataSource = self;
	self.delegate = self;

	self.title = @"View Pager";
   self.titlesLabels = [[NSMutableArray alloc] init];
  // Keeps tab bar below navigation bar on iOS 7.0+
	// if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
	//     self.edgesForExtendedLayout = UIRectEdgeNone;
	// }
    self.tabsViewBackgroundColor = [UIColor dOPDThemeColor];
	self.indicatorColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
	//self.tabsViewBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.32];
	//self.contentViewBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.32];
    self.contentViewBackgroundColor = [[UIColor dOPDThemeColor] colorWithAlphaComponent:1.0];
  self.dividerColor = [UIColor blackColor];

  self.startFromSecondTab = NO;
	self.centerCurrentTab = NO;
	self.tabLocation = ViewPagerTabLocationTop;
	self.tabHeight = 49;
	self.tabOffset = 36;
//	self.tabWidth = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 128.0f : 96.0f;
	self.tabWidth = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 128.0f : [UIScreen mainScreen].bounds.size.width/2;
    self.fixFormerTabsPositions = NO;
	self.fixLatterTabsPositions = NO;
    self.shouldShowDivider = YES;
	self.shouldAnimateIndicator = ViewPagerIndicatorAnimationWhileScrolling;

	self.numberOfTabs = 2;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tab #5" style:UIBarButtonItemStylePlain target:self action:@selector(selectTabWithNumberFive)];
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self performSelector:@selector(loadContent) withObject:nil afterDelay:0.0];
}


- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


#pragma mark - Setters


- (void)setNumberOfTabs:(NSUInteger)numberOfTabs
{

	// Set numberOfTabs
	_numberOfTabs = numberOfTabs;

	// Reload data
	[self reloadData];

}


#pragma mark - Helpers


- (void)selectTabWithNumberFive
{
	[self selectTabAtIndex:5];
}


- (void)loadContent
{
	self.numberOfTabs = 2;
}


#pragma mark - Interface Orientation Changes


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

	// Update changes after screen rotates
	[self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}


#pragma mark - ViewPagerDataSource


- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
	return self.numberOfTabs;
}


- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
	UILabel *label = [UILabel new];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont systemFontOfSize:14.0];
	label.text = [NSString stringWithFormat:@"Tab #%i", index];
    if (index==0) {
        label.text = @"HISTORY";
    }else if (index==1){
        label.text = @"ENQUIRY";
    }
    
    
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor blackColor];
	[label sizeToFit];

  [self.titlesLabels insertObject:label atIndex:index];

	return label;
}


- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{

	ContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    
	cvc.labelString = [NSString stringWithFormat:@"Content View #%i", index];
    cvc.currentindex = index;
	return cvc;
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    ContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    //cvc.delegate = self;
//    [self.delegates currentIndex:index];
    cvc.currentindex = index;
//    NSLog(@"index1 = %u", index);
  for (UILabel *label in self.titlesLabels){
    label.textColor = [UIColor blackColor];
  }
  UILabel *label = self.titlesLabels[index];
  label.textColor = [UIColor blueColor];
    label.textColor = [UIColor whiteColor];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
