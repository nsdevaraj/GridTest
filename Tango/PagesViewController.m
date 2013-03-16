#import "PagesViewController.h"
#import "Cell.h"
#import "MenuCell.h"
#import "ST_Pages.h"
#import "ST_Tags.h"
#import "ST_People.h"
#import "Constants.h"
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
    [self setWithTitle:self.title];
}

- (id)setWithTitle:(NSString *)title {
    self.title = title;
    if(self.title == STMenuNotification){
        spaceArr = appDelegate.rest.notifyCatArr;
    }else if(self.title == STMenuPage){
        spaceArr = [NSMutableArray new];
        for(ST_Pages *pg in appDelegate.rest.pageArr){
            [spaceArr addObject: @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: pg.title}];
        } 
    }else if(self.title == STMenuContact){
        spaceArr = [NSMutableArray new];
        for(ST_People *ppl in appDelegate.rest.contactArr){
            [spaceArr addObject: @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: ppl.displayName}];
        }
    }else if(self.title == STMenuTag){
        spaceArr = [NSMutableArray new];
        for(ST_Tags *tag in appDelegate.rest.tagArr){
            [spaceArr addObject: @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: tag.name}];
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
    cell.imgView.image = [spaceArr objectAtIndex: indexPath.item][kSidebarCellImageKey];
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
