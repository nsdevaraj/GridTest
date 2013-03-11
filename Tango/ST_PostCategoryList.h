//
//  ST_PostCategoryList.h
//  SocialTango
//
//  Created by Cognizant Technologies on 9/21/11.
//

#import <Foundation/Foundation.h>

@interface ST_PostCategoryList : NSObject 
{
    NSString *author;
	NSString *createdAt;
	NSString *imageUrl;
    NSString *postMessage;
	UIImage *userImage;
	int noOfComments;
	
	int postID;
	NSArray *postAspectIDs;
	NSMutableArray *photoUrl;
	NSMutableArray *comments;  
	int deletable;
    BOOL isPopOverVisible;
    NSString *post_like_href;
    int noOfLikes;
}

@property(nonatomic,retain) NSString *author;
@property(nonatomic,retain) NSString *createdAt;
@property(nonatomic,retain) NSString *imageUrl;
@property(nonatomic,retain) NSString *postMessage;
@property(nonatomic, retain) UIImage *userImage;
@property(nonatomic,assign) int postID;
@property(nonatomic, retain) NSArray *postAspectIDs;
@property(nonatomic, retain) NSMutableArray *photoUrl;
@property(nonatomic, retain) NSMutableArray *comments;
@property(nonatomic, assign) int noOfComments;
@property(nonatomic, assign) int deletable;
@property(nonatomic, assign)  BOOL isPopOverVisible;
@property(nonatomic,retain) NSString *post_like_href;
@property(nonatomic,assign) int noOfLikes;

@end
