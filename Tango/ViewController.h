//
//  ViewController.h
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

#import <Foundation/Foundation.h> 
#import "AppDelegate.h"
typedef void (^RevealBlock)();

@interface ViewController : UIViewController {
@private
	RevealBlock _revealBlock;
}
@property (nonatomic, strong) AppDelegate *appDelegate;
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock;
-(void) displayLogin;
@end
