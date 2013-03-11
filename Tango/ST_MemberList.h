//
//  ST_MemberList.h
//  SocialTango
//
//  Created by SathishK on 12/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ST_MemberList : NSObject 
{
	NSString *contactsId;
	NSString *memberName;
	NSString *memberImage;
	int aspectID;
	int requestId;
	int profileId;
}

@property(nonatomic,retain) NSString *contactsId;
@property(nonatomic,retain) NSString *memberName;
@property(nonatomic,retain) NSString *memberImage;
@property(nonatomic,assign) int aspectID;
@property(nonatomic,assign) int requestId;
@property(nonatomic,assign) int profileId;
@end
