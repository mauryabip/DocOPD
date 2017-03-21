#import <UIKit/UIKit.h>

@interface CKViewController : UIViewController{
    NSInteger weekday;
}
@property(nonatomic,strong)NSString *doctorname;
@property(nonatomic, assign)id delegate;
@end
@protocol informBack <NSObject>

-(void)selectedDate:(NSString*)Date weekDay:(NSInteger)Day;

@end