//
//  CommentView.m
//  ST
//
//  Created by Devaraj NS on 23/02/13.
//  Copyright (c) 2013 Devaraj. All rights reserved.
//

#import "CommentView.h"
#import "ST_Comments.h"
#import "GSSystem.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "CSLinearLayoutView.h"
#import <QuartzCore/QuartzCore.h>
@interface  CommentView()
{
    ST_Comments* comment;
    UILabel *_author;
    UIImageView *_authorThumbView;
    UILabel *_descriptionLabel;
    UIImageView *_likeImageView;
    CGRect cgrcontent;
    CGRect cgrstatus;
    CGRect cgrimage;
    CGRect cgrtxt;
    GSSystem *GSMainSystem;
}
@end

@implementation CommentView

@synthesize verticalLayoutView,delegate;
@synthesize horizontalImageLayoutView,moreurl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    GSMainSystem = [[GSSystem alloc]init];
    [GSMainSystem createPoints:self :false];
    
    return  self;
}
- (void)setComment:(ST_Comments *)cmt :(BOOL) isPortrait
{
    comment = cmt;
    [self setLayout:isPortrait];
    [self setPostLayout];
    [self addLayoutComps];
    [self setPostEmpty];
    [self setPostValues];
}
- (void)setMore :(BOOL) isPortrait
{
    [self setLayout:isPortrait];
    [self setPostLayout];
    [self addLayoutComps];
    [self setPostEmpty];
    _descriptionLabel.text  = @"More";
}

- (void)setPostValues{
    _author.text   = comment.cauthor;
    _descriptionLabel.text  = [comment.ccommentMessage stringByAppendingString:[NSString stringWithFormat:@"%s %d %s", "   (", comment.likeCount, " likes)"]];
    [self addLinearItem : _descriptionLabel : horizontalImageLayoutView :CSLinearLayoutItemVerticalAlignmentTop];
    
    _likeImageView.image = [UIImage imageNamed:@"likeGreen"];
    NSString *unlike = comment.unlike;
    if ((NSNull *)unlike == [NSNull null]) { unlike=@""; }
    if(unlike.length>0){
        _likeImageView.image = [UIImage imageNamed:@"unlikeGreen"];
    }
    [self addLinearItem : _likeImageView : verticalLayoutView :CSLinearLayoutItemHorizontalAlignmentLeft];
    [_authorThumbView setImageWithURL:[NSURL URLWithString:comment.cauthorImageMediumUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (void) setLayout:(BOOL)isPortrait{
    if(isPortrait){
        cgrcontent = CGRectMake(0, 0, [GSMainSystem tenTwelfthsLeft],  [GSMainSystem twelveTwelfthsTop]);
        cgrstatus = CGRectMake([GSMainSystem twoTwelfthsLeft], 0, [GSMainSystem tenTwelfthsLeft], [GSMainSystem twelveTwelfthsTop]);
        cgrimage =CGRectMake(0, 0, [GSMainSystem twoTwelfthsLeft],  [GSMainSystem eightTwelfthsTop]);
        cgrtxt = CGRectMake(0, 0, [GSMainSystem tenTwelfthsLeft],  [GSMainSystem twelveTwelfthsTop]);
    }else{
        cgrcontent = CGRectMake(0, 0,  [GSMainSystem threeTwelfthsLeft], [GSMainSystem twelveTwelfthsTop]);
        cgrstatus = CGRectMake([GSMainSystem oneTwentyFourLeft], 0, [GSMainSystem oneTwelfthLeft], [GSMainSystem twelveTwelfthsTop]);
        cgrimage =CGRectMake(0, 0,[GSMainSystem oneTwentyFourLeft], [GSMainSystem sixTwelfthsTop]);
        cgrtxt = CGRectMake(0, 0, [GSMainSystem twelveTwelfthsLeft], [GSMainSystem sixTwelfthsTop]);
    }
    _authorThumbView.frame = cgrimage;
    verticalLayoutView.frame = cgrcontent;
    horizontalImageLayoutView.frame = cgrstatus;
    _descriptionLabel.frame = cgrtxt;
}
- (void) setPostLayout{
    verticalLayoutView = [[CSLinearLayoutView alloc] initWithFrame:cgrcontent];
    [self setPostFrameLayouts : verticalLayoutView :CSLinearLayoutViewOrientationVertical ];
    
    horizontalImageLayoutView =  [[CSLinearLayoutView alloc] initWithFrame:cgrstatus];
    [self setPostFrameLayouts : horizontalImageLayoutView :CSLinearLayoutViewOrientationVertical];
}

- (void) setPostFrameLayouts:(CSLinearLayoutView*)layout :(int)orientation{
    layout.orientation = orientation;
    layout.scrollEnabled = YES;
    layout.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:layout];
}

- (void) setPostEmpty{
    _author.text = nil;
    _descriptionLabel.text  = nil;
    _likeImageView.image=nil;
    _authorThumbView.image=nil;
}

- (void) addLayoutComps{
    CGFloat textHeight = 20;
    
    _authorThumbView = [[UIImageView alloc] initWithFrame:cgrimage];
    _authorThumbView.layer.masksToBounds = YES;
    _authorThumbView.layer.cornerRadius  = 15.0;
    _authorThumbView.contentMode = UIViewContentModeScaleAspectFit;
    [self addLinearItem : _authorThumbView : verticalLayoutView :CSLinearLayoutItemVerticalAlignmentTop];
    
    _likeImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textHeight, textHeight)];
    
    _author= [[UILabel alloc] initWithFrame:CGRectMake(0,0,[GSMainSystem oneTwelfthLeft], textHeight)];
    _author.font  = [UIFont systemFontOfSize:16.0];
    _author.backgroundColor = [UIColor clearColor];
    [self addLinearItem : _author : horizontalImageLayoutView :CSLinearLayoutItemVerticalAlignmentTop];
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:cgrtxt];
    _descriptionLabel.font              = [UIFont systemFontOfSize:14.0];
    _descriptionLabel.textColor         = [UIColor blackColor];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.backgroundColor   = [UIColor clearColor];
}

