#import <Foundation/Foundation.h>

@interface ST_Notifications : NSObject
{
        NSString *id;
        NSString *verb;
        BOOL isRead;
        NSString *oAuthorDisplayName;
        NSString *markReadUrl;
	NSString *oUrl;
        NSString *oType;
	NSString *oId;
	NSString *oAuthorUrl;
        NSString *oAuthorId;
	NSMutableArray *actors;
	
}

@property(nonatomic,retain) NSString *id;
@property(nonatomic,retain) NSString *verb;
@property(nonatomic,assign) BOOL isRead;
@property(nonatomic,retain) NSString *oAuthorDisplayName;
@property(nonatomic,retain) NSString *markReadUrl;
@property(nonatomic,retain) NSString *oUrl;
@property(nonatomic,retain) NSString *oType;
@property(nonatomic,retain) NSString *oId;
@property(nonatomic,retain) NSString *oAuthorUrl;
@property(nonatomic,retain) NSString *oAuthorId;
@property(nonatomic,retain) NSMutableArray *actors;
@end
