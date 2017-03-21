//
//  ContactVC.h
//  docOPD
//
//  Created by Virinchi Software on 03/10/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "docOPDNetworkEngine.h"

@interface ContactVC : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSString* phoneNumber;
    NSString* emailID;
    NSUserDefaults *userdef;

}


@property (strong, nonatomic)  NSString *controllerName;
@property (strong, nonatomic)  NSString *id;

- (IBAction)shareAction:(id)sender;
- (IBAction)gotoBack:(id)sender;
@end
