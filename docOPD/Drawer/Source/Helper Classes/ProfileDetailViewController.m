//
//  ProfileDetailViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/25/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "ProfileDetailViewController.h"

typedef enum{
    kTAG_topbar=110,
    kTAG_Cell,
    kTAG_EditNameButton,
    kTAG_EditEmailButton,
    kTAG_EditAddressButton,
    kTAG_Scroller,
    kTAG_ContentView,
    kTAG_Section1Row0,
    kTAG_Section1Row1,
    kTAG_Section1Row2,
    
}ALLTAGS;

@interface ProfileDetailViewController ()

@end


@implementation ProfileDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    astrics = @"\u2217 \u2217 \u2217 \u2217 \u2217";
  //  [self ApiCalling];
    self.view.backgroundColor = [UIColor whiteColor];
    [self MainUI];
    
    
    FullNameTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, [UIScreen mainScreen].bounds.size.width -70, 20)];
    FullNameTF.adjustsFontSizeToFitWidth = YES;
    FullNameTF.textColor = [UIColor blackColor];
    [FullNameTF setReturnKeyType:UIReturnKeyGo];
    FullNameTF.delegate = self;

    EmailTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, [UIScreen mainScreen].bounds.size.width -70, 20)];
    EmailTF.adjustsFontSizeToFitWidth = YES;
    EmailTF.textColor = [UIColor blackColor];
    [EmailTF setReturnKeyType:UIReturnKeyGo];
    EmailTF.delegate = self;

    addressTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, [UIScreen mainScreen].bounds.size.width -70, 20)];
    addressTF.adjustsFontSizeToFitWidth = YES;
    addressTF.textColor = [UIColor blackColor];
    [addressTF setReturnKeyType:UIReturnKeyGo];
    addressTF.delegate = self;


    UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(FullNameTF.frame.origin.x, FullNameTF.frame.size.height + FullNameTF.frame.origin.y, 200, 20)];
    detail.adjustsFontSizeToFitWidth = YES;
    detail.textColor = [UIColor grayColor];
    
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Profile Details"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}



