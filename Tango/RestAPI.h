//
//  RestAPI.h
//  Test6
//
//  Created by Devaraj NS on 13/02/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ST_People.h"
#import "ST_Comments.h"
#import "ST_Posts.h"
@interface RestAPI : NSObject{
    NSString *urlval;
    NSString *appkey;
    NSString *authorization;
    NSString *currentuserid;
    ST_People *currentperson;
    NSMutableArray *myPosts;
}

@property (strong, retain) NSMutableArray *myPosts;
@property (strong, retain) NSMutableArray *pageArr;
@property (strong, retain) NSMutableArray *aspectArr;
@property (strong, retain) NSMutableArray *tagArr;
@property (strong, retain) NSMutableArray *notifyArr;
@property (strong, retain) NSMutableArray *contactArr;
@property (strong, retain) NSString *urlval;
@property (strong, retain) ST_People *currentperson;
@property (strong, retain) NSString *currentuserid;
@property (strong, retain) NSString *appkey;
@property (strong, retain) NSString *authorization;

- (void) login :  (NSString *)  userid :  (NSString *) pwd;
- (NSMutableArray*) getComments: (NSString *) url;
- (void) createGroup:(NSString *) groupname;
- (NSMutableArray*) getallGroups;
- (void) getGroup:(NSString *) groupid;
- (void) updateGroup:(NSString *) groupid :(NSString *) groupname;
- (void) deleteGroup:(NSString *) groupid;
- (ST_People*) getUserProfile:(NSString *) userid;
- (NSMutableArray*) getStreams;
- (void) getTeampage:(NSString *) spaceid;
- (NSMutableArray*) getPagePosts:(NSString*)space_id;
- (NSMutableArray*) getallPages;
- (NSMutableArray*) getallContacts;
- (NSMutableArray*) getallTags;
- (NSMutableArray*) search:(NSString *) searchText;
- (NSMutableArray*) paginatedPosts: (NSString *) url;
- (NSMutableArray*) getUserPosts:(NSString *) userid;
- (NSMutableArray*) getNotifications;
- (void) createLike: (NSString *) url;
- (void) unLike: (NSString *) url;
- (void) createReshare: (NSString *) url;
- (ST_Comments*) createComment: (NSString *) postId : (NSString *) text;
- (ST_Posts *) createPost: (NSString *) message : (NSString *) link;
- (ST_Posts *) createPagePost: (NSString *) message : (NSString *) link : (NSString *) pageId;
@end
