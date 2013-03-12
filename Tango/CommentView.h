//
//  CommentView.h
//  ST
//
//  Created by Devaraj NS on 23/02/13.
//  Copyright (c) 2013 Devaraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ST_Comments.h"
#import "PostFullView.h"
@class CSLinearLayoutView;
@interface CommentView : UIView

@property (nonatomic, retain) CSLinearLayoutView *verticalLayoutView;
@property (nonatomic, retain) CSLinearLayoutView *horizontalImageLayoutView;
- (void)setComment:(ST_Comments *)cmt :(BOOL) isPortrait;
- (void) setLayout:(BOOL)isPortrait;
- (void)setMore :(BOOL) isPortrait;
@property (nonatomic, retain) PostFullView *delegate;
@property (nonatomic, retain) NSString *moreurl;
@end