-(void)MainUI{
    UIView *topbar = [[UIView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 45.0)];
    topbar.tag = kTAG_topbar;
//    NSLog(@"topbar height in function %f", topbar.frame.size.height);
    [self.view addSubview:topbar];
    
    UIButton *menuBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(8, 11, 30, 22);
    [menuBtn setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(BounceMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topbar addSubview:menuBtn];
    
    
    UILabel *Title = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-60, 5, 120, 34)];
    Title.text = @"Profile";
    Title.textAlignment = NSTextAlignmentCenter;
    [topbar addSubview:Title];
    UILabel *sep = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 1)];
    sep.backgroundColor = [UIColor clearColor];
    [topbar addSubview:sep];
    
    UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topbar.frame.size.height + topbar.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - topbar.frame.size.height - topbar.frame.origin.y)];
    scroller.tag = kTAG_Scroller;
    [self.view addSubview:scroller];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scroller.frame.size.width, scroller.frame.size.height)];
    contentView.tag = kTAG_ContentView;
    [scroller addSubview:contentView];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    [scroller addGestureRecognizer:tapScroll];
    
    
   // tbleview = [[UITableView alloc]initWithFrame:CGRectMake(0, topbar.frame.size.height + topbar.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - topbar.frame.size.height - topbar.frame.origin.y)];
    tbleview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    tbleview.delegate = self;
    tbleview.dataSource = self;
    tbleview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [contentView addSubview:tbleview];
    
    
    EditNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [EditNameButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    [EditNameButton setFrame:CGRectMake(0, 0,20, 20)];
    EditNameButton.tag = kTAG_EditNameButton;
    [EditNameButton addTarget:self action:@selector(editName:) forControlEvents:UIControlEventTouchUpInside];
    
    EditEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [EditEmailButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    [EditEmailButton setFrame:CGRectMake(0, 0,20, 20)];
    EditEmailButton.tag = kTAG_EditEmailButton;
    [EditEmailButton addTarget:self action:@selector(editEmail:) forControlEvents:UIControlEventTouchUpInside];
    
    EditAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [EditAddressButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    [EditAddressButton setFrame:CGRectMake(0, 0,20, 20)];
    EditAddressButton.tag = kTAG_EditAddressButton;
    [EditAddressButton addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *Logout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    Logout.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height -60, [UIScreen mainScreen].bounds.size.width - 20, 40);
    [Logout setTitle:@"LOGOUT" forState:UIControlStateNormal];
    [Logout setTitleColor:[UIColor dOPDThemeColor] forState:UIControlStateNormal];
    Logout.layer.borderWidth = 1.0f;
    Logout.layer.cornerRadius = 7.0f;
    Logout.layer.borderColor = [UIColor dOPDThemeColor].CGColor;
    [Logout addTarget:self action:@selector(signout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Logout];
}

-(void)HideTextFieldBorder: (UITextField*)textField{
    textField.borderStyle = UITextBorderStyleNone;
}

-(void)ShowTextFieldBorder: (UITextField*)textField{
   // textField.borderStyle = UITextBorderStyleLine;
    textField.layer.borderWidth=1.0;
    textField.layer.cornerRadius = 5.0;
    textField.layer.borderColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0].CGColor;
}



#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

- (IBAction)BounceMenu:(id)sender {
//    static Menu menu = MenuLeft;
//    menu = MenuLeft;
//    [[SlideNavigationController sharedInstance] toggleMenu:menu withCompletion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - API CALLING

//-(void)ApiCalling{
//    [[AppDelegate MyappDelegate] showIndicator];
//    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kMyProfile], keyRequestType,nil];
//    
//    userDef= [NSUserDefaults standardUserDefaults];
//    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userDef valueForKey:userId],userId,nil];
//    
//    server *obj = [[server alloc] init];
//    currentRequestType = kMyProfile;
//    obj.delegate = self;
//    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    NSLog(@"serviceCalling");
//    
//    
//}
#pragma mark - Logout From System
-(void)signout: (UIButton*)sender{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *vc ;
    
//    UIWindow *mainWindow = [AppDelegate MyappDelegate].window;
//    UINavigationController *navigationObject = [[UINavigationController alloc] initWithRootViewController:view];
//    [mainWindow setRootViewController:navigationObject];
//    [navigationObject setNavigationBarHidden:YES];
//
   
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"HK_Home"];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                     andCompletion:nil];

//    NSString *strAppBundleId = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:strAppBundleId];

    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    
//    [self resetDefaults];
      
    
    
    
//    [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES]    ;
    
 // [navigationObject.navigationController popViewControllerAnimated:true];
  //  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}


#pragma mark - WebService Calls Response

- (void) requestFinished:(NSDictionary * )responseData
{
    
    [self performSelector:@selector(result:) withObject:responseData afterDelay:.000];
    
    
//    NSLog(@"LoginViewController requestFinished");
}

#pragma mark - result methods for login service

- (void) result:(NSDictionary *)response

{
//    NSLog(@"response :%@",response);
    [[AppDelegate MyappDelegate] hideIndicator];
    resposeCode=[response objectForKey:@"posts"];
    NSString *message=[resposeCode objectForKey:@"msg"];
  //  NSInteger usrid = [[resposeCode objectForKey:@"UserId"]integerValue];
   if (!saveData) {
    NSString *address=[resposeCode objectForKey:@"Address"];
    NSString *Email=[resposeCode objectForKey:@"Email"];
    NSString *mobile=[resposeCode objectForKey:@"Mobile"];
    NSString *Name=[resposeCode objectForKey:@"Name"];
    NSString *pass =[resposeCode objectForKey:@"Password"];
//    NSString *uid =[resposeCode objectForKey:@"UserId"];//UserId
//       [userDef setValue:Name forKey:FullName];
//       [userDef setValue:mobile forKey:Mobile];
//       [userDef setValue:uid forKey:userId];
       [userDef synchronize];
    array1 = [[NSMutableArray alloc]initWithObjects:mobile,pass,nil];
    array2 = [[NSMutableArray alloc]initWithObjects:Name,Email,address,nil];
   }
    status=[[resposeCode objectForKey:@"status"] integerValue];
    
    if (status == 0)
    {
        if (saveData) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Save Profile Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            saveData = false;

        }
        else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Profile Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    else if(status ==1){
       if (saveData) {
//        NSLog(@"Profile Update status1 message = %@",message);
        //[tbleview reloadData];
//        [userDef setValue:FullNameTF.text forKey:FullName];
//        [userDef setValue:EmailTF.text forKey:emailId];
//        [userDef setValue:addressTF.text forKey:Address];
        
           [userDef synchronize];
        saveData = false;
       }
        else{
//            NSLog(@"Profile Update status1 message = %@",message);
            [tbleview reloadData];
        }
    }
    
}

- (void) requestError
{
    NSLog(@"Profile Detail ViewController error");
    [[AppDelegate MyappDelegate] hideIndicator];
}

#pragma mark - TableView Delegates


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
    {
        return array1.count;
    }
    else{
        return [array2 count];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 33.0;

}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.font = [UIFont boldSystemFontOfSize:12.0f];
 //   header.textLabel.textColor = [UIColor HKDrawerTextColor];
}




- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"SIGN IN DETAILS";
    else
        return @"MY DETAILS";
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section==0) {

        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = [array1 objectAtIndex:indexPath.row];
                cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
                cell.detailTextLabel.text = @"MOBILE";
                cell.detailTextLabel.textColor = [UIColor grayColor];
               // CGSize size = {11,19};
//                 CGSize size = {20,20};
//                cell.imageView.image = [self imageWithImage:[UIImage imageNamed:@"cellphone91.png"] scaledToSize:size];
//                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
               cell.imageView.image = [UIImage imageNamed:@"mob.png"];
                break;
                
            case 1:
                cell.textLabel.text =astrics;
                cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
                cell.detailTextLabel.text = @"PASSWORD";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.textColor = [UIColor grayColor];
//                CGSize size1 = {14,20};
//                cell.imageView.image = [self imageWithImage:[UIImage imageNamed:@"password.png"] scaledToSize:size1];
//               cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            cell.imageView.image = [UIImage imageNamed:@"pass.png"];
                break;
        }
        
    }
    else if (indexPath.section==1) {
        
//        FullNameTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 185, 20)];
//        FullNameTF.adjustsFontSizeToFitWidth = YES;
//        FullNameTF.textColor = [UIColor blackColor];
//        FullNameTF.delegate = self;
//       
//        EmailTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 185, 20)];
//        EmailTF.adjustsFontSizeToFitWidth = YES;
//        EmailTF.textColor = [UIColor blackColor];
//        EmailTF.delegate = self;
//        
        UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(FullNameTF.frame.origin.x, FullNameTF.frame.size.height + FullNameTF.frame.origin.y, 200, 20)];
        detail.adjustsFontSizeToFitWidth = YES;
        detail.textColor = [UIColor grayColor];
        
