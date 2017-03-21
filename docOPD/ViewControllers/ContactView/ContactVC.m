//
//  ContactVC.m
//  docOPD
//
//  Created by Virinchi Software on 03/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "ContactVC.h"
#import "KTSContactsManager.h"


@interface ContactVC ()<KTSContactsManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) KTSContactsManager *contactsManager;

@end

@implementation ContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    userdef = userDefault;

    phoneNumber=@"";
    emailID=@"";
    // Do any additional setup after loading the view.
    self.contactsManager = [KTSContactsManager sharedManager];
    self.contactsManager.delegate = self;
    self.contactsManager.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES] ];
    [self loadData];
}

- (void)loadData
{
    [self.contactsManager importContacts:^(NSArray *contacts)
     {
         self.tableData = contacts;
         [self.tableView reloadData];
         NSLog(@"contacts: %@",contacts);
     }];
}

-(void)addressBookDidChange
{
    NSLog(@"Address Book Change");
    [self loadData];
}

-(BOOL)filterToContact:(NSDictionary *)contact
{
    return YES;
    return ![contact[@"company"] isEqualToString:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    NSDictionary *contact = [self.tableData objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    NSString *firstName = contact[@"firstName"];
    nameLabel.text = [firstName stringByAppendingString:[NSString stringWithFormat:@" %@", contact[@"lastName"]]];
    
    UILabel *phoneNo = (UILabel *)[cell viewWithTag:2];
    NSArray *phones = contact[@"phones"];
    
    if ([phones count] > 0) {
        NSDictionary *phoneItem = phones[0];
        phoneNo.text = phoneItem[@"value"];
    }
    
    UIImageView *cellIconView = (UIImageView *)[cell.contentView viewWithTag:888];
    UIImage *image = contact[@"image"];
    
    cellIconView.image = (image != nil) ? image : [UIImage imageNamed:@"user"];
    cellIconView.contentScaleFactor = UIViewContentModeScaleAspectFill;
    cellIconView.layer.cornerRadius = CGRectGetHeight(cellIconView.frame) / 2;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *iconView = (UIImageView *)[cell viewWithTag:111];
    iconView.image=[UIImage imageNamed:@"tick"];
    
    NSDictionary *contact = [self.tableData objectAtIndex:indexPath.row];
    NSArray *phones = contact[@"phones"];
    
    if ([phones count] > 0) {
        NSDictionary *phoneItem = phones[0];
        NSString* phone = phoneItem[@"value"];
        phoneNumber=[phoneNumber stringByAppendingString:[NSString stringWithFormat:@"%@,",phone]];

    }
    NSArray *emailArr = contact[@"emails"];
    
    if ([emailArr count] > 0) {
        NSDictionary *emailItem = emailArr[0];
        NSString* email = emailItem[@"value"];
        emailID=[emailID stringByAppendingString:[NSString stringWithFormat:@"%@,",email]];
    }
    else{
        emailID=[emailID stringByAppendingString:[NSString stringWithFormat:@"%@,",@"noemail"]];
    }
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *iconView = (UIImageView *)[cell viewWithTag:111];
    iconView.image=[UIImage imageNamed:@""];
    NSDictionary *contact = [self.tableData objectAtIndex:indexPath.row];
    NSArray *phones = contact[@"phones"];
    
    if ([phones count] > 0) {
        NSDictionary *phoneItem = phones[0];
        NSString* phone = phoneItem[@"value"];
         phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",phone]withString:@""];
    }
    NSArray *emailArr = contact[@"emails"];
    
    if ([emailArr count] > 0) {
        NSDictionary *emailItem = emailArr[0];
        NSString* email = emailItem[@"value"];
        emailID = [emailID stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",email]withString:@""];

    }
    else{
        emailID = [emailID stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",@"noemail"]withString:@""];

    }
    
}
- (IBAction)shareAction:(id)sender {
    if ([phoneNumber length]>1) {
        if ([self.controllerName isEqualToString:@"MedicalRecord"]) {
            NSLog(@"ph  %@    email   %@",phoneNumber,emailID);
            
            [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:[NSString stringWithFormat:@"Sharing your album"]] ;
            //SetAlbumSharingAPI
            [[docOPDNetworkEngine sharedInstance]SetAlbumSharingAPI:[userdef objectForKey:User_id]  AlbumId:self.id MobileNumber:phoneNumber EmailId:emailID withCallback:^(NSDictionary *responseData) {
                [[AppDelegate MyappDelegate] hideIndicator];
                [self.navigationController popViewControllerAnimated:YES];
            }];

        }
        else{
            [[AppDelegate MyappDelegate] showIndicatorWithTitle:@"Please Wait" Message:[NSString stringWithFormat:@"Sharing your image"]] ;
            [[docOPDNetworkEngine sharedInstance]SetMultipalImageSharingAPI:[userdef objectForKey:User_id] ImageId:self.id MobileNumber:phoneNumber EmailId:emailID withCallback:^(NSDictionary *responseData) {
                [[AppDelegate MyappDelegate] hideIndicator];
                [self.navigationController popViewControllerAnimated:YES];

            }];


        }
    }
    else{
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Alert" message:@"Please select atleast one contact" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
}

- (IBAction)gotoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
