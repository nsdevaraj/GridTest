#import "AppDelegate.h"
#import "ViewController.h"
#import "QBPopupMenu.h"
#import "QBImagePickerController.h"
#import "FullViewController.h"
#import "MPFoldTransition.h"
#import "PopoverView.h"
#import "LoginView.h"
#import "GMGridView.h"
#import "GMGridViewLayoutStrategies.h"
#import "MenuCell.h"
#import "GSSystem.h"
#import <QuartzCore/QuartzCore.h>
#define STAccountNumberKey		@"accountNumber"
#define STPinNumberKey			@"AccessTokenKey"
#define FULL_VIEW_IDENTIFIER		@"FullViewController"
#define NUMBER_ITEMS_ON_LOAD 250

#define kImageArray [NSArray arrayWithObjects:[UIImage imageNamed:@"success"], [UIImage imageNamed:@"error"], nil]

@interface ViewController ()<PopoverViewDelegate,QBImagePickerControllerDelegate,UIScrollViewDelegate,GMGridViewDataSource, GMGridViewTransformationDelegate, GMGridViewActionDelegate>{
    __gm_weak GMGridView *_gmGridView;
    NSMutableArray *_data;
    __gm_weak NSMutableArray *_currentData;
    NSInteger _lastDeleteItemIndexAsked;
    PopoverView *pv;
    LoginView *login;
    GSSystem *GSMainSystem;
}
@property (nonatomic, retain) QBPopupMenu *popupMenu;
- (void)pushViewController;
- (void)revealSidebar;
- (void)addMoreItem;
- (void)removeItem;
- (void)refreshItem;
- (void)dataSetChange:(UISegmentedControl *)control;
@end

@implementation ViewController
@synthesize appDelegate;
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
    [_gmGridView reloadData];
}

-(void) displayLogin{
    CGPoint gpoint =  CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    if(pv==nil)pv=[PopoverView showPopoverAtPoint:gpoint inView:self.view withTitle:@"Login" withContentView:login delegate:self];
}

-(void) loggedIn{
    
    [GSMainSystem createPoints:self.view :false];
    [_gmGridView reloadData];
    [appDelegate.menuController._headers replaceObjectAtIndex:1 withObject:[appDelegate.rest.currentperson.name uppercaseString]];
    NSDictionary *dict = appDelegate.menuController._cellInfos[3][0];
    NSObject *mobj =@{kSidebarCellImageKey:dict[kSidebarCellImageKey],kSidebarCellTextKey:@"Notifications - 3"};
    [self infoArray:3 :0 :mobj];
    
    NSDictionary *pdict = appDelegate.menuController._cellInfos[1][0];
    UIImage*profileImg = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: appDelegate.rest.currentperson.thumbnailurl]]];
    NSObject *pobj =@{kSidebarCellImageKey:profileImg,kSidebarCellTextKey:pdict[kSidebarCellTextKey]};
    [self infoArray:1 :0 :pobj];
    [appDelegate.menuController reloadData];
    [self performSelectorInBackground:@selector(loadUserData) withObject:nil];
}

-(void) loadUserData{
    appDelegate.rest.pageArr = [appDelegate.rest getallPages];
    appDelegate.rest.aspectArr = [appDelegate.rest getallGroups];
    appDelegate.rest.tagArr= [appDelegate.rest getallTags];
    appDelegate.rest.contactArr= [appDelegate.rest getallContacts];
    NSLog(@"%d %d %d %d" , [appDelegate.rest.pageArr count],[appDelegate.rest.aspectArr count],[appDelegate.rest.tagArr count],    [appDelegate.rest.contactArr count]);
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
    [self setloadView];
    _gmGridView.mainSuperView = self.view;
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
	UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[pushButton setTitle:@"Push" forState:UIControlStateNormal];
	//[pushButton addTarget:self action:@selector(pushViewController) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - gmgridview


- (void)loadView
{
    _data = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < NUMBER_ITEMS_ON_LOAD; i ++)
    {
        [_data addObject:[NSString stringWithFormat:@"A %d", i]];
    }
    _currentData = _data;
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)setloadView{
    NSInteger spacing =  5;
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height)];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gmGridView];
    [self.view sendSubviewToBack:gmGridView];
    _gmGridView = gmGridView;
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutVertical];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _gmGridView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        return CGSizeMake([GSMainSystem elevenTwelfthsLeft], [GSMainSystem fiveTwelfthsTop]);
    }else{
        return CGSizeMake([GSMainSystem elevenTwelfthsLeft], [GSMainSystem fourTwelfthsTop]);
    }
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake([GSMainSystem elevenTwelfthsLeft], [GSMainSystem elevenTwelfthsTop]);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor blueColor];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        cell.contentView = view;
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.text = (NSString *)[_currentData objectAtIndex:index];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.highlightedTextColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:label];
    
    
    UIButton *largeButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [largeButton2 setTitle:@"Back" forState:UIControlStateNormal];
    [largeButton2 setFrame:CGRectMake(20, 10, 133, 50)];
    [cell.contentView addSubview:largeButton2];
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
    if(position ==0){
    }
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
}
//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////


- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.backgroundColor = [UIColor yellowColor];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.font = [UIFont boldSystemFontOfSize:20];
    [fullView addSubview:label];
    
    UIButton *largeButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [largeButton2 setTitle:@"Back" forState:UIControlStateNormal];
    [largeButton2 setFrame:CGRectMake(20, 100, 133, 50)];
    [fullView addSubview:largeButton2];
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor blueColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor blueColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
}

- (void)addMoreItem
{
    // Example: adding object at the last position
    NSString *newItem = [NSString stringWithFormat:@"%d", (int)(arc4random() % 1000)];
    [_currentData addObject:newItem];
    [_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
}

- (void)removeItem
{
    // Example: removing last item
    if ([_currentData count] > 0)
    {
        NSInteger index = [_currentData count] - 1;
        [_gmGridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        [_currentData removeObjectAtIndex:index];
    }
}

- (void)refreshItem
{
    // Example: reloading last item
    if ([_currentData count] > 0)
    {
        int index = [_currentData count] - 1;
        NSString *newMessage = [NSString stringWithFormat:@"%d", (arc4random() % 1000)];
        [_currentData replaceObjectAtIndex:index withObject:newMessage];
        [_gmGridView reloadObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
    }
}

- (void)dataSetChange:(UISegmentedControl *)control
{
    _currentData =  _data;
    [_gmGridView reloadData];
}

@end