//        [cell.contentView addSubview:FullNameTF];
//        cell.textLabel.text =[array2 objectAtIndex:indexPath.row];
//        cell.tag = kTAG_Cell;
//        FullNameTF.tag = indexPath.row;
//        FullNameTF.text = [array2 objectAtIndex:indexPath.row];
//        FullNameTF.textColor = [UIColor blackColor];
//        NSLog(@"Cell full name %@",FullNameTF.text);
        
        
        
        switch (indexPath.row)
        {
            case 0:
                
                [cell.contentView addSubview:FullNameTF];
                [cell.contentView addSubview:detail];
                FullNameTF.enabled = NO;
                FullNameTF.text = [array2 objectAtIndex:indexPath.row];
                FullNameTF.font = [UIFont systemFontOfSize:14.0f];
                detail.text = @"NAME";
//                CGSize size = {19,18};
//                cell.imageView.image = [self imageWithImage:[UIImage imageNamed:@"profile.png"] scaledToSize:size];
//                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                cell.imageView.image = [UIImage imageNamed:@"user.png"];
                cell.accessoryView = EditNameButton;
               detail.font = [UIFont systemFontOfSize:13.0f];
                cell.tag = kTAG_Section1Row0;
                break;
                
                
            case 1:
                [cell.contentView addSubview:EmailTF];
                if ([array2 objectAtIndex:indexPath.row] == nil || [[array2 objectAtIndex:indexPath.row] isEqualToString:@""]) {
                    EmailTF.text = @"NA";
                }else{
                    EmailTF.text =[array2 objectAtIndex:indexPath.row];
                }
                
                [cell.contentView addSubview:detail];
                EmailTF.enabled = NO;
                
                EmailTF.font = [UIFont systemFontOfSize:14.0f];
                detail.text = @"EMAIL";
                detail.font = [UIFont systemFontOfSize:13.0f];
                detail.textColor = [UIColor grayColor];
//                CGSize size1 = {20,13};
//                cell.imageView.image = [self imageWithImage:[UIImage imageNamed:@"mailid.png"] scaledToSize:size1];
//                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                cell.imageView.image = [UIImage imageNamed:@"mail.png"];
                cell.accessoryView = EditEmailButton;
                cell.tag = kTAG_Section1Row1;
                break;
                
            case 2:
                
                [cell.contentView addSubview:addressTF];
                [cell.contentView addSubview:detail];
                addressTF.enabled = NO;
                addressTF.text = [array2 objectAtIndex:indexPath.row];
                addressTF.font = [UIFont systemFontOfSize:14.0f];
                detail.text = @"Address";
//                CGSize size2 = {19,18};
//                cell.imageView.image = [self imageWithImage:[UIImage imageNamed:@"location.png"] scaledToSize:size2];
//                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                cell.imageView.image = [UIImage imageNamed:@"location.png"];
                cell.accessoryView = EditAddressButton;
                detail.font = [UIFont systemFontOfSize:13.0f];
                cell.tag = kTAG_Section1Row2;
                break;
                
                
                default:
                break;
        }
        
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

     if (indexPath.section==0)
     {
         return  44.0f;
     }
     else{
         return 50.0f;
     }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0)
    {
        if (indexPath.row==1)
        {
//            ChangePasswordVC *changePass = [[ChangePasswordVC alloc]init];
//            changePass.userID =[[resposeCode objectForKey:@"UserId"]integerValue];
////           [self.navigationController pushViewController:changePass animated:YES];
//            [[SlideNavigationController sharedInstance]pushViewController:changePass animated:YES];
        }
    }
    
    else if (indexPath.section==1) {
        switch (indexPath.row)
        {
            case 0:
                [self editName:EditNameButton];
                break;
                
            case 1:
                [self editEmail:EditEmailButton];
                break;
                
            case 2:
                [self editAddress:EditAddressButton];
                break;
        }
//        UITableViewCell *Cell = (UITableViewCell*)[tableView viewWithTag:kTAG_Cell];
//        UITextField *textF= (UITextField *)[Cell viewWithTag:indexPath.row];
//        [textF becomeFirstResponder];
        

    }
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


