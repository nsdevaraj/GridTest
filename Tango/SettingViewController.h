//
//  SettingViewController.h
//  Tango
//
//  Created by Devaraj NS on 12/03/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class CSLinearLayoutView;
typedef void (^SRevealBlock)();

@interface SettingViewController : UIViewController{
@private
	SRevealBlock _revealBlock;
}

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) UIButton *largeButton;
@property (nonatomic, retain) CSLinearLayoutView *linearLayoutView;
- (id)initWithTitle:(NSString *)title withRevealBlock:(SRevealBlock)revealBlock;

@end
