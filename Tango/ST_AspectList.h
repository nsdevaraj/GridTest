//
//  ST_AspectList.h
//  SocialTango
//
//  Created by Cognizant Technologies on 9/23/11.
//

#import <Foundation/Foundation.h>

@interface ST_AspectList : NSObject 
{
	NSString *groupName;
	NSString *aspectID;
        NSMutableArray *people;   
}

@property(nonatomic,retain) NSString *groupName;
@property(nonatomic,retain) NSString *aspectID;
@property(nonatomic,retain) NSMutableArray *people;
@end
