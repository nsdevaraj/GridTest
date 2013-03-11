//
//  ST_Notify.h
//  SocialTango
//
//  Created by Mobile CoE User 2 on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ST_Notify : NSObject
{
NSString *nCreatedAt;
NSString *nsubject;
//NSString *msg_show_link;
 int  nnotificationId;
    int nread;
}

@property(nonatomic,retain) NSString *nCreatedAt;
@property(nonatomic,retain) NSString *nsubject;
@property(nonatomic,assign) int  nnotificationId;
@property(nonatomic,assign) int nread;
@end
