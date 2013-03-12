//
//  PagesViewController.h
//  Tango
//
//  Created by Devaraj NS on 12/03/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionView.h"
typedef void (^PRevealBlock)();

@interface PagesViewController : PSUICollectionViewController<PSTCollectionViewDelegate>{
@private
	PRevealBlock _revealBlock;
}

- (id)initWithTitle:(NSString *)title withRevealBlock:(PRevealBlock)revealBlock;
@end
