
#import <Foundation/Foundation.h>
#import "ST_Pages.h"

@interface ST_Fanpages : ST_Pages
{
	NSString *description;
	BOOL isPublic;
	int membersCount;
	NSString *owner;
	NSString *ownerId;
	NSString *ownerUrl;
    NSString *ownerImageUrl;
    NSMutableArray *people;
}

@property(nonatomic,retain) NSString *description;
@property(nonatomic,assign) BOOL isPublic;
@property(nonatomic,assign) int membersCount;
@property(nonatomic,retain) NSString *owner;
@property(nonatomic,retain) NSString *ownerId;
@property(nonatomic,retain) NSString *ownerUrl;
@property(nonatomic,retain) NSString *ownerImageUrl;
@property(nonatomic,retain) NSMutableArray *people;

@end
