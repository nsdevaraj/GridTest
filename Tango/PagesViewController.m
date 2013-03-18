#import "PagesViewController.h"
#import "Cell.h"
#import "MenuCell.h"
#import "ST_Pages.h"
#import "ST_Tags.h"
#import "ST_People.h"
#import "Constants.h"
#import "HJManagedImageV.h"
#import "MPFoldTransition.h"
@interface PagesViewController (){
    NSMutableArray *spaceArr;
}
@end

@implementation PagesViewController
@synthesize vc,appDelegate;
-(void)viewDidLoad
{
	[super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.collectionView addGestureRecognizer:tap];
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"MY_CELL"];
}

-(void)viewDidAppear:(BOOL)animated{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self performSelectorInBackground:@selector(setWithTitle:) withObject:self.title ];
}

-(void) managedImageSet:(HJManagedImageV*)mi
{
    mi.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (id)setWithTitle:(NSString *)title {
    self.title = title;
    if([self.title isEqual: STMenuNotification]){
        spaceArr = appDelegate.rest.notifyCatArr;
    }else if([self.title isEqual: STMenuPage]){
        spaceArr = [NSMutableArray new];
        for(ST_Pages *pg in appDelegate.rest.pageArr){            
            HJManagedImageV *_tileImageView = [[HJManagedImageV alloc] init];
            [_tileImageView showLoadingWheel];
            _tileImageView.url = [NSURL URLWithString:pg.logo];
            _tileImageView.callbackOnSetImage = (id)self;
            [appDelegate.imgMan manage:_tileImageView];
            [spaceArr addObject: @{kSidebarCellImageKey: _tileImageView, kSidebarCellTextKey: pg.title}];
        } 
    }else if([self.title isEqual: STMenuContact]){
        spaceArr = [NSMutableArray new];
        for(ST_People *ppl in appDelegate.rest.contactArr){          
            HJManagedImageV *_tileImageView = [[HJManagedImageV alloc] init];
            [_tileImageView showLoadingWheel];
            _tileImageView.url = [NSURL URLWithString:ppl.thumbnailurl];
            _tileImageView.callbackOnSetImage = (id)self;
            [appDelegate.imgMan manage:_tileImageView];
            [spaceArr addObject: @{kSidebarCellImageKey: _tileImageView, kSidebarCellTextKey: ppl.displayName}];
        }
    }else if([self.title isEqual: STMenuTag]){
        spaceArr = [NSMutableArray new];                
        HJManagedImageV *_tileImageView = [[HJManagedImageV alloc] init];
        _tileImageView.image = [UIImage imageNamed:@"user.png"];
        for(ST_Tags *tag in appDelegate.rest.tagArr){
            [spaceArr addObject: @{kSidebarCellImageKey: _tileImageView, kSidebarCellTextKey: tag.name}];
        } 
    }
    [self.collectionView reloadData];
    if(vc.isWithBackBtn) [vc dismissView];
    return self;
}

- (void)tapped:(UITapGestureRecognizer *)sender
{
    NSIndexPath* pinchedCellPath = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
    NSString *vcTitle;
    vcTitle = [spaceArr objectAtIndex:pinchedCellPath.item][kSidebarCellTextKey];
    [self.navigationController pushViewController:[vc initWithTitle:vcTitle] foldStyle:MPFoldStyleFlipFoldBit(MPFoldStyleCubic)];
}

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [spaceArr count];
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    cell.label.text = [spaceArr objectAtIndex: indexPath.item][kSidebarCellTextKey];
    HJManagedImageV *_tileImageView =[spaceArr objectAtIndex: indexPath.item][kSidebarCellImageKey];
    cell.imgView.image = _tileImageView.image;
    return cell;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (id)initWithTitle:(NSString *)title withRevealBlock:(PRevealBlock)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
        vc = [[[DMViewController alloc] initWithNibName:nil bundle:nil] initWithTitle:@"Stream" withRevealBlock:_revealBlock];
		self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(revealSidebar)];
	}
	return self;
}


- (void)revealSidebar {
	_revealBlock();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
