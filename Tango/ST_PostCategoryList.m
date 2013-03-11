//
//  ST_PostCategoryList.m
//  SocialTango
//
//  Created by Cognizant Technologies on 9/21/11.
//

#import "ST_PostCategoryList.h"

@implementation ST_PostCategoryList

@synthesize author;
@synthesize createdAt;
@synthesize postMessage;
@synthesize imageUrl;
@synthesize userImage;
@synthesize postID;
@synthesize postAspectIDs;
@synthesize photoUrl;
@synthesize comments;
@synthesize noOfComments;
@synthesize deletable;
@synthesize isPopOverVisible;
@synthesize  post_like_href;
@synthesize  noOfLikes;
-(id)init
{
    isPopOverVisible= FALSE;
	userImage = nil;
	author =nil;
	createdAt = nil;
	postMessage = nil;
	noOfComments = 0;
    post_like_href= nil;
	postID = 0;
	deletable=0;
    noOfLikes =0;
	return self;
}

@end
