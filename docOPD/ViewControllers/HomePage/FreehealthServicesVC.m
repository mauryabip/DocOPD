//
//  FreehealthServicesVC.m
//  docOPD
//
//  Created by Virinchi Software on 23/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "FreehealthServicesVC.h"
#import "CCMPopupSegue.h"
#import "CCMBorderView.h"
#import "CCMPopupTransitioning.h"

@interface FreehealthServicesVC ()
@property (weak) UIViewController *popupController;

@end

@implementation FreehealthServicesVC

- (void)viewDidLoad {
    [super viewDidLoad];
     dataArr = [[NSArray alloc]init];
    userDef=userDefault;
    
    self.referTextLbl.text=@"\"Unlock free essential health service by inviting members\"";
    if ([self.viewController isEqualToString:@"homehealth"]) {
        screenName=@"HomeHealth";
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HomeHealthTitle"];
        dataArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        self.titleLbl.text=@"Home Health";
        self.camprequestBtn.hidden=YES;
        self.tableHT.constant=self.tableHT.constant+45;
        [self.view layoutIfNeeded];
    }
    else if ([self.viewController isEqualToString:@"emergency"]){
        screenName=@"Emergemcy";
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"EmergencyTitle"];
        dataArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        self.titleLbl.text=@"Emergency";
        self.camprequestBtn.hidden=YES;
        self.tableHT.constant=self.tableHT.constant+45;
        [self.view layoutIfNeeded];
    }
    else{
        screenName=@"FreeHealth";
//        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"FreeHealthTitle"];
//        dataArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        self.titleLbl.text=@"Free Health Service";
        [self performSelector:@selector(getdata) withObject:nil afterDelay:0.0];
    }
    
    self.referralCodeTXT.text=[userDef objectForKey:ReferenceCode];
    
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)getdata{
    [[docOPDNetworkEngine sharedInstance]FreeHealthTitleWithFreeStatusAPI:[userDef valueForKey:User_id] withCallback:^(NSDictionary *responseData) {
        dataArr=[responseData objectForKey:@"FreeHealthTitle"];
        for (int i=0; i<[dataArr count]; i++) {
            NSString *totalCount=[[dataArr valueForKey:@"CountToBeFree"]objectAtIndex:count];
            if ([totalCount isKindOfClass:[NSNull class]]) {
               
                count++;
                 NSLog(@"%lu  %ld",(unsigned long)[dataArr count],(long)count);
                if (count==[dataArr count]) {
                    self.referTextLbl.text=@"\"Unlock free essential health service by inviting members\"";
                }
                else{
                    
                    NSString *nameLbl=[[dataArr valueForKey:@"TitleName"]objectAtIndex:count];
                    self.referTextLbl.text=[NSString stringWithFormat:@"\"Unlock free essential health service '%@' by inviting %@ members\"",nameLbl,totalCount];

                }
            }
            else{
                NSLog(@"%@",totalCount);
                NSString *nameLbl=[[dataArr valueForKey:@"TitleName"]objectAtIndex:count];
                self.referTextLbl.text=[NSString stringWithFormat:@"\"Unlock free essential health service '%@' by inviting %@ members\"",nameLbl,totalCount];
                break;
            }
            
        }
        //CountToBeFree
        
        [self.tableView reloadData];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@Screen",screenName]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
     [Localytics tagEvent:[NSString stringWithFormat:@"%@Screen",screenName]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [dataArr count];
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    // NSLog(@"willDisplayCell - %ld",(long)indexPath.section);
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:247.0/255.0 blue:248.0/255.0 alpha:1.0];
    
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:111];
    UILabel *heading = (UILabel *)[cell viewWithTag:100];
    UILabel *desc = (UILabel *)[cell viewWithTag:101];
    if ([self.viewController isEqualToString:@"homehealth"]) {
        imgView.image=[UIImage imageNamed:@"homehealthLeft"];
       // NSLog(@"%@",dataArr);//TitleDescription   TitleName
        heading.text=[[dataArr valueForKey:@"TitleName"]objectAtIndex:indexPath.row];
        desc.text=[[dataArr valueForKey:@"TitleDescription"]objectAtIndex:indexPath.row];
    }
    else if ([self.viewController isEqualToString:@"emergency"]){
        imgView.image=[UIImage imageNamed:@"homehealthLeft"];
        heading.text=[[dataArr valueForKey:@"TitleName"]objectAtIndex:indexPath.row];
        desc.text=[[dataArr valueForKey:@"TitleDescription"]objectAtIndex:indexPath.row];;
        
    }
    else{
        BOOL IsFree=[[[dataArr valueForKey:@"IsFree"]objectAtIndex:indexPath.row] boolValue];
        if (IsFree) {
            imgView.image=[UIImage imageNamed:@"homehealthLeft"];
        }
        else
            imgView.image=[UIImage imageNamed:@"padlock"];
        heading.text=[[dataArr valueForKey:@"TitleName"]objectAtIndex:indexPath.row];
        desc.text=[[dataArr valueForKey:@"TitleDescription"]objectAtIndex:indexPath.row];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.viewController isEqualToString:@"homehealth"]) {
        [Localytics tagEvent:@"HomeHealthBookAppointmentClick"];
       
        GeneralDocBookingVC *DocBook = [self.storyboard instantiateViewControllerWithIdentifier:@"GeneralDocBookingVC"];
        DocBook.controllerName=@"health";
         DocBook.titleName=[[dataArr valueForKey:@"TitleName"]objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:DocBook animated:YES];
    }
    else if ([self.viewController isEqualToString:@"emergency"]) {
        [Localytics tagEvent:@"EmergencyBookAppointmentClick"];
        EmergencyListVC *EmergencyListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmergencyListVC"];
        EmergencyListVC.Data=[[dataArr objectAtIndex:indexPath.row]objectForKey:@"Data"];
        EmergencyListVC.name=[[dataArr valueForKey:@"TitleName"]objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:EmergencyListVC animated:YES];
        
    }
    else{
        BOOL IsFree=[[[dataArr valueForKey:@"IsFree"]objectAtIndex:indexPath.row] boolValue];
        if (IsFree){
            [Localytics tagEvent:@"FreeHealthBookAppointmentClick"];
            GeneralDocBookingVC *DocBook = [self.storyboard instantiateViewControllerWithIdentifier:@"GeneralDocBookingVC"];
            DocBook.controllerName=@"health";
            DocBook.titleName=[[dataArr valueForKey:@"TitleName"]objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:DocBook animated:YES];
        }
        else{
            [Localytics tagEvent:@"FreeHealthFreePaidPopUpClick"];
            [docOPDNetworkEngine sharedInstance].titleName=[[dataArr valueForKey:@"TitleName"]objectAtIndex:indexPath.row];
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Refer and save money"
                                          message:self.referTextLbl.text
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"Share"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self performSelector:@selector(shareAction:) withObject:nil afterDelay:0.00];
                                     //[alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleDestructive
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            
            [alert addAction:cancel];
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
//            UIViewController *presentingController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"popupController"];
//            
//            CCMPopupTransitioning *popup = [CCMPopupTransitioning sharedInstance];
//            if (self.view.bounds.size.height < 420) {
//                popup.destinationBounds = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.height-20) * .75, [UIScreen mainScreen].bounds.size.height-20);
//            } else {
//                popup.destinationBounds = CGRectMake(0, 0, 300, 250);
//            }
//            popup.titleName=[[dataArr valueForKey:@"TitleName"]objectAtIndex:indexPath.row];
//            popup.presentedController = presentingController;
//            popup.presentingController = self;
//            self.popupController = presentingController;
//            
//            
//            [self presentViewController:presentingController animated:YES completion:nil];

        }
    }


}

