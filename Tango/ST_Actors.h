#import <Foundation/Foundation.h>

@interface ST_Actors : NSObject
{
        NSString *id;
        NSString *displayName;
        NSString *url;
}

@property(nonatomic,retain) NSString *id;
@property(nonatomic,retain) NSString *displayName;
@property(nonatomic,retain) NSString *url;
@end

