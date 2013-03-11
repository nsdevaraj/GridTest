//
//  ST_MemberList.m
//  SocialTango
//
//  Created by SathishK on 12/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ST_MemberList.h"


@implementation ST_MemberList

@synthesize contactsId;
@synthesize memberName;
@synthesize memberImage;
@synthesize aspectID;
@synthesize requestId;
@synthesize profileId;

-(id)init
{
	contactsId = nil;
	memberName=nil;
	memberImage = nil;
	aspectID =0;
	requestId = 0;
	profileId= 0;
	return self;
}
 
@end
