//
//  ST_AllFanPageList.m
//  SocialTango
//
//  Created by Cognizant Technologies on 11/9/11.
//

#import "ST_AllFanPageList.h"

@implementation ST_AllFanPageList
@synthesize logo;
@synthesize owner;
@synthesize ftitle;
@synthesize fanPageID;
@synthesize isMember;

-(id)init
{
	logo = nil;
	owner=nil;
	ftitle =nil;
	fanPageID=0;
	isMember=0;
	return self;
	
} 
@end
