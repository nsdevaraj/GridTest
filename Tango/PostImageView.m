//
//  PostImageView.m
//  ST
//
//  Created by Devaraj on 24/02/13.
//  Copyright (c) 2013 Devaraj. All rights reserved.
//

#import "PostImageView.h"
 
#import <QuartzCore/QuartzCore.h>
@implementation PostImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius  = 20.0;
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)setEmpty
{
    self.image=nil;
}

- (void)setImageURL: (NSString*)url
{
   // [self setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Image_Holder"]];
}
@end
