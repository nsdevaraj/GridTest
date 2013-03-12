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

@property (strong, retain) ST_Posts *myPost;
@property (nonatomic, strong) AppDelegate *appDelegate;
- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock;
-(void) displayLogin;

- (void)loadWebURL: (NSString*)url;
- (void)likeAction: (NSString*)likeurl;
- (void)reshareAction: (NSString*)likeurl;
- (void)loadProfile: (NSString*)profileid;
- (void)commentlikeAction: (NSString*)likeurl;
- (void)commentunLikeAction: (NSString*)likeurl;
- (NSMutableArray*)getMoreComments: (NSString*)commenturl;
- (void)createComment :(NSString*)postid : (NSString*)commentTxt;
@end
