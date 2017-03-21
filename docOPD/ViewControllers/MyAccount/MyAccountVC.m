//
//  MyAccountVC.m
//  docOPD
//
//  Created by Ashutosh Kumar on 8/1/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "MyAccountVC.h"

@interface MyAccountVC ()

@end

@implementation MyAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
}

#pragma mark - SlideNavigationController Methods -


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (IBAction)thanksAlert:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Thanks for visit docOPD"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Save",nil];

    [alert show];

}



@end
