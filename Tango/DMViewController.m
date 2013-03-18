#import "MPFoldTransition.h"
#import "QBImagePickerController.h"
#import "DMViewController.h"
#import "DMLazyScrollView.h"
#import "ViewController.h"
#import "ST_AspectList.h"
#import "LoginView.h"
#import "AppDelegate.h"
#import "GSSystem.h"

#import "PopoverView.h"
#import "MenuCell.h"
#import "Constants.h"
@interface DMViewController () <DMLazyScrollViewDelegate,QBImagePickerControllerDelegate,PopoverViewDelegate> {
    DMLazyScrollView* lazyScrollView;
    NSMutableArray*    viewControllerArray;
    NSMutableArray*    vpagesArray;
    NSUInteger virtualPages;
    NSUInteger currentVPgNo;
    NSUInteger numberOfPages;
    LoginView *login;
    PopoverView *pv;
    GSSystem *GSMainSystem;
}
@end

@implementation DMViewController
@synthesize appDelegate,isWithBackBtn;

//util function for modifying sidetable menu
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

// on initial login
-(void) loadUserData{
    @try {
        appDelegate.rest.pageArr = [appDelegate.rest getallPages];
        appDelegate.rest.aspectArr = [appDelegate.rest getallGroups];
        appDelegate.rest.tagArr= [appDelegate.rest getallTags];
        appDelegate.rest.contactArr= [appDelegate.rest getallContacts];
        appDelegate.rest.notifyArr= [appDelegate.rest getNotifications];
        //display notification unread count
        if([appDelegate.rest.notifyArr objectAtIndex:0]>0){
            NSDictionary *dict = appDelegate.menuController._cellInfos[3][0];
            NSObject *mobj =@{kSidebarCellImageKey:dict[kSidebarCellImageKey],kSidebarCellTextKey:dict[kSidebarCellTextKey], kSidebarSettingKey:[NSString stringWithFormat:@"%@", [appDelegate.rest.notifyArr objectAtIndex:0]]};
            [self infoArray:3 :0 :mobj];
        }
        // fill aspects
        NSMutableArray *arr= appDelegate.menuController._controllers[4];
        NSMutableArray *carr= appDelegate.menuController._cellInfos[4];
        if([appDelegate.rest.aspectArr count]>0 && [arr count]==0){
            UINavigationController *aspectcontrol = self.delegate;
            for(int i=0; i<[appDelegate.rest.aspectArr count]; i++){
                ST_AspectList *aspect = [appDelegate.rest.aspectArr objectAtIndex:i];
                [arr addObject: aspectcontrol];
                NSObject *mobj =@{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"],kSidebarCellTextKey:aspect.groupName,kSidebarImgSettingKey:@"Post", kSidebarObjectKey:aspect};
                [carr addObject:mobj];
            }
        }
        //swipe gesture for newly added aspect controllers
        [appDelegate.menuController._controllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [((NSArray *)obj) enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2){
                UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:appDelegate.revealController
                                                                                             action:@selector(dragContentView:)];
                panGesture.cancelsTouchesInView = YES;
                [((UINavigationController *)obj2).navigationBar addGestureRecognizer:panGesture];
            }];
        }];
        //set profile image
        UIImage*profileImg = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: appDelegate.rest.currentperson.thumbnailurl]]];
        NSObject *pobj =@{kSidebarCellImageKey:profileImg,kSidebarCellTextKey:appDelegate.rest.currentperson.name };
        [self infoArray:0 :0 :pobj];
        
        [appDelegate.menuController reloadData];
        NSLog(@"%d %d %d %d %@" , [appDelegate.rest.pageArr count],[appDelegate.rest.aspectArr count],[appDelegate.rest.tagArr count],    [appDelegate.rest.contactArr count],[appDelegate.rest.notifyArr objectAtIndex:0]);
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
}

//post login
-(void) loggedIn{
    [GSMainSystem createPoints:self.view :false];
    [self performSelectorInBackground:@selector(loadUserData) withObject:nil];
    appDelegate.loggedIn = YES;
}

