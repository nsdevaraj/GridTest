#import "AppDelegate.h"
#import "ViewController.h"
#import "QBPopupMenu.h"
#import "QBImagePickerController.h"
#import "FullViewController.h"
#import "MPFoldTransition.h"
#import "MPFlipTransition.h"
#import "PopoverView.h"   

#define FULL_VIEW_IDENTIFIER		@"FullViewController"
#define kStringArray [NSArray arrayWithObjects:@"YES", @"NO", nil]
#define kImageArray [NSArray arrayWithObjects:[UIImage imageNamed:@"success"], [UIImage imageNamed:@"error"], nil]

#pragma mark -
#pragma mark Private Interface
@interface ViewController ()<PopoverViewDelegate,QBImagePickerControllerDelegate,UIScrollViewDelegate>{
    PopoverView *pv;  
}                                                           
@property (nonatomic, retain) QBPopupMenu *popupMenu;
- (void)pushViewController;
- (void)revealSidebar;
@end

@implementation ViewController
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
		self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(revealSidebar)];
	}
	return self;
}

- (void)viewDidAppear:(BOOL)animated
{    
    [super viewDidAppear:animated];
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation
                                           duration:1];
    [self didRotateFromInterfaceOrientation:UIInterfaceOrientationPortrait];
    CGPoint gpoint;
    gpoint.x = 0;
    gpoint.y = 0;
    pv = [PopoverView showPopoverAtPoint:gpoint
                                  inView:self.view
                         withStringArray:kStringArray
                          withImageArray:kImageArray
                                delegate:self];
}

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%s item:%d", __PRETTY_FUNCTION__, index);
    
    // Figure out which string was selected, store in "string"
    NSString *string = [kStringArray objectAtIndex:index];
    
    // Show a success image, with the string from the array
    [popoverView showImage:[UIImage imageNamed:@"success"] withMessage:string];
    
    // alternatively, you can use
    // [popoverView showSuccess];
    // or
    // [popoverView showError];
    
    // Dismiss the PopoverView after 0.5 seconds
    [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    pv = nil;
}

- (void)push3ViewController
{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)push2ViewController {
    [self.popupMenu showInView:self.view atPoint:CGPointMake(100,100)];
}

#pragma mark Private Methods
- (void)pushViewController {
	NSString *vcTitle = [self.title stringByAppendingString:@" - Pushed"]; 
    
	UIViewController *vc = [[FullViewController alloc] initWithTitle:vcTitle];
	//[self.navigationController pushViewController:vc animated:YES];
    
    [self.navigationController pushViewController:vc foldStyle:MPFoldStyleFlipFoldBit(MPFoldStyleCubic)];
}

- (void)revealSidebar {
	_revealBlock();
}

#pragma mark UIViewController
- (void)viewDidLoad {
    
    [super viewDidLoad]; 
   
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
	UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
	[pushButton setTitle:@"Push" forState:UIControlStateNormal];
	[pushButton addTarget:self action:@selector(pushViewController) forControlEvents:UIControlEventTouchUpInside];
	[pushButton sizeToFit];
    [self.view addSubview:pushButton]; 
     
    UIButton *pushButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pushButton2.frame = CGRectMake(0,100,pushButton2.frame.size.width,pushButton2.frame.size.height);
	[pushButton2 setTitle:@"Push2" forState:UIControlStateNormal];
	[pushButton2 addTarget:self action:@selector(push2ViewController) forControlEvents:UIControlEventTouchUpInside];
	[pushButton2 sizeToFit];
    [self.view addSubview:pushButton2];
    
    UIButton *pushButton3= [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
	pushButton3.frame = CGRectMake(0,200,pushButton2.frame.size.width,pushButton2.frame.size.height);
	[pushButton3 setTitle:@"Push3" forState:UIControlStateNormal];
	[pushButton3 addTarget:self action:@selector(push3ViewController) forControlEvents:UIControlEventTouchUpInside];
	[pushButton3 sizeToFit];
    [self.view addSubview:pushButton3];
    
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
@end
