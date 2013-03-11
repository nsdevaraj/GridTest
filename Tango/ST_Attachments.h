//
//  ST_Notify.h
//  SocialTango
//
//  Created by Mobile CoE User 2 on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ST_Attachments : NSObject
{
	NSString *Url;
	NSString *type;
    NSString *mediumUrl;
    NSString *smallUrl;
}
@property(nonatomic,retain) NSString *Url;
@property(nonatomic,retain) NSString *type;
@property(nonatomic,retain) NSString *mediumUrl;
@property(nonatomic,retain) NSString *smallUrl;
@end
