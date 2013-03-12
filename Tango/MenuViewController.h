#import <Foundation/Foundation.h>
@class SideViewController;

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithSidebarViewController:(SideViewController *)sidebarVC 
					  withSearchBar:(UISearchBar *)searchBar 
						withHeaders:(NSArray *)headers 
					withControllers:(NSArray *)controllers 
					  withCellInfos:(NSArray *)cellInfos;

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath 
					animated:(BOOL)animated 
			  scrollPosition:(UITableViewScrollPosition)scrollPosition;

@property (nonatomic, strong) NSMutableArray *_headers;
@end
