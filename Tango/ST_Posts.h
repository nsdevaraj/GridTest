//
//  ST_Notify.h
//  SocialTango
//
//  Created by Mobile CoE User 2 on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ST_Posts : NSObject
{
NSString *author;
NSString *PublishedAt;
BOOL isPublic;
NSString *authorUrl;
NSString *authorImageUrl;
NSString *type;
NSString *postId;
BOOL isReshare;
NSString *reshareId;
NSString *rauthor;
NSString *rauthorUrl;
NSString *rauthorImageUrl;
NSString *unlike;
NSString *commentUrl;
int likeCount;
int reshareCount;
int commentsCount;
NSString *likeUrl;
NSString *wallurl;
NSString *reshareUrl;
NSMutableArray *commentsArr;
    NSMutableArray *attachments;
    NSMutableArray *images;
NSMutableArray *oembed;
    NSString *deleteUrl;
NSString *rauthorImageMediumUrl;
NSString *rauthorImageSmallUrl;
NSString *authorImageMediumUrl;
NSString *authorImageSmallUrl;
NSString *allCommentsUrl;
}
@property(nonatomic,retain) NSString *allCommentsUrl;
@property(nonatomic,retain) NSString *deleteUrl;
@property(nonatomic,assign) int reshareCount;
@property(nonatomic,assign) int commentsCount;
@property(nonatomic,retain) NSString *author;
@property(nonatomic,retain) NSString *wallurl;
@property(nonatomic,retain) NSString *PublishedAt;
@property(nonatomic,assign)  BOOL isPublic;
@property(nonatomic,retain) NSString *authorUrl;
@property(nonatomic,retain) NSString *authorImageUrl;
@property(nonatomic,retain) NSString *type;
@property(nonatomic,retain) NSString *postId;
@property(nonatomic,assign)  BOOL isReshare;
@property(nonatomic,retain) NSString *reshareId;
@property(nonatomic,retain) NSString *rauthor;
@property(nonatomic,retain) NSString *rauthorUrl;
@property(nonatomic,retain) NSString *rauthorImageUrl;
@property(nonatomic,retain) NSMutableArray *commentsArr;
@property(nonatomic,retain) NSString *content;
@property(nonatomic,retain) NSString *unlike;
@property(nonatomic,retain) NSString *commentUrl;
@property(nonatomic,assign)  BOOL *deletable;
@property(nonatomic,assign) int likeCount;
@property(nonatomic,retain) NSString *likeUrl; 
@property(nonatomic,retain) NSString *reshareUrl;
@property(nonatomic,retain) NSMutableArray *attachments;
@property(nonatomic,retain) NSMutableArray *oembed;
@property(nonatomic,retain) NSMutableArray *images;

@property(nonatomic,retain) NSString *rauthorImageMediumUrl;
@property(nonatomic,retain) NSString *rauthorImageSmallUrl;
@property(nonatomic,retain) NSString *authorImageMediumUrl;
@property(nonatomic,retain) NSString *authorImageSmallUrl;
@end