// on login handler
- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    [self performSelector:@selector(setHidden:) withObject:popoverView afterDelay:0.1];
}
//close login
-(void) setHidden:(PopoverView *)popoverView{
    if(appDelegate.rest.authorization.length >2 && ![appDelegate.rest.authorization isEqual: @"no network"] ){
        [popoverView showImage:[UIImage imageNamed:@"success"] withMessage:@"ST"];
        [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
        if(!appDelegate.loggedIn)[self loggedIn];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self loginSuccess];
    login= [[LoginView alloc]init];
    if(appDelegate.rest.authorization.length <2 || [appDelegate.rest.authorization isEqual: @"no network"] ){
        appDelegate.loggedIn = NO;
        [self displayLogin];
    }else if(!appDelegate.loggedIn){
        [self loggedIn];
    }
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

- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    // NSLog(@"%s", __PRETTY_FUNCTION__);
    pv = nil;
}

-(void) displayLogin{
    CGPoint gpoint =  CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    if(pv==nil)pv=[PopoverView showPopoverAtPoint:gpoint inView:self.view withTitle:@"Login" withContentView:login delegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // PREPARE PAGES
    numberOfPages = 3;
    virtualPages = 6;
    vpagesArray = [[NSMutableArray alloc] initWithCapacity:virtualPages];
    for (NSUInteger k = 0; k < virtualPages; ++k) {
        [vpagesArray addObject:[NSString stringWithFormat:@"%d",k ]];
    }
    viewControllerArray = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    for (NSUInteger k = 0; k < numberOfPages; ++k) {
        ViewController *vc=[[ViewController alloc]init];
        [viewControllerArray addObject:vc];//[NSNull null]];
    }
    // PREPARE LAZY VIEW
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    lazyScrollView = [[DMLazyScrollView alloc] initWithFrame:rect];
    
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    lazyScrollView.dataSource = ^(NSUInteger index) {
        return [weakSelf controllerAtIndex:index];
    };
    lazyScrollView.numberOfPages = numberOfPages;
    [self.view addSubview:lazyScrollView];
    
    currentVPgNo =0;
    [self setInitPages];
    //    [lazyScrollView moveByPages:3 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id)setWithTitle:(NSString *)title {
    if(isWithBackBtn){
        [self dismissView];
    }
    self.title = title;
    if(self.title==appDelegate.rest.currentperson.name){
        self.navigationItem.rightBarButtonItem = [self logoutButton];
    }else if([self.title isEqual: STMenuPublic]){
    }else if([self.title isEqual: STMenuStream]){
    }else if([self.title isEqual: STMenuMention]){
    }else if([self.title isEqual: STMenuComment]){
    }else if([self.title isEqual: STMenuLike]){
    }
    return self;
}

//markas read handler
-(UIBarButtonItem*) markAsReadButton{
    UIButton* logoutButton = [UIButton buttonWithType:102];
    [logoutButton addTarget:self action:@selector(ReadButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setTitle:@"Mark as Read" forState:UIControlStateNormal];
    UIBarButtonItem* composeItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    return composeItem;
}

//read action
- (IBAction) ReadButtonReleased:(id)sender {
}

//logout handler
-(UIBarButtonItem*) logoutButton{
    UIButton* logoutButton = [UIButton buttonWithType:102];
    [logoutButton addTarget:self action:@selector(ButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    UIBarButtonItem* composeItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    return composeItem;
}

//logout action
- (IBAction) ButtonReleased:(id)sender {
    appDelegate.rest.authorization = nil;
    appDelegate.rest.currentuserid = nil;
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.rest.authorization forKey:STPinNumberKey];
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.rest.currentuserid forKey:STAccountNumberKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [appDelegate.menuController relogin];
}

// on call of any menu change
-(void)setObject:(id)obj{
    NSLog(@"her asp %@",obj);
    
    if ([obj isKindOfClass:[ST_AspectList class]]){
        
    }
}
// init
- (id)initWithTitle:(NSString *)title withRevealBlock:(DSRevealBlock)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
		self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(revealSidebar)];
        self.navigationItem.rightBarButtonItem = [self composeButton];
	}
	return self;
}

//show side bar
- (void)revealSidebar {
	_revealBlock();
}

//back button for pages
#pragma mark Memory Management
- (id)initWithTitle:(NSString *)title {
    self.title = title;
    isWithBackBtn = YES;
    UIButton* backButton = [UIButton buttonWithType:101];
    [backButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:[title substringToIndex:[title length] - 8] forState:UIControlStateNormal];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.rightBarButtonItem = [self composeButton];
    if([self.title isEqual: STNotificationAlsoComment]){
        self.navigationItem.rightBarButtonItem = [self markAsReadButton];
    }else if([self.title isEqual: STNotificationComment]){
        self.navigationItem.rightBarButtonItem = [self markAsReadButton];
    }else if([self.title isEqual: STNotificationLike]){
        self.navigationItem.rightBarButtonItem = [self markAsReadButton];
    }else if([self.title isEqual: STNotificationMentioned]){
        self.navigationItem.rightBarButtonItem = [self markAsReadButton];
    }else if([self.title isEqual: STNotificationPgPost]){
        self.navigationItem.rightBarButtonItem = [self markAsReadButton];
    }else if([self.title isEqual: STNotificationReshare]){
        self.navigationItem.rightBarButtonItem = [self markAsReadButton];
    }
	return self;
}
// on back for pages
-(void) dismissView
{
    [self.navigationController popViewControllerWithFoldStyle:MPFoldStyleCubic];
}
//compose multiple pic picker
- (void)composePost :(id)sender{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}
//right bar button
-(UIBarButtonItem*) composeButton{
    UIButton* composeButton = [UIButton buttonWithType:102];
    [composeButton addTarget:self action:@selector(composePost:) forControlEvents:UIControlEventTouchUpInside];
    [composeButton setTitle:@"New Post" forState:UIControlStateNormal];
    UIBarButtonItem* composeItem = [[UIBarButtonItem alloc] initWithCustomView:composeButton];
    return composeItem;
}
// on scroll of lazy view
- (UIViewController *) controllerAtIndex:(NSInteger) index {
    if (index > viewControllerArray.count || index < 0) return nil;
    id res = [viewControllerArray objectAtIndex:index];
    if(lazyScrollView.currentPage == index){
        [self virtualControllerAtIndex:index];
    }
    return res;
}

//set 3 initial pages
-(void)setInitPages{
    for (NSUInteger k = 0; k < numberOfPages; ++k) {
        id res = [viewControllerArray objectAtIndex:k];
        [self setPage:res :k];
    }
    lazyScrollView.backScrollEnabled = NO;
}

// set any page with data
-(void)setPage: (id) res : (NSUInteger)vpgno{
    [res performSelector:@selector(setPageNo:) withObject:[NSString stringWithFormat:@"%d",vpgno]];
}
//do virtualization
- (void) virtualControllerAtIndex:(NSInteger) index {
    if(lazyScrollView.movesForward){
        currentVPgNo = currentVPgNo+1;
        id res = [viewControllerArray objectAtIndex:lazyScrollView.nextPg];
        [self setPage:res :currentVPgNo+1];
    }else{
        currentVPgNo = currentVPgNo-1;
        id res = [viewControllerArray objectAtIndex:lazyScrollView.prevPg];
        [self setPage:res :currentVPgNo-1];
    }
    if(currentVPgNo == 0){
        lazyScrollView.backScrollEnabled =  NO;
    }else if(currentVPgNo == [vpagesArray count]-1){
        lazyScrollView.frontScrollEnabled = NO;
    }else{
        lazyScrollView.backScrollEnabled = YES;
        lazyScrollView.frontScrollEnabled = YES;
    }
}
//current virtual page
- (void)lazyScrollViewDidEndDragging:(DMLazyScrollView *)pagingView {
    NSLog(@"Now visible: %@",lazyScrollView.visibleViewController);
}

// on rotate relocate login popup
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if(appDelegate.rest.authorization.length <2 || [appDelegate.rest.authorization isEqual: @"no network"] ){
        [pv performSelector:@selector(dismiss) withObject:nil afterDelay:0];
        [self performSelector:@selector(displayLogin) withObject:self afterDelay:0.35];
    }
    [GSMainSystem createPoints:self.view :false];
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
@end