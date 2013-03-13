//
//  DMViewController.m
//  DMLazyScrollViewExample
//
//  Created by Daniele Margutti (me@danielemargutti.com) on 24/11/12.
//  Copyright (c) 2012 http://www.danielemargutti.com. All rights reserved.
//

#import "DMViewController.h"
#import "DMLazyScrollView.h"
#import "DMDViewController.h"

#define ARC4RANDOM_MAX	0x100000000
@interface DMViewController () <DMLazyScrollViewDelegate> {
    DMLazyScrollView* lazyScrollView;
    NSMutableArray*    viewControllerArray;
    NSMutableArray*    vpagesArray;
    NSUInteger virtualPages;
    NSUInteger currentVPgNo;
    NSUInteger numberOfPages;
}
@end

@implementation DMViewController

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
        DMDViewController *vc=[[DMDViewController alloc]init];
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

- (id)initWithTitle:(NSString *)title withRevealBlock:(DSRevealBlock)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
		self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(revealSidebar)];
	}
	return self;
}

- (void)revealSidebar {
	_revealBlock();
}

- (UIViewController *) controllerAtIndex:(NSInteger) index {
    if (index > viewControllerArray.count || index < 0) return nil;
    id res = [viewControllerArray objectAtIndex:index];
    if(lazyScrollView.currentPage == index){
        [self virtualControllerAtIndex:index];
    }
    return res;
}

-(void)setInitPages{
    for (NSUInteger k = 0; k < numberOfPages; ++k) {
        id res = [viewControllerArray objectAtIndex:k];
        [res setTitle:[NSString stringWithFormat:@"%d", k]];
    }
    lazyScrollView.backScrollEnabled = NO;
}

- (void) virtualControllerAtIndex:(NSInteger) index {
    if(lazyScrollView.movesForward){
        currentVPgNo = currentVPgNo+1;
        id res = [viewControllerArray objectAtIndex:lazyScrollView.nextPg];
        [res setTitle:[NSString stringWithFormat:@"%d", currentVPgNo+1]];        
    }else{
        currentVPgNo = currentVPgNo-1;
        id res = [viewControllerArray objectAtIndex:lazyScrollView.prevPg];
        [res setTitle:[NSString stringWithFormat:@"%d", currentVPgNo-1]];
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

/*
 - (void)lazyScrollViewDidEndDragging:(DMLazyScrollView *)pagingView {
 NSLog(@"Now visible: %@",lazyScrollView.visibleViewController);
 }
 */
@end