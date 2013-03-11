//
//  ST_Pages.h
//  SocialTango
//
//  Created by Devaraj NS on 18/02/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ST_Pages : NSObject
{
    NSString *pgid;
    NSString *title;
    NSString *logo;
}

@property(nonatomic,retain) NSString *pgid;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *logo;
@end
