//
//  ST_ProfileList.m
//  SocialTango
//
//  Created by SathishK on 12/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ST_ProfileList.h"

@implementation ST_ProfileList
 
@synthesize fName;
@synthesize lName;
@synthesize gender;
@synthesize location;
@synthesize department;
@synthesize bio;
@synthesize imageUrl;
@synthesize profileId;
-(id)init
{
	fName = nil;
	lName = nil;
	gender = nil;
	location = nil;
	department = nil;
	bio = nil;
	imageUrl = nil;
	return self;
}

@end
