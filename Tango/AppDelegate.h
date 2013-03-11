//
//  AppDelegate.h
//  Tango
//
//  Created by Devaraj NS on 08/03/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
+(BOOL) deviceIsPhone;
+(BOOL) orientationIsLandscape;
@property (strong, nonatomic) UIWindow *window;
@end
