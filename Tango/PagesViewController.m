//
//  PagesViewController.m
//  Tango
//
//  Created by Devaraj NS on 12/03/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//

#import "PagesViewController.h"
#import "Cell.h"
@interface PagesViewController ()

@end

@implementation PagesViewController

-(void)viewDidLoad
{
	[super viewDidLoad];
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"MY_CELL"];
    [self.collectionView setDelegate:self];
}

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return 60;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%d",indexPath.item];
    return cell;
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(PSTCollectionViewScrollPosition)scrollPosition{
    NSLog(@"%@",@"Here");
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (id)initWithTitle:(NSString *)title withRevealBlock:(PRevealBlock)revealBlock {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end