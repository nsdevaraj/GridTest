//
//  ST_AllFanPageList.h
//  SocialTango
//
//  Created by Cognizant Technologies on 11/9/11.
//

#import <Foundation/Foundation.h>

@interface ST_AllFanPageList : NSObject {
	
	NSString *logo;
	NSString *owner;
	NSString  *ftitle;
	int fanPageID;
	int isMember;
	
}

@property(nonatomic,retain) NSString *logo;
@property(nonatomic,retain) NSString *owner;
@property(nonatomic,retain) NSString *ftitle;
@property(nonatomic,assign) int fanPageID;
@property(nonatomic,assign) int isMember;

@end
