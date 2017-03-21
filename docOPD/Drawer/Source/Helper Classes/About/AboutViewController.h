//
//  AboutViewController.h
//  docOPD
//
//  Created by Virinchi Software on 1/29/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController<SlideNavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *LblCopyRight;
@property (strong, nonatomic) IBOutlet UIButton *BtnContact;

@property (strong, nonatomic) IBOutlet UIButton *BtnTerms;
@end
