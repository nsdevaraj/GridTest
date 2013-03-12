#import "Cell.h"
#import <QuartzCore/QuartzCore.h>
@implementation Cell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height*2/3)];
		self.imgView.layer.masksToBounds = YES;
        self.imgView.layer.cornerRadius  = 15.0;
        self.imgView.image = [UIImage imageNamed:@"user.png"];
		self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, frame.size.height*2/3, frame.size.width, frame.size.height/3)];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.label.textAlignment = UITextAlignmentCenter;
        self.label.font = [UIFont boldSystemFontOfSize:50.0];
        self.contentView.backgroundColor = [UIColor underPageBackgroundColor];
        self.label.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.label];        
        [self.contentView addSubview:self.imgView];
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

@end