#pragma mark - Edit User Details

-(void)editName: (UIButton*)sender{
    if (!isEditClicked) {
        //[self Edit:sender];
        isKBOpen = YES;
        isEditClicked = true;
        FullNameTF.enabled = true;
        [FullNameTF becomeFirstResponder];
        FullNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        UITableViewCell *cell = (UITableViewCell*)[tbleview viewWithTag:kTAG_Section1Row0];
        cell.accessoryView.hidden = true;
        
        
    }
//    else if (isKBOpen && (sender.tag != lastclicked.tag)){
//        [self KBOpenSaveData:sender];
//        FullNameTF.enabled = true;
//        [FullNameTF becomeFirstResponder];
//    }
//    
//    else {
//    [self Save:sender];
//    FullNameTF.enabled = false;
//    [FullNameTF resignFirstResponder];
//    }
    lastclicked = sender;
    lastCellTapped = kTAG_Section1Row0;
    activeTF = FullNameTF;
}


-(void)editEmail: (UIButton*)sender{
    if (!isEditClicked) {
       // [self Edit:sender];
        isKBOpen = YES;
        isEditClicked = true;
        EmailTF.enabled = true;
        [EmailTF becomeFirstResponder];
        EmailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        UITableViewCell *cell = (UITableViewCell*)[tbleview viewWithTag:kTAG_Section1Row1];
        cell.accessoryView.hidden = true;
//    }else if (isKBOpen && (sender.tag != lastclicked.tag)){
//        [self KBOpenSaveData:sender];
//        EmailTF.enabled = true;
//        [EmailTF becomeFirstResponder];
//    }
//    else {
//        [self Save:sender];
//        EmailTF.enabled = false;
//        [EmailTF resignFirstResponder];
    }
    lastclicked = sender;
    lastCellTapped = kTAG_Section1Row1;
    activeTF = EmailTF;
   
}


