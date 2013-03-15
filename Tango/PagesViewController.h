//
//  PagesViewController.h
//  Tango
//
//  Created by Devaraj NS on 12/03/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionView.h"
#import "DMViewController.h"
#import "AppDelegate.h"
typedef void (^PRevealBlock)();

@interface PagesViewController : PSUICollectionViewController<PSTCollectionViewDelegate>{
@private
	PRevealBlock _revealBlock;
}
- (id)setWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title withRevealBlock:(PRevealBlock)revealBlock;

@property (nonatomic, strong) AppDelegate *appDelegate;
@property(nonatomic,retain) DMViewController *vc;
@end
