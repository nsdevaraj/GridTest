#import <Foundation/Foundation.h>

@interface ST_People : NSObject
{
NSString *aboutMe;
NSString *thumbnailurl;
NSString *birthday;
NSString *department;
NSString *gender;
NSString *location;
NSString *id;
BOOL connected;
NSString *displayName;
NSString *emails;
NSString *profileUrl;
NSString *tags;
NSString *name;
}

@property(nonatomic,retain) NSString *aboutMe;
@property(nonatomic,retain) NSString *thumbnailurl;
@property(nonatomic,retain) NSString *birthday;
@property(nonatomic,retain) NSString *department;
@property(nonatomic,retain) NSString *gender;
@property(nonatomic,retain) NSString *location;
@property(nonatomic,retain) NSString *id;
@property(nonatomic,assign) BOOL connected;
@property(nonatomic,retain) NSString *displayName;
@property(nonatomic,retain) NSString *emails;
@property(nonatomic,retain) NSString *profileUrl;
@property(nonatomic,retain) NSString *tags;
@property(nonatomic,retain) NSString *name;
@end
