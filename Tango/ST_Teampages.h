#import <Foundation/Foundation.h>
#import "ST_Pages.h"
@interface ST_Teampages : ST_Pages
{ 
	NSString *bannerImage;
	NSString *bannerLink;
    NSMutableArray *people;
}
 
@property(nonatomic,retain) NSString *bannerImage;
@property(nonatomic,retain) NSString *bannerLink; 
@property(nonatomic,retain) NSMutableArray *people;
@end
