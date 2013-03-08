//
//  FullViewController.h
//  GHSidebarNav
//
//  Created by Greg Haines on 11/29/11.
//

#import <Foundation/Foundation.h>

@class MGBox;
@interface FullViewController : UIViewController <UIScrollViewDelegate>{
} 
- (id)initWithTitle:(NSString *)title;

- (void)addBox:(UIButton *)sender;
- (void)removeBox:(UIButton *)sender;
- (void)moveUp:(UIButton *)sender;
- (void)moveDown:(UIButton *)sender;
- (void)shuffle;

- (MGBox *)parentBoxOf:(UIView *)view;
- (UIButton *)button:(NSString *)title for:(SEL)selector;

@end