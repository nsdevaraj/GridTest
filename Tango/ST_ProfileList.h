//
//  ST_ProfileList.h
//  SocialTango
//
//  Created by SathishK on 12/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
 

@interface ST_ProfileList : NSObject 
{
	NSString *fName;
	NSString *lName;
	NSString *gender;
	NSString *location;
	NSString *department;
	NSString *bio;
	NSString *imageUrl;
	int profileId;
 }

@property(nonatomic,retain) NSString *fName;
@property(nonatomic,retain) NSString *lName;
@property(nonatomic,retain) NSString *gender;
@property(nonatomic,retain) NSString *location;
@property(nonatomic,retain) NSString *bio;
@property(nonatomic,retain)NSString *department;
@property(nonatomic,retain)NSString *imageUrl;
@property(nonatomic,assign) int profileId;
 
@end
