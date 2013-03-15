#import <UIKit/UIKit.h>
#import "AppDelegate.h"
typedef void (^DSRevealBlock)();

@interface DMViewController : UIViewController{
@private
	DSRevealBlock _revealBlock;
}

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) UIButton *largeButton;
@property (nonatomic, strong) UINavigationController *delegate;
@property (nonatomic,assign) BOOL isWithBackBtn;
- (id)initWithTitle:(NSString *)title withRevealBlock:(DSRevealBlock)revealBlock;
- (id)initWithTitle:(NSString *)title;
- (id)setWithTitle:(NSString *)title;
-(void) dismissView;
@end
