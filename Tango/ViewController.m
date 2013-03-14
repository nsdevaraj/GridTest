#import "AppDelegate.h"
#import "ViewController.h"
#import "QBPopupMenu.h"
#import "QBImagePickerController.h"
#import "FullViewController.h"
#import "MPFoldTransition.h"
#import "PopoverView.h"
#import "LoginView.h"
#import "MenuCell.h"
#import "GSSystem.h"
#import "PostFullView.h"
#import "SettingViewController.h"
#import "ST_AspectList.h"
#import <QuartzCore/QuartzCore.h>
#define STAccountNumberKey		@"accountNumber"
#define STPinNumberKey			@"AccessTokenKey"
#define FULL_VIEW_IDENTIFIER		@"FullViewController"
#define NUMBER_ITEMS_ON_LOAD 250

#define kImageArray [NSArray arrayWithObjects:[UIImage imageNamed:@"success"], [UIImage imageNamed:@"error"], nil]

@interface ViewController ()<PopoverViewDelegate,QBImagePickerControllerDelegate,UIScrollViewDelegate>{
    PopoverView *pv;
    LoginView *login;
    GSSystem *GSMainSystem;
    PostFullView *fullView;
}
@property (nonatomic, retain) QBPopupMenu *popupMenu;
- (void)pushViewController;
- (void)revealSidebar;
@end

@implementation ViewController
@synthesize appDelegate,myPost;
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
		self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(revealSidebar)];
        self.navigationItem.rightBarButtonItem = [self composeButton];
	}
	return self;
}


#pragma mark Memory Management
- (id)initWithTitle:(NSString *)title {
	if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
        UIButton* backButton = [UIButton buttonWithType:101];
        [backButton addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setTitle:[title substringToIndex:[title length] - 8] forState:UIControlStateNormal];
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
        self.navigationItem.rightBarButtonItem = [self composeButton];
	}
	return self;
}

-(UIBarButtonItem*) composeButton{
    UIButton* composeButton = [UIButton buttonWithType:102];
    [composeButton addTarget:self action:@selector(composePost:) forControlEvents:UIControlEventTouchUpInside];
    [composeButton setTitle:@"New Post" forState:UIControlStateNormal];
    UIBarButtonItem* composeItem = [[UIBarButtonItem alloc] initWithCustomView:composeButton];
    return composeItem;
}

-(void) dismissView: (id)sender
{
    [self.navigationController popViewControllerWithFoldStyle:MPFoldStyleCubic];
}

- (void)loginSuccess
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:STPinNumberKey]) {
        appDelegate.rest.authorization = [defaults objectForKey:STPinNumberKey];
        appDelegate.rest.currentuserid = [defaults objectForKey:STAccountNumberKey];
        appDelegate.rest.currentperson = [appDelegate.rest getUserProfile :appDelegate.rest.currentuserid];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self loginSuccess];
    login= [[LoginView alloc]init];
    if(appDelegate.rest.authorization.length <2 || [appDelegate.rest.authorization isEqual: @"no network"] ){
        [self displayLogin];
    }else{
        [self loggedIn];
    }
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if(appDelegate.rest.authorization.length <2 || [appDelegate.rest.authorization isEqual: @"no network"] ){
        [pv performSelector:@selector(dismiss) withObject:nil afterDelay:0];
        [self performSelector:@selector(displayLogin) withObject:self afterDelay:0.35];
    }
    [GSMainSystem createPoints:self.view :false];
}

-(void) displayLogin{
    CGPoint gpoint =  CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    if(pv==nil)pv=[PopoverView showPopoverAtPoint:gpoint inView:self.view withTitle:@"Login" withContentView:login delegate:self];
}

-(void) loggedIn{
    [GSMainSystem createPoints:self.view :false];
    [self performSelectorInBackground:@selector(loadUserData) withObject:nil];
}

