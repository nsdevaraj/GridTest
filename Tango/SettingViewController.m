//
//  SettingViewController.m
//  Tango
//
//  Created by Devaraj NS on 12/03/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//

#import "SettingViewController.h"
#import "CSLinearLayoutView.h"
#define STAccountNumberKey		@"accountNumber"
#define STPinNumberKey			@"AccessTokenKey"
@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize largeButton,linearLayoutView,appDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTitle:(NSString *)title withRevealBlock:(SRevealBlock)revealBlock {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.linearLayoutView = [[CSLinearLayoutView alloc] initWithFrame:self.view.frame];
    linearLayoutView.orientation = CSLinearLayoutViewOrientationVertical;
    linearLayoutView.scrollEnabled = YES;
    linearLayoutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    linearLayoutView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:linearLayoutView];
    
    largeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect cframe =CGRectMake(200, 0, 270, 73);
    [largeButton setFrame:cframe];
    [largeButton setImage:[UIImage imageNamed:@"LoginButton_Nor"] forState:UIControlStateNormal];
    [largeButton setImage:[UIImage imageNamed:@"LoginButton_Hov"] forState:UIControlStateSelected];
    [largeButton addTarget:self action:@selector(ButtonReleased:) forControlEvents:UIControlEventTouchUpInside];

    CSLinearLayoutItem *logout = [self newItem:largeButton];
    [linearLayoutView addItem:logout];
}


- (IBAction) ButtonReleased:(id)sender {
    appDelegate.rest.authorization = nil;
    appDelegate.rest.currentuserid = nil;
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.rest.authorization forKey:STPinNumberKey];
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.rest.currentuserid forKey:STAccountNumberKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [appDelegate.menuController relogin];
}

- (CSLinearLayoutItem *)newItem :(id)view{
    CSLinearLayoutItem *item = [CSLinearLayoutItem layoutItemForView:view];
    item.padding = CSLinearLayoutMakePadding(10.0, 20.0, 10.0, 20.0);
    item.horizontalAlignment = CSLinearLayoutItemHorizontalAlignmentCenter;
    return item;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
