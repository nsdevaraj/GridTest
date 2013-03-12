//
//  AppDelegate.h
//  Tango
//
//  Created by Devaraj NS on 08/03/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "RestAPI.h"
#import "HJObjManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    NSMutableArray *myPosts;
}
+(BOOL) deviceIsPhone;
+(BOOL) orientationIsLandscape;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) RestAPI *rest;
@property (nonatomic, strong) NSMutableArray *myPosts; 
@property (nonatomic, strong) NSString *curPgId;
@property (nonatomic, strong) MenuViewController *menuController;
@property (nonatomic, retain) HJObjManager *imgMan;
@end
 