- (void)addLinearItem : (UIView*)view :(CSLinearLayoutView*)layout :(int)alignment{
    CSLinearLayoutItem *item = [CSLinearLayoutItem layoutItemForView:view];
    item.padding = CSLinearLayoutMakePadding(2.0, 2.0, 0.0, 2.0);
    view.userInteractionEnabled = YES;
    if(alignment==CSLinearLayoutItemHorizontalAlignmentCenter || alignment==CSLinearLayoutItemHorizontalAlignmentLeft ||
       alignment==CSLinearLayoutItemHorizontalAlignmentRight){
        item.padding = CSLinearLayoutMakePadding(2.0, 5.0, 0.0, 5.0);
        item.horizontalAlignment = alignment;
    }else{
        item.verticalAlignment = alignment;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapView:)];
    [view addGestureRecognizer:tap];
    [layout addItem:item];
}

- (void)handleTapView:(UITapGestureRecognizer*)recognizer {
    for(CSLinearLayoutItem *item in self.verticalLayoutView.items) {
        if(item.view == recognizer.view) {
            if(item.view == _likeImageView){
                _likeImageView.image = [UIImage imageNamed:@"likeGreen"];
                NSString *unlike = comment.unlike;
                if ((NSNull *)unlike == [NSNull null]) { unlike=@""; }
                if(unlike.length>0){
                    comment.likeCount = comment.likeCount-1;
                    [self.delegate cunlikeAction:comment.unlike];
                }else{
                    comment.likeCount = comment.likeCount+1;
                    [self.delegate clikeAction:comment.likeUrl];
                }
            }
        }
    }
}
@end