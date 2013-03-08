#import <Foundation/Foundation.h>

@interface MGScrollView : UIScrollView

@property (nonatomic, retain) NSMutableArray *boxes;

- (void)drawBoxesWithSpeed:(NSTimeInterval)speed;
- (void)updateContentSize;
- (void)snapToNearestBox;

@end
