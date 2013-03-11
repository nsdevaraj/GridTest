//
//  ST_Messages.h
//  SocialTango
//
//  Created by Cognizant Technologies 11/30/11.
//

#import <Foundation/Foundation.h>


@interface ST_Messages : NSObject {
	
	//****** for ST_MessageViewController**********//
	NSString *mauthor;
	NSString *mCreatedAt;
 	int no_of_conversations;
	NSString *msubject;
	NSString *mImageUrl;
	NSString *msg_show_link;
	
	//********* for ST_MsgDetailViewController**********//
	NSString *message;
	NSString *msg_reply_link;
	
    //***********for ST_contactVIewController**********//
	int contactID;
	
}
@property(nonatomic,retain) NSString *mauthor;
@property(nonatomic,retain) NSString *mCreatedAt;
@property(nonatomic,retain) NSString *msubject;
@property(nonatomic,retain) NSString *mImageUrl;
@property(nonatomic,assign) int no_of_conversations;

@property(nonatomic,retain) NSString *msg_show_link;
@property(nonatomic,retain) NSString *msg_reply_link;
@property(nonatomic,retain) NSString *message;
@property(nonatomic,assign) int contactID;


@end