-(void)editAddress: (UIButton*)sender{
    if (!isEditClicked) {
        //[self Edit:sender];
        addressTF.enabled = true;
        [addressTF becomeFirstResponder];
        isKBOpen = YES;
        isEditClicked = true;
        addressTF.enabled = true;
        [addressTF becomeFirstResponder];
        addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        UITableViewCell *cell = (UITableViewCell*)[tbleview viewWithTag:kTAG_Section1Row2];
        cell.accessoryView.hidden = true;
        
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height <= 568)
        {
            UIScrollView *scrv = (UIScrollView *)[self.view viewWithTag:kTAG_Scroller];
            // UIView *contentView = (UIView *)[scrv viewWithTag:kTAG_ContentView];
            [scrv setContentOffset:CGPointMake(0, 100) animated:YES];
        }
//    }else if (isKBOpen && (sender.tag != lastclicked.tag)){
//       [self KBOpenSaveData:sender];
//        addressTF.enabled = true;
//        [addressTF becomeFirstResponder];
//    }
//    else {
//        [self Save:sender];
//        addressTF.enabled = false;
//        [addressTF resignFirstResponder];
//        UIScrollView *scrv = (UIScrollView *)[self.view viewWithTag:kTAG_Scroller];
//        //        UIView *contentView = (UIView *)[scrv viewWithTag:kTAG_ContentView];
//        [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    lastclicked = sender;
    lastCellTapped = kTAG_Section1Row2;
    activeTF = addressTF;
}


//-(void)Edit: (UIButton*)sender {
//    isEditClicked = true;
//    isKBOpen = true;
//   // [sender setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
//    if (!lastclicked.tag == sender.tag) {
//        [lastclicked setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
//    }
//    
//}
//
//#pragma mark - Save
//
//-(void)Save: (UIButton*) sender{
//    [sender setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
//    isEditClicked = false;
//   // [self profileUpdate];
//    [self performSelector:@selector(profileUpdate) withObject:nil afterDelay:.000];
//}
//
//#pragma mark - Keyboard open
//-(void)KBOpenSaveData: (UIButton*)sender{
//    [self performSelector:@selector(profileUpdate) withObject:nil afterDelay:.000];
//    [lastclicked setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
//    [sender setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
//    
//}
#pragma mark TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    isEditClicked = false;
    isKBOpen = false;
    lastclicked.hidden=false;
     [lastclicked setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
 //   [self performSelector:@selector(profileUpdate) withObject:nil afterDelay:.000];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height <= 568 && lastCellTapped == kTAG_Section1Row2)
    {
        UIScrollView *scrv = (UIScrollView *)[self.view viewWithTag:kTAG_Scroller];
        // UIView *contentView = (UIView *)[scrv viewWithTag:kTAG_ContentView];
        [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
    }

    
    
    return YES;
}

#pragma mark - Profile Update
//-(void)profileUpdate{
//    [[AppDelegate MyappDelegate] showIndicator];
//    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kMyProfileUpdate], keyRequestType,nil];
//    
//    userDef= [NSUserDefaults standardUserDefaults];
//    NSDictionary *dataDic =[NSDictionary dictionaryWithObjectsAndKeys:[userDef valueForKey:userId],userId,FullNameTF.text,FullName,EmailTF.text,emailId,addressTF.text,Address,nil];
//     [userDef setValue:FullNameTF.text forKey:FullName];
//    server *obj = [[server alloc] init];
//    currentRequestType = kMyProfileUpdate;
//    obj.delegate = self;
//    [obj sendRequestToServer:aDic withDataDic:dataDic];
//    saveData= true;
//    NSLog(@"serviceCalling");
//}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];// this will do the trick
//    UIScrollView *scrv = (UIScrollView *)[self.view viewWithTag:kTAG_Scroller];
//    [scrv endEditing:YES];
//    [tbleview endEditing:YES];
//}

- (void) tapped
{
    if (isKBOpen) {
        [self.view endEditing:YES];
        UITableViewCell *cell = (UITableViewCell*)[tbleview viewWithTag:lastCellTapped];
        cell.accessoryView.hidden = false;
        isEditClicked = false;
        isKBOpen = false;
        activeTF.enabled = false;
    }
   
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
