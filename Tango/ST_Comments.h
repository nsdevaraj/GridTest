//
//  ST_Comments.h
//  SocialTango
//
//  Created by Cognizant Technologies on 10/14/11.
//

#import <Foundation/Foundation.h>
@interface ST_Comments : NSObject {
    
    NSString *cauthor;
    NSString *ccommentAt;
    NSString *cauthorImageUrl;
    NSString *cauthorUrl;
    NSString *likeUrl;
    NSString *unlike;
    int likeCount;
    NSString *ccommentMessage;
    NSString *ccommentID;
    NSString *deleteUrl;
    NSString *cauthorImageMediumUrl;
    NSString *cauthorImageSmallUrl;
}

@property(nonatomic,retain) NSString *cauthor;
@property(nonatomic,retain) NSString *ccommentAt;
@property(nonatomic,retain) NSString *cauthorImageUrl;
@property(nonatomic,retain) NSString *ccommentMessage;
@property(nonatomic,retain) NSString *cauthorUrl;
@property(nonatomic,retain) NSString *likeUrl;
@property(nonatomic,retain) NSString *thumbimage;
@property(nonatomic,retain) NSString *unlike;
@property(nonatomic,assign) int likeCount;
@property(nonatomic,retain) NSString *ccommentID;
@property(nonatomic,retain) NSString *deleteUrl;
@property(nonatomic,retain) NSString *cauthorImageMediumUrl;
@property(nonatomic,retain) NSString *cauthorImageSmallUrl;
@end
