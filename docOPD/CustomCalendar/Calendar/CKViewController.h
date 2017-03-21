#import <UIKit/UIKit.h>

@interface CKViewController : UIViewController{
    NSInteger weekday;
}
@property(nonatomic, assign)id delegate;
@property(nonatomic, assign)NSString* doctorname;
@property(nonatomic, strong)NSArray *NADay;
@end