-(void) loadUserData{
    appDelegate.rest.pageArr = [appDelegate.rest getallPages];
    appDelegate.rest.aspectArr = [appDelegate.rest getallGroups];
    appDelegate.rest.tagArr= [appDelegate.rest getallTags];
    appDelegate.rest.contactArr= [appDelegate.rest getallContacts];
    appDelegate.rest.notifyArr= [appDelegate.rest getNotifications];
    
    if([appDelegate.rest.notifyArr objectAtIndex:0]>0){
        // [appDelegate.menuController._headers replaceObjectAtIndex:1 withObject:[appDelegate.rest.currentperson.name uppercaseString]];
        NSDictionary *dict = appDelegate.menuController._cellInfos[3][0];
        NSObject *mobj =@{kSidebarCellImageKey:dict[kSidebarCellImageKey],kSidebarCellTextKey:dict[kSidebarCellTextKey], kSidebarSettingKey:[NSString stringWithFormat:@"%@", [appDelegate.rest.notifyArr objectAtIndex:0]]};
        [self infoArray:3 :0 :mobj];
    }
    // fill aspects
    NSMutableArray *arr= appDelegate.menuController._controllers[4];
    NSMutableArray *carr= appDelegate.menuController._cellInfos[4];
    if([appDelegate.rest.aspectArr count]>0 && [arr count]==0){
        UINavigationController *aspectcontrol = [[UINavigationController alloc] initWithRootViewController:[[[SettingViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Aspects" withRevealBlock:_revealBlock]];
        for(int i=0; i<[appDelegate.rest.aspectArr count]; i++){
            ST_AspectList *aspect = [appDelegate.rest.aspectArr objectAtIndex:i];
            [arr addObject: aspectcontrol];
            NSObject *mobj =@{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"],kSidebarCellTextKey:aspect.groupName,kSidebarImgSettingKey:@"Post", kSidebarObjectKey:aspect};
            [carr addObject:mobj];
        }
    }
    [appDelegate.menuController._controllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		[((NSArray *)obj) enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2){
			UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:appDelegate.revealController
																						 action:@selector(dragContentView:)];
			panGesture.cancelsTouchesInView = YES;
			[((UINavigationController *)obj2).navigationBar addGestureRecognizer:panGesture];
		}];
	}];
    UIImage*profileImg = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: appDelegate.rest.currentperson.thumbnailurl]]];
    NSObject *pobj =@{kSidebarCellImageKey:profileImg,kSidebarCellTextKey:appDelegate.rest.currentperson.name};
    [self infoArray:0 :0 :pobj];
    [appDelegate.menuController reloadData];
    NSLog(@"%d %d %d %d %@" , [appDelegate.rest.pageArr count],[appDelegate.rest.aspectArr count],[appDelegate.rest.tagArr count],    [appDelegate.rest.contactArr count],[appDelegate.rest.notifyArr objectAtIndex:0]);
}

-(void)setPageNo:(id)pgNo{
    NSLog(@"her %@",pgNo);
}

- (void) infoArray :(int)index :(int)row :(NSObject*)mobj{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSArray *activArr= [appDelegate.menuController._cellInfos objectAtIndex:index];
    for(int i=0; i<[activArr count]; i++){
        NSObject *obj = [activArr objectAtIndex:i];
        if(i==row) {
            [arr addObject:mobj];
        }else{
            [arr addObject:obj];
        }
    }
    [appDelegate.menuController._cellInfos replaceObjectAtIndex:index withObject: arr];
}

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    [self performSelector:@selector(setHidden:) withObject:popoverView afterDelay:0.1];
}

-(void) setHidden:(PopoverView *)popoverView{
    if(appDelegate.rest.authorization.length >2 && ![appDelegate.rest.authorization isEqual: @"no network"] ){
        [popoverView showImage:[UIImage imageNamed:@"success"] withMessage:@"ST"];
        [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
        [self loggedIn];
    }
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    // NSLog(@"%s", __PRETTY_FUNCTION__);
    pv = nil;
}

- (void)composePost :(id)sender{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)actionsController {
    [self.popupMenu showInView:self.view atPoint:CGPointMake(100,100)];
}

#pragma mark Private Methods
- (void)pushViewController {
	NSString *vcTitle = [self.title stringByAppendingString:@" - Pushed"];
    [self.navigationController pushViewController:[[FullViewController alloc] initWithTitle:vcTitle] foldStyle:MPFoldStyleFlipFoldBit(MPFoldStyleCubic)];
}

- (void)revealSidebar {
	_revealBlock();
}

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    GSMainSystem = [[GSSystem alloc]init];
    
    [GSMainSystem createPoints:self.view :false];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
	UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[pushButton setTitle:@"Push" forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(pushViewController) forControlEvents:UIControlEventTouchUpInside];
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
#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if(imagePickerController.allowsMultipleSelection) {
        NSArray *mediaInfoArray = (NSArray *)info;
        
        NSLog(@"Selected %d photos", mediaInfoArray.count);
    } else {
        NSDictionary *mediaInfo = (NSDictionary *)info;
        NSLog(@"Selected: %@", mediaInfo);
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"selected all";
}

- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"deselected all";
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    return [NSString stringWithFormat:@"%d", numberOfPhotos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"%d", numberOfVideos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"%d %d", numberOfPhotos, numberOfVideos];
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
