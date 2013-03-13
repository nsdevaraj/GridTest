#import <UIKit/UIKit.h>
#import "AppDelegate.h"
typedef void (^DSRevealBlock)();

@interface DMViewController : UIViewController{
@private
	DSRevealBlock _revealBlock;
}

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) UIButton *largeButton;
- (id)initWithTitle:(NSString *)title withRevealBlock:(DSRevealBlock)revealBlock;

@end
