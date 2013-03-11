//
//  ST_Notify.m
//  SocialTango
//
//  Created by Mobile CoE User 2 on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ST_Notify.h"

@implementation ST_Notify
@synthesize nCreatedAt,nsubject,nnotificationId,nread;

-(id)init
{
	nCreatedAt=nil;
	nsubject =nil;
    nread =0;
    nnotificationId=0;
	return self;
	
}


@end
