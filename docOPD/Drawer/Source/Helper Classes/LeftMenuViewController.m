//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import "ProfileDetailViewController.h"
#import "UIImageView+WebCache.h"
@implementation LeftMenuViewController
@synthesize ImgUser, LblUserName, LblUserMobile;
#pragma mark - UIViewController Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = YES;
	
	return [super initWithCoder:aDecoder];
}
//MyAccountVC
- (void)viewDidLoad
{
	[super viewDidLoad];

    userDef = userDefault;
    self.imgUrl =[userDef valueForKey:userProfileImgUrl];

    NSString *imgNamestr= @"MyProfileImage.png";
    NSString* foofile = [[AppDelegate MyappDelegate].dataPath stringByAppendingPathComponent:imgNamestr];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    if (fileExists) {
         ImgUser.image = [self getImage:imgNamestr];
    }else{
         ImgUser.image = [UIImage imageNamed:@"user.png"];
    }

    
    
    ImgUser.layer.cornerRadius = ImgUser.frame.size.width/2;
    ImgUser.layer.masksToBounds = YES;
    
    self.ViewImgBorder.backgroundColor = [UIColor whiteColor];
    self.ViewImgBorder.layer.borderWidth = 2.0f;
    self.ViewImgBorder.layer.borderColor = [UIColor whiteColor].CGColor;
    self.ViewImgBorder.layer.cornerRadius = self.ViewImgBorder.frame.size.width/2;    
    
    
    self.tableVw.backgroundColor = [UIColor dOPDThemeColor];
    self.tableVw.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableVw.tableFooterView.backgroundColor = [UIColor dOPDThemeColor];
   // self.tableVw.separatorColor = [UIColor clearColor];
   // self.UserInfoView.backgroundColor = [UIColor dOPDThemeColor];
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    LblUserName.numberOfLines = 0;
    LblUserName.text = [userDef valueForKey:Username];
    [LblUserName sizeToFit];
    LblUserMobile.text = [userDef valueForKey:Mobile];
    
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"LeftDrawerScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:@"LeftDrawerScreen"];
}



#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
//	view.backgroundColor = [UIColor clearColor];
//	return view;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	return 20;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    
   //     CGSize size = {22,22};
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    switch (indexPath.row)
	{
        case 0:
            cell.textLabel.text = @"Home";
            //   cell.imageView.image = [self imageWithImage:[UIImage imageNamed:@"search.png"] scaledToSize:size];
            cell.imageView.image = [UIImage imageNamed:@"home.png"];

            break;

        case 1:
			cell.textLabel.text = @"Medical History";
              //cell.imageView.image = [self imageWithImage:[UIImage imageNamed:@"history.png"] scaledToSize:size];
            cell.imageView.image = [UIImage imageNamed:@"history.png"];
            break;
		

        case 2:
            cell.textLabel.text = @"EMR(Medical Records)";
            // cell.imageView.image = [self imageWithImage:[UIImage imageNamed:@"med-Rec.png"] scaledToSize:size];
           cell.imageView.image = [UIImage imageNamed:@"med-Rec.png"];
            break;
            
		case 3:
            cell.textLabel.text = @"About";
//             cell.imageView.image = [self imageWithImage:[UIImage imageNamed:@"logout-new.png"] scaledToSize:size];
          cell.imageView.image = [UIImage imageNamed:@"about.png"];
            break;
	}
	
	cell.backgroundColor = [UIColor dOPDThemeColor];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];

    
  // [self.tableVw reloadData];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    CGSize size = {22,22};
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
	switch (indexPath.row)
	{
		case 0:
             [Localytics tagEvent:@"SideBarMenuHomeClick"];
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"HomeVC"];
            
            cell.imageView.image = [UIImage imageNamed:@"homeOn.png"];
            [self slidePopout];
            if(LastindexClicked==0){
                [[SlideNavigationController sharedInstance]pushViewController:vc animated:NO];
            }
            LastindexClicked = indexPath.row;
            break;

			
		case 1:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"contentViewController"];
             [Localytics tagEvent:@"SideBarMenuHistoryClick"];
            cell.imageView.image = [UIImage imageNamed:@"history-hover.png"];
           [self slidePopout];
            if(LastindexClicked==1){
                [[SlideNavigationController sharedInstance]pushViewController:vc animated:NO];
            }
            LastindexClicked = indexPath.row;
            break;

        case 2:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MedicalRecord"];
            [Localytics tagEvent:@"SideBarMenuMedicalRecordClick"];
            cell.imageView.image = [UIImage imageNamed:@"med-Rec-hover.png"];
            [self slidePopout];
            if(LastindexClicked==2){
                [[SlideNavigationController sharedInstance]pushViewController:vc animated:NO];
            }
            LastindexClicked = indexPath.row;
            break;

        case 3:
            
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"aboutViewController"];
            [Localytics tagEvent:@"SideBarMenuAboutUSClick"];
            cell.imageView.image = [UIImage imageNamed:@"about-hover.png"];
            [self slidePopout];
            LastindexClicked = indexPath.row;
            break;
//            
//            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
//            [self.tableVw reloadData];
//            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"docOPD_Login"];
//            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
//                                                                     withSlideOutAnimation:self.slideOutAnimationEnabled
//                                                                             andCompletion:nil];
            
            
//            [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];
        //    break;
            
        default:
//            NSLog(@"No available View controller");
            break;
            
    }
//    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
//                                                              withSlideOutAnimation:self.slideOutAnimationEnabled
//                                                                      andCompletion:nil];
    
    
    cell.textLabel.textColor = [UIColor dOPDTFBorderColor];
    
    
    
    //cell.backgroundColor =[UIColor clearColor];
//    cell.textLabel.textColor = [UIColor dOPDThemeColor];
//    UIView *bgColorView = [[UIView alloc] init];
//    [bgColorView setBackgroundColor:[UIColor whiteColor]];
//    [cell setSelectedBackgroundView:bgColorView];
    
	
}

-(void)slidePopout{
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableVw reloadData];
}


- (IBAction)EditProfile:(id)sender {

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    [Localytics tagEvent:@"SideBarMenuMyAccountClick"];
    
   // UIViewController *vc ;
    MyFamilyAccountVC *pvc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MyFamilyAccountVC"];
   // ProfileDetailViewController *pvc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MyAccountVC"];
    [self.tableVw reloadData];
    //vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileDetViewController"];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:pvc
                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
    
    
}


#pragma mark - imageWithImage

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)imageupdateforSlider{
//    NSLog(@"img update for slider enter");
    ImgUser.image = [self getImage:@"MyProfileImage.png"];
}

- (UIImage*)getImage: (NSString*)filename {
    [Localytics tagEvent:@"SideBarMenuProfileImageClick"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    dataPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:@"Media"];
    NSString *getImagePath = [dataPath stringByAppendingPathComponent:filename];
//    NSLog(@"Get image path: %@",getImagePath);
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
