//
//  SettingViewController.m
//  Tango
//
//  Created by Devaraj NS on 12/03/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//

#import "SettingViewController.h"
#import "CSLinearLayoutView.h"
#import "ST_AspectList.h"
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
		self.navigationItem.rightBarButtonItem = [self logoutButton];
	}
	return self;
}

-(UIBarButtonItem*) logoutButton{
    UIButton* logoutButton = [UIButton buttonWithType:102];
    [logoutButton addTarget:self action:@selector(ButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    UIBarButtonItem* composeItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    return composeItem;
}

- (void)revealSidebar {
	_revealBlock();
}

-(void)setObject:(id)obj{
    NSLog(@"her asp %@",obj);
}
- (void)viewDidAppear:(BOOL)animated
{ 
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];    
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
