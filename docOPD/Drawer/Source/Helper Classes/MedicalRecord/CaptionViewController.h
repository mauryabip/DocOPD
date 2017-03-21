//
//  CaptionViewController.h
//  docOPD
//
//  Created by Virinchi Software on 2/4/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"
#import "DBManager.h"

@interface CaptionViewController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RNGridMenuDelegate>
{
    NSMutableArray *ArrImage;
    NSString *base64EncodedString;
    NSString *imageName;
    NSUserDefaults *userdef;
    BOOL keyboardHasAppeard;
    UIImage *PickedImage;
    UILabel *placeholderLabel;
    UITextView * CaptiontextView;
    float _previousContentHeight;
}
@property (nonatomic, strong) DBManager *dbManager;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;

@property (nonatomic)NSString *parentFolder;
@property (nonatomic)NSString *grandParent;
@property (strong, nonatomic) IBOutlet UIImageView *ImgView;
- (IBAction)didPressSaveBtn:(id)sender;
- (IBAction)didPressCancelBtn:(id)sender;
//@property (strong, nonatomic) IBOutlet UITextView *TVCaption;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (nonatomic) BOOL textViewEmpty;
@property (strong, nonatomic) IBOutlet UIView *ViewTextviewholder;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (assign)id delegate;
@property (nonatomic)NSString *folderid;

@end

@protocol updateView <NSObject>
-(void)updateImage;

@end