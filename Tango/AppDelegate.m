#import "AppDelegate.h"
#import "MenuCell.h"
#import "ViewController.h"
#import "SettingViewController.h"
#import "SideViewController.h"
#import "DMViewController.h"

#import "PagesViewController.h"
#import "LineLayout.h"
@interface AppDelegate () <UISearchBarDelegate>
@property (nonatomic, strong) SideViewController *revealController;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation AppDelegate
@synthesize window;
@synthesize rest;
@synthesize myPosts,curPgId;
@synthesize revealController, searchBar, menuController;

- (void)searchBarSearchButtonClicked:(UISearchBar *)ssearchBar;
{
    NSLog(@"%@",ssearchBar.text);
	[ssearchBar resignFirstResponder];
}

+(BOOL) orientationIsLandscape{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

+(BOOL) deviceIsPhone{
    UIDevice *device = UIDevice.currentDevice;
    return device.userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

#pragma mark UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    rest = [[RestAPI alloc]init];
    rest.urlval = @"https://csocial.cognizant.com";
    rest.appkey = @"b8a33356e2b9f30b";
    
    self.imgMan = [[HJObjManager alloc] init];
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/imgtable/"] ;
	HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
    self.imgMan.fileCache = fileCache;
    
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
	
	UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
	self.revealController = [[SideViewController alloc] initWithNibName:nil bundle:nil];
    LineLayout* lineLayout = [[LineLayout alloc] init];
    
    
	self.revealController.view.backgroundColor = bgColor;
	RevealBlock revealBlock = ^(){
		[self.revealController toggleSidebar:!self.revealController.sidebarShowing
									duration:kGHRevealSidebarDefaultAnimationDuration];
	};
    
	NSMutableArray *headers = [NSMutableArray arrayWithArray:@[
                               [NSNull null],
                               @"STREAM",
                               @"SPACES",
                               @"ACTIVITY",
                               @"ASPECTS"
                               ]];
	NSArray *controllers = @[
                          @[
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Profile" withRevealBlock:revealBlock]]
                              ],
                          @[
                              [[UINavigationController alloc] initWithRootViewController:[[[DMViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Stream" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Public" withRevealBlock:revealBlock]]
                              //,[[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Polls" withRevealBlock:revealBlock]],
                              //[[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Docs" withRevealBlock:revealBlock]]
                              ],
                          @[
                              [[UINavigationController alloc] initWithRootViewController:[[[PagesViewController alloc] initWithCollectionViewLayout:lineLayout] initWithTitle:@"Pages" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[PagesViewController alloc] initWithCollectionViewLayout:lineLayout] initWithTitle:@"Contacts" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[PagesViewController alloc] initWithCollectionViewLayout:lineLayout] initWithTitle:@"Tags" withRevealBlock:revealBlock]]
                              ],
                          @[
                              [[UINavigationController alloc] initWithRootViewController:[[[PagesViewController alloc] initWithCollectionViewLayout:lineLayout] initWithTitle:@"Notifications" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Mentions" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Comments" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Likes" withRevealBlock:revealBlock]]
                              ],
                          [NSMutableArray arrayWithArray:@[
                           ]]
                          ];
	NSMutableArray *cellInfos =  [NSMutableArray arrayWithArray:@[
                                  @[
                                  @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: @"Profile"}
                                  ],
                                  @[
                                  @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: @"Stream"},
                                  @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: @"Public"}
                                  ],
                                  @[
                                  @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: @"Pages"},
                                  @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: @"Contacts"},
                                  @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: @"Tags"}
                                  ],
                                  @[
                                  @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: @"Notifications"},
                                  @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: @"Mentions"},
                                  @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: @"Comments"},
                                  @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: @"Likes"}
                                  ],
                                  [NSMutableArray arrayWithArray:@[
                                   ]]
                                  ]];
    //@"Mentioned", @"Commented", @"Also Commented", @"Likes", @"Reshared", @"Page's Posts"
	// Add drag feature to each root navigation controller
	[controllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		[((NSArray *)obj) enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2){
			UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.revealController
																						 action:@selector(dragContentView:)];
			panGesture.cancelsTouchesInView = YES;
			[((UINavigationController *)obj2).navigationBar addGestureRecognizer:panGesture];
		}];
	}];
    revealBlock();
	searchBar = [[UISearchBar alloc] init];
	searchBar.delegate = self;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.backgroundImage = [UIImage imageNamed:@"searchBarBG.png"];
    searchBar.placeholder = @"Search";
    searchBar.tintColor = [UIColor colorWithRed:(58.0f/255.0f) green:(67.0f/255.0f) blue:(104.0f/255.0f) alpha:1.0f];
	for (UIView *subview in searchBar.subviews) {
		if ([subview isKindOfClass:[UITextField class]]) {
			UITextField *searchTextField = (UITextField *) subview;
			searchTextField.textColor = [UIColor colorWithRed:(154.0f/255.0f) green:(162.0f/255.0f) blue:(176.0f/255.0f) alpha:1.0f];
		}
	}
	[searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"searchTextBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(16.0f, 17.0f, 16.0f, 17.0f)]
                                    forState:UIControlStateNormal];
	[searchBar setImage:[UIImage imageNamed:@"searchBarIcon.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
	self.menuController = [[MenuViewController alloc] initWithSidebarViewController:self.revealController
                                                                      withSearchBar:searchBar
                                                                        withHeaders:headers
                                                                    withControllers:controllers
                                                                      withCellInfos:cellInfos];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = self.revealController;
    [self.window makeKeyAndVisible];
    return YES;
}
@end
