//
//  photoViwerViewController.h
//  docOPD
//
//  Created by Virinchi Software on 2/6/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
@interface photoViwerViewController : UIViewController<UITextViewDelegate>{
    NSUserDefaults *userdef;
    BOOL keyboardHasAppeard;
    UIImage *PickedImage;
    UILabel *placeholderLabel;
    float _previousContentHeight;
    UIView *inputAccessoryView;
    UIButton *Done;
     UITextField *activeField;
    NSString *oldCaption;
}
@property (strong, nonatomic) IBOutlet UIView *ViewTextviewholder;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (nonatomic) BOOL textViewEmpty;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic)NSString *getImagePath;
@property(nonatomic)NSString *imageid;
@property (strong, nonatomic) IBOutlet UIView *viewMain;
@property (nonatomic, strong) DBManager *dbManager;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITextView *captionTXT;
@property (nonatomic, strong) NSArray *FetchedData;
- (IBAction)updateCaptionAction:(id)sender;
@end
