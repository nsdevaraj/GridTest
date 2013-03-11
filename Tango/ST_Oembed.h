//
//  ST_Notify.h
//  SocialTango
//
//  Created by Mobile CoE User 2 on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ST_Oembed : NSObject
{
NSString *Url;
NSString *ProviderUrl;
NSString *ProviderName;
NSString *title;
NSString *description;
NSString *imageUrl;
int *imageWidth;
int *imageHeight;
}
@property(nonatomic,retain) NSString *Url;
@property(nonatomic,retain) NSString *ProviderUrl;
@property(nonatomic,retain) NSString *ProviderName;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *description;
@property(nonatomic,retain) NSString *imageUrl;
@property(nonatomic,assign) int *imageWidth;
@property(nonatomic,assign) int *imageHeight;
 
@end
