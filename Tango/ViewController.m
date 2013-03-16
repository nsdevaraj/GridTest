#import "AppDelegate.h"
#import "ViewController.h"
#import "QBPopupMenu.h" 
#import "GSSystem.h"
#import "PostFullView.h" 
#import <QuartzCore/QuartzCore.h> 


@interface ViewController ()<UIScrollViewDelegate>{
    GSSystem *GSMainSystem;
    PostFullView *fullView;
    UIButton *pushButton;
}
@property (nonatomic, retain) QBPopupMenu *popupMenu; 
@end

@implementation ViewController
@synthesize appDelegate,myPost;

-(void)setPageNo:(id)pgNo{
    pushButton.titleLabel.text = [@"Push" stringByAppendingString:pgNo ];
}

- (void)actionsController {
    [self.popupMenu showInView:self.view atPoint:CGPointMake(100,100)];
}

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    GSMainSystem = [[GSSystem alloc]init];
    
    [GSMainSystem createPoints:self.view :false];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
	pushButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[pushButton setTitle:@"Push" forState:UIControlStateNormal];
	[pushButton addTarget:self action:@selector(actionsController) forControlEvents:UIControlEventTouchUpInside];
	[pushButton sizeToFit];
    [self.view addSubview:pushButton];
    
    // popupMenu
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] init];
    
    QBPopupMenuItem *item1 = [QBPopupMenuItem itemWithTitle:@"Reply" image:[UIImage imageNamed:@"icon_reply.png"] target:self action:@selector(reply:)];
    item1.width = 64;
    
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"Favorite" image:[UIImage imageNamed:@"icon_favorite.png"] target:nil action:NULL];
    item2.width = 64;
    
    QBPopupMenuItem *item3 = [QBPopupMenuItem itemWithTitle:@"Retweet" image:[UIImage imageNamed:@"icon_retweet.png"] target:nil action:NULL];
    item3.width = 64;
    
    popupMenu.items = [NSArray arrayWithObjects:item1, item2, item3, nil];
    self.popupMenu = popupMenu;
    
}

#pragma mark delegate
- (void)loadWebURL: (NSString*)url
{
    //    myurl = url;
    [self performSegueWithIdentifier:@"web" sender:self];
}

- (void)commentlikeAction: (NSString*)likeurl
{
    [appDelegate.rest createLike:likeurl];
}
- (void)commentunLikeAction: (NSString*)likeurl
{
    [appDelegate.rest unLike:likeurl];
}

- (void)reshareAction: (NSString*)reshare
{
    [appDelegate.rest createReshare:reshare];
    UIAlertView *alertsView = [[UIAlertView alloc] initWithTitle:@"Social Tango" message:@"Post Reshared"   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertsView show];
}

- (void)likeAction: (NSString*)likeurl
{
    NSString *unlike = myPost.unlike;
    if ((NSNull *)unlike == [NSNull null]) { unlike=@""; }
    if(unlike.length>0){
        [appDelegate.rest unLike:likeurl];
        myPost.likeCount = myPost.likeCount - 1;
        myPost.unlike = @"";
        [fullView  setlikecount:myPost.likeCount :FALSE];
    }else{
        myPost.likeCount = myPost.likeCount + 1;
        myPost.unlike = @"liked";
        [appDelegate.rest createLike:likeurl];
        [fullView  setlikecount:myPost.likeCount :TRUE];
    }
}

- (void)loadProfile: (NSString*)profileid
{
    NSString *usrlink  = @"https://csocial.cognizant.com/u/";
    profileid = [profileid stringByReplacingOccurrencesOfString:usrlink withString:@""];
    appDelegate.myPosts = [appDelegate.rest getUserPosts:profileid];
    [self performSegueWithIdentifier:@"center" sender:self];
}

- (NSMutableArray*)getMoreComments: (NSString*)commenturl
{
    return [appDelegate.rest getComments:commenturl];
}

- (void)createComment : (NSString*)postid : (NSString*)commentTxt
{
    NSString *ctxt = commentTxt;
    if ((NSNull *)ctxt == [NSNull null]) { ctxt=@""; }
    if(ctxt.length >0){
        ST_Comments *comment = [appDelegate.rest createComment:postid :ctxt];
        [myPost.commentsArr addObject: comment];
        [fullView setCommentView:comment];
    }
}
@end