- (IBAction)backAction:(id)sender {
    if ([self.viewController isEqualToString:@"homehealth"]) {
        [Localytics tagEvent:@"HomehealthHomeClick"];
    }
    else if ([self.viewController isEqualToString:@"emergency"]){
        [Localytics tagEvent:@"EmergencyHomeClick"];
    }
    else{
        [Localytics tagEvent:@"FreeHealthHomeClick"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)didDismissSegue:(UIStoryboardSegue *)segue {
    
}
- (IBAction)shareAction:(id)sender {
    
     [Localytics tagEvent:@"FreeHealthShareClick"];
   // [self dismissViewControllerAnimated:YES completion:nil];
  /*  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width/2-25.0, self.view.frame.size.height/2-25.0, 50.0, 50.0);
    
    if(shareBubbles) {
        shareBubbles = nil;
    }
    shareBubbles = [[AAShareBubbles alloc] initWithPoint:button.center radius:95 inView:self.view];
    shareBubbles.delegate = self;
    shareBubbles.bubbleRadius = 25;
    shareBubbles.showFacebookBubble = YES;
    shareBubbles.showTwitterBubble = YES;
    shareBubbles.showGooglePlusBubble = YES;
    shareBubbles.showTumblrBubble = YES;
    shareBubbles.showVkBubble = YES;
    shareBubbles.showLinkedInBubble = YES;
    shareBubbles.showYoutubeBubble = YES;
    shareBubbles.showVimeoBubble = YES;
    shareBubbles.showRedditBubble = YES;
    shareBubbles.showPinterestBubble = YES;
    shareBubbles.showInstagramBubble = YES;
    shareBubbles.showWhatsappBubble = YES;
    
    [shareBubbles show];
    
    */
    NSString *textToShare = [NSString stringWithFormat:@"Checkout this amazing offer I found on docOPD portraying the best from his store.Enjoy! \n Use referral code '%@'",self.referralCodeTXT.text];
    NSURL *myWebsite = [NSURL URLWithString:@"http://www.docopd.com/"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage, UIActivityTypeMail,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    [self presentViewController:controller animated:YES completion:nil];


}
- (void)whatsappShareAction {
    //NSString *textToShare = [dic1 valueForKey:@"DealTitle"];
    NSString *textToShare = @"Checkout this amazing offer I found on docOPD portraying the best from his store.Enjoy!";
//    NSString *dealURL=[dic1 valueForKey:@"DealPublicURL"];
//    NSString *webURL=[NSString stringWithFormat:@"Checkout more on: http://www.dealgali.com/%@",dealURL];
//    
//    NSString * urlWhatsURL = [NSString stringWithFormat:@"whatsapp://send?text=%@ %@",textToShare,webURL];
    
    
    NSURL * whatsappURL = [NSURL URLWithString:[textToShare stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    } else {
        // Cannot open whatsapp  photos (UTI: public.image)  web URLs (UTI: public.url)
    }
}
-(void)targetedShare:(NSString *)serviceType {
    //NSString *textToShare = [dic1 valueForKey:@"DealTitle"];
    NSString *textToShare = @"Checkout this amazing offer I found on docOPD portraying the best from his store.Enjoy!";
//    NSString *dealURL=[dic1 valueForKey:@"DealPublicURL"];
//    NSString *webURL=[NSString stringWithFormat:@"Checkout more on: http://www.dealgali.com/%@",dealURL];
    if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        [mySLComposerSheet setInitialText:textToShare];
        
        //[mySLComposerSheet addImage:self.companyLogoImgView.image];
        
       // [mySLComposerSheet addURL:[NSURL URLWithString:webURL]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    
    else {
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"You do not have this service"
                 message:nil
                 delegate:self
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
        
        [alert show];
    }
    
}
#pragma mark AAShareBubbles

-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType
{
    switch (bubbleType) {
        case AAShareBubbleTypeFacebook:
            [self targetedShare:SLServiceTypeFacebook];
            break;
        case AAShareBubbleTypeTwitter:
            [self targetedShare:SLServiceTypeTwitter];
            break;
        case AAShareBubbleTypeWhatsApp:
            [self whatsappShareAction];
            break;
        default:
            break;
    }
}

-(void)aaShareBubblesDidHide:(AAShareBubbles*)bubbles {
    NSLog(@"All Bubbles hidden");
}

- (void)viewDidUnload {
    [self setShareBtn:nil];
    [super viewDidUnload];
}

- (IBAction)bookAction:(id)sender {
   
     [Localytics tagEvent:@"FreeHealthPaidClick"];
    GeneralDocBookingVC *DocBook = [self.storyboard instantiateViewControllerWithIdentifier:@"GeneralDocBookingVC"];
    UINavigationController *navPresent = [[UINavigationController alloc] initWithRootViewController:DocBook];
    DocBook.controllerName=@"health";
    DocBook.popupSelection=@"popupSelection";
    DocBook.titleName=[[docOPDNetworkEngine sharedInstance].titleName stringByReplacingOccurrencesOfString:@"Free" withString:@"Paid"];
    NSLog(@"%@",[docOPDNetworkEngine sharedInstance].titleName);
    [self presentViewController:navPresent animated:YES completion:nil];

  // [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (IBAction)capmRequestAction:(id)sender {
    [Localytics tagEvent:@"FreeHealthFreeCampRequestClick"];
    EmergencyBookVC* EmergencyBookVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmergencyBookVC"];
    EmergencyBookVC.titleName=@"Free Camp Request";
    [self.navigationController pushViewController:EmergencyBookVC animated:YES];

}
- (IBAction)referAndSaveBtnAction:(id)sender {
    [Localytics tagEvent:@"FreeHealthShareClick"];
  /*  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width/2-25.0, self.view.frame.size.height/2-25.0, 50.0, 50.0);
    
    if(shareBubbles) {
        shareBubbles = nil;
    }
    shareBubbles = [[AAShareBubbles alloc] initWithPoint:button.center radius:95 inView:self.view];
    shareBubbles.delegate = self;
    shareBubbles.bubbleRadius = 25;
    shareBubbles.showFacebookBubble = YES;
    shareBubbles.showTwitterBubble = YES;
    shareBubbles.showGooglePlusBubble = YES;
    shareBubbles.showTumblrBubble = YES;
    shareBubbles.showVkBubble = YES;
    shareBubbles.showLinkedInBubble = YES;
    shareBubbles.showYoutubeBubble = YES;
    shareBubbles.showVimeoBubble = YES;
    shareBubbles.showRedditBubble = YES;
    shareBubbles.showPinterestBubble = YES;
    shareBubbles.showInstagramBubble = YES;
    shareBubbles.showWhatsappBubble = YES;
    
    [shareBubbles show];
   */
    NSString *textToShare = [NSString stringWithFormat:@"Checkout this amazing offer I found on docOPD portraying the best from his store.Enjoy! \n Use referral code '%@'",self.referralCodeTXT.text];
    NSURL *myWebsite = [NSURL URLWithString:@"http://www.docopd.com/"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage, UIActivityTypeMail,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    [self presentViewController:controller animated:YES completion:nil];
}
@end
