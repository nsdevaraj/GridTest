//
//  ST_Messages.m
//  SocialTango
//
//  Created by Cognizant Technologies 11/30/11.
//

#import "ST_Messages.h"


@implementation ST_Messages
@synthesize mauthor;
@synthesize mCreatedAt;
@synthesize no_of_conversations;
@synthesize msubject;
@synthesize mImageUrl;
@synthesize msg_show_link;
@synthesize message;
@synthesize msg_reply_link;
@synthesize contactID;
-(id)init
{
	mauthor = nil;
	mCreatedAt=nil;
	msubject =nil;
	no_of_conversations=0;
	mImageUrl=nil;
	msg_show_link=nil;
	message =nil;
	msg_reply_link=nil;
	contactID =0;
	return self;
	
}

@end
