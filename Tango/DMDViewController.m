//
//  DMDViewController.m
//  DMLazyScrollViewExample
//
//  Created by Devaraj NS on 13/03/13.
//  Copyright (c) 2013 daniele. All rights reserved.
//

#import "DMDViewController.h"

@interface DMDViewController ()
{
 UILabel* label;   
}
@end

#define ARC4RANDOM_MAX	0x100000000
@implementation DMDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed: (CGFloat)arc4random()/ARC4RANDOM_MAX
                                                     green: (CGFloat)arc4random()/ARC4RANDOM_MAX
                                                      blue: (CGFloat)arc4random()/ARC4RANDOM_MAX
                                                     alpha: 1.0f];
        label= [[UILabel alloc] initWithFrame:self.view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithFormat:@"index"];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:50];
        [self.view addSubview:label];

        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad]; 
}

-(void) setTitle:(NSString*)title{
    label.text = title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
