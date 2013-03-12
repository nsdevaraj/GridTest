#import "AppDelegate.h"
#import "MenuCell.h"
#import "MenuViewController.h"
#import "ViewController.h"
#import "SideViewController.h"

@interface AppDelegate () <UISearchBarDelegate>
@property (nonatomic, strong) SideViewController *revealController;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) MenuViewController *menuController;
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

	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
	
	UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
	self.revealController = [[SideViewController alloc] initWithNibName:nil bundle:nil];
    
	self.revealController.view.backgroundColor = bgColor;
	RevealBlock revealBlock = ^(){
		[self.revealController toggleSidebar:!self.revealController.sidebarShowing
									duration:kGHRevealSidebarDefaultAnimationDuration];
	};
    
	NSMutableArray *headers = [NSMutableArray arrayWithArray:@[
                      @"STREAM",
                      @"USER",
                      @"SPACES",
                      @"ACTIVITY"
                      ]];
	NSArray *controllers = @[
                          @[
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Stream" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Public" withRevealBlock:revealBlock]]
                              //,[[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Polls" withRevealBlock:revealBlock]],
                              //[[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Docs" withRevealBlock:revealBlock]]
                              ],
                          @[
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Profile" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Settings" withRevealBlock:revealBlock]]
                              ],
                          @[
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Pages" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Contacts" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Aspects" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Tags" withRevealBlock:revealBlock]]
                              ],
                          @[
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Notifications" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Mentions" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Comments" withRevealBlock:revealBlock]],
                              [[UINavigationController alloc] initWithRootViewController:[[[ViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Likes" withRevealBlock:revealBlock]]
                              ]
                          ];
	NSArray *cellInfos = @[
                        @[
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Stream", @"")},
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Public", @"")}
                            ],
                        @[
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Profile", @"")},
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Settings", @"")}
                            ],
                        @[
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Pages", @"")},
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Contacts", @"")},
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Aspects", @"")},
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Tags", @"")}
                            ],
                        @[
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Notifications", @"")},
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Mentions", @"")},
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Comments", @"")},
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Likes", @"")}
                            ]/*,
                        @[
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Mentioned", @"")},
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Commented", @"")},
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Also Commented", @"")},
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Likes", @"")},
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Reshared", @"")},
                            @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Page's Posts", @"")}
                            ]*/
                        ];
	// Add drag feature to each root navigation controller
	[controllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		[((NSArray *)obj) enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2){
			UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.revealController
																						 action:@selector(dragContentView:)];
			panGesture.cancelsTouchesInView = YES;
			[((UINavigationController *)obj2).navigationBar addGestureRecognizer:panGesture];
		}];
	}];
	searchBar = [[UISearchBar alloc] init];
	searchBar.delegate = self;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.backgroundImage = [UIImage imageNamed:@"searchBarBG.png"];
    searchBar.placeholder = NSLocalizedString(@"Search", @"");
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
