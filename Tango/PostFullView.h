#import <UIKit/UIKit.h>
#import "ST_Posts.h"
#import "ST_Comments.h"
#import "FullViewController.h"
@class CSLinearLayoutView;
@interface PostFullView : UIView
@property (nonatomic,strong) ST_Posts* post;
@property (nonatomic, retain) CSLinearLayoutView *verticallinearLayoutView;
@property (nonatomic, retain) CSLinearLayoutView *horizontalStatuslinearLayoutView;
@property (nonatomic, retain) CSLinearLayoutView *verticalcommentLayoutView;
@property (nonatomic, retain) CSLinearLayoutView *fullLayoutView;
@property (nonatomic, retain) FullViewController *delegate;
- (void) setPost:(ST_Posts *) post :(BOOL) isPortrait;
- (void)clikeAction: (NSString*)likeurl;
- (void)cunlikeAction: (NSString*)likeurl;
- (void) setlikecount:(int)count :(BOOL)liked;
- (void) setPostLayout:(BOOL)isPortrait;
- (void) addLayoutComps;
- (void) setComments;
- (void)setCommentView:(ST_Comments*)comment;
@end