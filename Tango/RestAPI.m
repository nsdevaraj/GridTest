//
//  RestAPI.m
//  Test6
//
//  Created by Devaraj NS on 13/02/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//
#import "RestAPI.h"
#import "ST_Posts.h"
#import "ST_Comments.h"
#import "ST_Attachments.h"
#import "ST_Oembed.h"
#import "ST_AspectList.h"
#import "ST_Fanpages.h"
#import "ST_Teampages.h"
#import "ST_Notifications.h"
#import "ST_People.h"
#import "ST_Actors.h"
#import "ST_Tags.h"
#define GETMETHOD @"GET"
#define POSTMETHOD @"POST"
#define PUTMETHOD @"PUT"
#define DELMETHOD @"DELETE"
@implementation RestAPI

@synthesize myPosts;
@synthesize urlval;
@synthesize appkey;
@synthesize authorization;
@synthesize currentuserid;
@synthesize currentperson;
@synthesize pageArr,aspectArr,tagArr,contactArr,notifyArr;
- (id) jsonResponse:(NSString *) myServerUrl :(NSString *) postString :(NSString *) type{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[myServerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300.0];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    [theRequest setHTTPMethod: [NSString stringWithFormat:@"%@", type] ];
    [theRequest addValue:appkey forHTTPHeaderField:@"AppKey"];
    [theRequest addValue:@"awcoest" forHTTPHeaderField:@"AppSecret"];
    if (![authorization isEqual: @""]){
        [theRequest addValue:authorization forHTTPHeaderField:@"Authorization"];
    }
    if ( [type isEqual: @"POST"] || [type isEqual: @"PUT"]){
        [theRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSData *response = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&urlResponse error:&requestError];
    if (response == nil) {
        NSLog(@"Error %@",myServerUrl);
        [self noNetworkAlert];
        return nil;
    }
    else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    }
}
- (void) login:(NSString *) userid :  (NSString *) pwd{
    currentuserid = userid;
    NSString *type = POSTMETHOD;
    NSString *myServerUrl =  [urlval stringByAppendingString:@"/api/v2/sessions"];
    NSString *postString = [[[@"username=" stringByAppendingString:userid] stringByAppendingString:@"&password="] stringByAppendingString:pwd];
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    if(obj != nil){
        NSDictionary *loginDict = obj;
        authorization = [loginDict objectForKey:@"token"];
    }else{
        authorization = @"no network";
    }
}

- (NSMutableArray*) getComments: (NSString *) url {
    NSString *type = GETMETHOD;
    NSString *myServerUrl = url;
    NSString *postString = @"";
    NSMutableArray *comments;
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    if(obj != nil){
        NSDictionary *groupsDict =obj;
        NSMutableArray *arr = [groupsDict objectForKey:@"comments"];
        comments= [[NSMutableArray alloc]init];
        for (int i=0; i<[arr count]; i++ ){
            [comments addObject:[self getComment: [arr objectAtIndex:i]]];
        }
    }
    return comments;
}

-(void) noNetworkAlert{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Social Tango" message:@"Network Not Available"   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

//Comments and Post, type = comments or posts
- (void) createLike: (NSString *) url{
    NSString *type = POSTMETHOD;
    NSString *myServerUrl = url;
    NSString *postString = @"";
    [self jsonResponse :myServerUrl :postString :type ];
}

- (void) unLike: (NSString *) url{
    NSString *type = DELMETHOD;
    NSString *myServerUrl = url;
    NSString *postString = @"";
    [self jsonResponse :myServerUrl :postString :type ];
}

- (void) createReshare: (NSString *) url{
    NSString *type = POSTMETHOD;
    NSString *myServerUrl = url;
    NSString *postString = @"";
    [self jsonResponse :myServerUrl :postString :type ];
}

- (ST_Comments*) createComment: (NSString *) postId : (NSString *) text{
    NSString *type = POSTMETHOD;
    NSString *myServerUrl = [urlval stringByAppendingString:@"/api/v2/comments"];
    NSString *postString = [[[@"text=" stringByAppendingString:text] stringByAppendingString:@"&post_id="] stringByAppendingString:[NSString stringWithFormat:@"%@",postId]];
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    NSDictionary *myDict;
    if(obj != nil){
        myDict = obj;
    }
    return [self getComment: myDict];
}

- (void) deleteComment: (NSString *) url {
    NSString *type = DELMETHOD;
    NSString *myServerUrl = url;
    NSString *postString = @"";
    [self jsonResponse :myServerUrl :postString :type ];
}

- (NSMutableArray*) getallFanpages{
    NSString *type = GETMETHOD;
    NSString *myServerUrl = [[urlval stringByAppendingString:@"/api/v2/spaces/"] stringByAppendingString:currentuserid] ;
    NSString *postString = @"";
    NSMutableArray *fanpages;
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    if(obj != nil){
        NSDictionary *groupsDict =obj;
        NSMutableArray *arr = [[groupsDict objectForKey:@"result"]  objectForKey:@"entry"];
        fanpages= [[NSMutableArray alloc]init];
        for (int i=0; i<[arr count]; i++ ){
            ST_Fanpages *fanpage =[[ST_Fanpages alloc] init];
            fanpage.pgid = (NSString*)[[arr objectAtIndex:i] objectForKey:@"id"];
            fanpage.title= [[arr objectAtIndex:i] objectForKey:@"title"];
            fanpage.description= [[arr objectAtIndex:i] objectForKey:@"description"];
            fanpage.isPublic = ([[arr objectAtIndex:i] objectForKey:@"public"]) ? true : false;
            fanpage.membersCount= ((int )[[[arr objectAtIndex:i] objectForKey:@"members_count"] intValue]);
            fanpage.owner= [[[arr objectAtIndex:i] objectForKey:@"owner"] objectForKey:@"displayName"];
            fanpage.ownerId= [[[arr objectAtIndex:i] objectForKey:@"owner"] objectForKey:@"id"];
            fanpage.ownerUrl= [[[arr objectAtIndex:i] objectForKey:@"owner"] objectForKey:@"url"];
            fanpage.ownerImageUrl= [[[[arr objectAtIndex:i] objectForKey:@"owner"] objectForKey:@"image"] objectForKey:@"url"];
            fanpage.logo= [[arr objectAtIndex:i] objectForKey:@"logo"];
            [fanpages addObject:fanpage];
        }
    }
    return fanpages;
}

- (NSMutableArray*) getallPages{
    NSMutableArray *fapages = [self getallFanpages];
    NSMutableArray *tempages = [self getallTeampages];
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    for(ST_Pages *page in tempages){
        [pages addObject:page];
    }
    for(ST_Pages *page in fapages){
        [pages addObject:page];
    }
    return pages;
}

- (NSMutableArray*) getallGroups{
    NSString *type = GETMETHOD;
    NSString *myServerUrl = [[urlval stringByAppendingString:@"/api/v2/groups/"]stringByAppendingString:currentuserid] ;
    NSString *postString = @"";
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    
    NSMutableArray *aspects = [[NSMutableArray alloc] init];
    if(obj != nil){
        NSDictionary *groupsDict =obj;
        NSMutableArray *arr = [[groupsDict objectForKey:@"result"]  objectForKey:@"entry"];
        for (int i=0; i<[arr count]; i++ ){
            ST_AspectList *aspect =[[ST_AspectList alloc] init];
            aspect.groupName = [[arr objectAtIndex:i] objectForKey:@"title"];
            aspect.aspectID = [[arr objectAtIndex:i] objectForKey:@"id"];
            [aspects addObject:aspect];
        }
    }
    return aspects;
}

- (NSMutableArray*) getallTags{
    NSString *type = GETMETHOD;
    NSString *myServerUrl = [[urlval stringByAppendingString:@"/api/v2/tag_followings/"]  stringByAppendingString:currentuserid];
    NSString *postString = @"";
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    NSMutableArray *tags;
    if(obj != nil){
        NSDictionary *myDicts = obj;
        tags = [[NSMutableArray alloc]init];
        NSMutableArray *arr = [myDicts objectForKey:@"followed_tags"] ;
        for (int i=0; i<[arr count]; i++ ){
            ST_Tags *tag =[[ST_Tags alloc] init];
            tag.id = [[arr objectAtIndex:i] objectForKey:@"id"];
            tag.name= [[arr objectAtIndex:i] objectForKey:@"name"];
            [tags addObject:tag];
        }
    }
    return tags;
}


- (void) getFanpage:(NSString *) spaceid{
    NSString *type = GETMETHOD;
    NSString *myServerUrl = [[[[urlval stringByAppendingString:@"/api/v2/spaces/"] stringByAppendingString:currentuserid] stringByAppendingString:@"/"] stringByAppendingString:spaceid];
    NSString *postString = @"";
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    if(obj != nil){
        
        NSDictionary *groupsDict = obj;
        if ( groupsDict != nil){
            ST_Fanpages *fanpage =[[ST_Fanpages alloc] init];
            fanpage.pgid = (NSString*)[groupsDict objectForKey:@"id"];
            fanpage.title= [groupsDict objectForKey:@"title"];
            fanpage.description= [groupsDict objectForKey:@"description"];
            fanpage.isPublic = ([groupsDict objectForKey:@"public"]) ? true : false;
            fanpage.membersCount= (int )[[groupsDict objectForKey:@"members_count"] intValue];
            fanpage.owner= [[groupsDict objectForKey:@"owner"] objectForKey:@"displayName"];
            fanpage.ownerId= [[groupsDict objectForKey:@"owner"] objectForKey:@"id"];
            fanpage.ownerUrl= [[groupsDict objectForKey:@"owner"] objectForKey:@"url"];
            fanpage.ownerImageUrl= [[[groupsDict objectForKey:@"owner"] objectForKey:@"image"] objectForKey:@"url"];
            fanpage.logo= [groupsDict objectForKey:@"logo"];
            NSString *myPeopleServerUrl = [[[[[urlval stringByAppendingString:@"/api/v2/people/"] stringByAppendingString:currentuserid] stringByAppendingString:@"/"] stringByAppendingString:spaceid] stringByAppendingString:@"?group_type=fanpage"];
            NSDictionary *peopleDict = [self jsonResponse :myPeopleServerUrl :postString :type ];
            NSMutableArray *arr = [[peopleDict objectForKey:@"result"]  objectForKey:@"entry"];
            fanpage.people = [[NSMutableArray alloc] init];
            for (int i=0; i<[arr count]; i++ ){
                ST_People *person =[[ST_People alloc] init];
                person.aboutMe = [[arr objectAtIndex:i] objectForKey:@"aboutMe"];
                person.thumbnailurl= [[arr objectAtIndex:i] objectForKey:@"thumbnailurl"];
                person.birthday= [[arr objectAtIndex:i] objectForKey:@"birthday"];
                person.department= [[arr objectAtIndex:i] objectForKey:@"department"];
                person.gender= [[arr objectAtIndex:i] objectForKey:@"gender"];
                person.location= [[arr objectAtIndex:i] objectForKey:@"location"];
                person.id= [[arr objectAtIndex:i] objectForKey:@"id"];
                person.connected= ([[arr objectAtIndex:i] objectForKey:@"read"]) ? true : false;
                person.displayName = [[arr objectAtIndex:i] objectForKey:@"displayName"];
                person.emails = [[arr objectAtIndex:i] objectForKey:@"emails"];
                person.name = [[arr objectAtIndex:i] objectForKey:@"name"];
                person.profileUrl = [[arr objectAtIndex:i] objectForKey:@"profileUrl"];
                person.tags = [[arr objectAtIndex:i] objectForKey:@"tags"];
                [fanpage.people addObject:person];
            }
        }
    }
}

- (void) createFanpage : (NSString *) title :  (NSString *) desc : (NSString *) pub {
    NSString *type = POSTMETHOD;
    NSString *myServerUrl = [[urlval stringByAppendingString:@"/api/v2/groups/"]stringByAppendingString:currentuserid];
    NSString *postString = [[[[[@"title=" stringByAppendingString:title]  stringByAppendingString:@"&description=" ] stringByAppendingString:desc] stringByAppendingString:@"&public="] stringByAppendingString:pub];
    [self jsonResponse :myServerUrl :postString :type ];
}

- (void) deleteFanpage:(NSString *) spaceid{
    NSString *type = DELMETHOD;
    NSString *myServerUrl = [[[[urlval stringByAppendingString:@"/api/v2/spaces/"] stringByAppendingString:currentuserid] stringByAppendingString:@"/"] stringByAppendingString:spaceid];
    NSString *postString = @"";
    [self jsonResponse :myServerUrl :postString :type ];
}

- (void) updateSpace:(NSString *) title :  (NSString *) desc : (NSString *) pub : (NSString *) spaceid{
    NSString *type = PUTMETHOD;
    NSString *myServerUrl = [[[[urlval stringByAppendingString:@"/api/v2/space/"] stringByAppendingString:currentuserid] stringByAppendingString:@"/"] stringByAppendingString:spaceid];
    NSString *postString = [[[[[@"title=" stringByAppendingString:title]  stringByAppendingString:@"&description=" ] stringByAppendingString:desc] stringByAppendingString:@"&public="] stringByAppendingString:pub];
    [self jsonResponse :myServerUrl :postString :type ];
}
- (NSMutableArray*) getallTeampages{
    NSString *type = GETMETHOD;
    NSString *myServerUrl = [[[urlval stringByAppendingString:@"/api/v2/spaces/"] stringByAppendingString:currentuserid] stringByAppendingString:@"?space_type=teampage"];
    NSString *postString = @"";
    NSMutableArray *teampgs;
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    if(obj != nil){
        NSDictionary *groupsDict =obj;
        NSMutableArray *arr = [[groupsDict objectForKey:@"result"]  objectForKey:@"entry"];
        teampgs= [[NSMutableArray alloc]init];
        for (int i=0; i<[arr count]; i++ ){
            ST_Teampages *teampage =[[ST_Teampages alloc] init];
            teampage.pgid = (NSString*)[[arr objectAtIndex:i] objectForKey:@"id"];
            teampage.title= [[arr objectAtIndex:i] objectForKey:@"title"];
            teampage.bannerImage= [[arr objectAtIndex:i] objectForKey:@"banner_image"];
            teampage.bannerLink= [[arr objectAtIndex:i] objectForKey:@"banner_link"];
            teampage.logo= [[arr objectAtIndex:i] objectForKey:@"logo"];
            [teampgs addObject:teampage];
        }
    }
    return teampgs;
}

- (void) getTeampage:(NSString *) spaceid{
    NSString *type = GETMETHOD;
    NSString *myServerUrl = [[[[[urlval stringByAppendingString:@"/api/v2/spaces/"] stringByAppendingString:currentuserid] stringByAppendingString:@"/"] stringByAppendingString:spaceid] stringByAppendingString:@"?space_type=teampage"];
    NSString *postString = @"";
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    if(obj != nil){
        NSDictionary *groupsDict = obj;
        if ( groupsDict != nil){
            ST_Teampages *teampage =[[ST_Teampages alloc] init];
            teampage.pgid = (NSString*)[groupsDict objectForKey:@"id"];
            teampage.title= [groupsDict objectForKey:@"title"];
            teampage.bannerImage = [groupsDict objectForKey:@"banner_image"];
            teampage.bannerLink = [groupsDict objectForKey:@"banner_link"];
            teampage.logo = [groupsDict objectForKey:@"logo"];
            NSString *myPeopleServerUrl = [[[[[urlval stringByAppendingString:@"/api/v2/people/"] stringByAppendingString:currentuserid] stringByAppendingString:@"/"] stringByAppendingString:spaceid] stringByAppendingString:@"group_type=teampage"] ;
            NSDictionary *peopleDict = [self jsonResponse :myPeopleServerUrl :postString :type ];
            NSMutableArray *arr = [[peopleDict objectForKey:@"result"]  objectForKey:@"entry"];
            teampage.people = [[NSMutableArray alloc] init];
            for (int i=0; i<[arr count]; i++ ){
                ST_People *person =[[ST_People alloc] init];
                person.aboutMe = [[arr objectAtIndex:i] objectForKey:@"aboutMe"];
                person.thumbnailurl= [[arr objectAtIndex:i] objectForKey:@"thumbnailurl"];
                person.birthday= [[arr objectAtIndex:i] objectForKey:@"birthday"];
                person.department= [[arr objectAtIndex:i] objectForKey:@"department"];
                person.gender= [[arr objectAtIndex:i] objectForKey:@"gender"];
                person.location= [[arr objectAtIndex:i] objectForKey:@"location"];
                person.id= [[arr objectAtIndex:i] objectForKey:@"id"];
                person.connected= ([[arr objectAtIndex:i] objectForKey:@"read"]) ? true : false;
                person.displayName = [[arr objectAtIndex:i] objectForKey:@"displayName"];
                person.emails = [[arr objectAtIndex:i] objectForKey:@"emails"];
                person.name = [[arr objectAtIndex:i] objectForKey:@"name"];
                person.profileUrl = [[arr objectAtIndex:i] objectForKey:@"profileUrl"];
                person.tags = [[arr objectAtIndex:i] objectForKey:@"tags"];
                [teampage.people addObject:person];
            }
        }
    }
}

- (void) getGroup:(NSString *) groupid{
    NSString *type = GETMETHOD;
    NSString *myServerUrl = [[[[urlval stringByAppendingString:@"/api/v2/groups/"] stringByAppendingString:currentuserid] stringByAppendingString:@"/"] stringByAppendingString:groupid];
    NSString *postString = @"";
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    if(obj != nil){
        NSDictionary *groupsDict = obj;
        if ( groupsDict != nil){
            ST_AspectList *aspect =[[ST_AspectList alloc] init];
            aspect.groupName = [groupsDict objectForKey:@"title"];
            aspect.aspectID = [groupsDict objectForKey:@"id"];
            NSString *myPeopleServerUrl = [[[[urlval stringByAppendingString:@"/api/v2/people/"] stringByAppendingString:currentuserid] stringByAppendingString:@"/"] stringByAppendingString:groupid];
            NSDictionary *peopleDict = [self jsonResponse :myPeopleServerUrl :postString :type ];
            NSMutableArray *arr = [[peopleDict objectForKey:@"result"]  objectForKey:@"entry"];
            aspect.people = [[NSMutableArray alloc] init];
            for (int i=0; i<[arr count]; i++ ){
                ST_People *person =[[ST_People alloc] init];
                person.aboutMe = [[arr objectAtIndex:i] objectForKey:@"aboutMe"];
                person.thumbnailurl= [[arr objectAtIndex:i] objectForKey:@"thumbnailurl"];
                person.birthday= [[arr objectAtIndex:i] objectForKey:@"birthday"];
                person.department= [[arr objectAtIndex:i] objectForKey:@"department"];
                person.gender= [[arr objectAtIndex:i] objectForKey:@"gender"];
                person.location= [[arr objectAtIndex:i] objectForKey:@"location"];
                person.id= [[arr objectAtIndex:i] objectForKey:@"id"];
                person.connected= ([[arr objectAtIndex:i] objectForKey:@"read"]) ? true : false;
                person.displayName = [[arr objectAtIndex:i] objectForKey:@"displayName"];
                person.emails = [[arr objectAtIndex:i] objectForKey:@"emails"];
                person.name = [[arr objectAtIndex:i] objectForKey:@"name"];
                person.profileUrl = [[arr objectAtIndex:i] objectForKey:@"profileUrl"];
                person.tags = [[arr objectAtIndex:i] objectForKey:@"tags"];
                [aspect.people addObject:person];
            }
        }
    }
}

- (void) createGroup:(NSString *) groupname{
    NSString *type = POSTMETHOD;
    NSString *myServerUrl = [[urlval stringByAppendingString:@"/api/v2/groups/"]stringByAppendingString:currentuserid];
    NSString *postString = groupname;
    [self jsonResponse :myServerUrl :postString :type ];
}

- (void) deleteGroup:(NSString *) groupid{
    NSString *type = DELMETHOD;
    NSString *myServerUrl = [[[[urlval stringByAppendingString:@"/api/v2/groups/"] stringByAppendingString:currentuserid] stringByAppendingString:@"/"] stringByAppendingString:groupid];
    NSString *postString = @"";
    [self jsonResponse :myServerUrl :postString :type ];
}

- (void) updateGroup:(NSString *) groupid :(NSString *)groupname{
    NSString *type = PUTMETHOD;
    NSString *myServerUrl = [[[[urlval stringByAppendingString:@"/api/v2/groups/"] stringByAppendingString:currentuserid] stringByAppendingString:@"/"] stringByAppendingString:groupid];
    NSString *postString = groupname;
    [self jsonResponse :myServerUrl :postString :type ];
}

- (ST_People*) getUserProfile:(NSString *) userid{
    NSString *type = GETMETHOD;
    NSString *myServerUrl = [[urlval stringByAppendingString:@"/api/v2/people/"] stringByAppendingString:userid];
    NSString *postString = @"";
    ST_People *person;
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    if(obj != nil){
        NSDictionary *groupsDict = obj;
        person=[[ST_People alloc] init];
        person.aboutMe = [groupsDict objectForKey:@"aboutMe"];
        person.thumbnailurl= [groupsDict objectForKey:@"thumbnailurl"];
        person.birthday= [groupsDict objectForKey:@"birthday"];
        person.department= [groupsDict objectForKey:@"department"];
        person.gender= [groupsDict objectForKey:@"gender"];
        person.location= [groupsDict objectForKey:@"location"];
        person.id= [groupsDict objectForKey:@"id"];
        person.connected= ([groupsDict objectForKey:@"connected"]) ? true : false;
        person.displayName = [groupsDict objectForKey:@"displayName"];
        person.emails = [groupsDict objectForKey:@"emails"];
        person.name = [groupsDict objectForKey:@"name"];
        person.profileUrl = [groupsDict objectForKey:@"profileUrl"];
        person.tags = [groupsDict objectForKey:@"tags"];
    }
    return person;
}


- (void) updatePerson:(NSString *) userid : (NSString *) displayName : (NSString *) emails : (NSString *) tags : (NSString *) aboutMe : (NSString *) photo : (NSString *) birthday : (NSString *) gender : (NSString *) location{
    NSString *type = PUTMETHOD;
    NSString *myServerUrl = [[urlval stringByAppendingString:@"/api/v2/people/"] stringByAppendingString:userid];
    NSString *postString = [[[[[[[[[[[[[[[[[@"userid=" stringByAppendingString:userid]  stringByAppendingString:@"&displayName=" ] stringByAppendingString:displayName] stringByAppendingString:@"&emails="] stringByAppendingString:emails] stringByAppendingString:@"&tags="] stringByAppendingString:tags] stringByAppendingString:@"&aboutMe="] stringByAppendingString:aboutMe]  stringByAppendingString:@"&photo="] stringByAppendingString:photo] stringByAppendingString:@"&birthday="] stringByAppendingString:birthday] stringByAppendingString:@"&gender="] stringByAppendingString:gender] stringByAppendingString:@"&location="] stringByAppendingString:location];
    [self jsonResponse :myServerUrl :postString :type ];
}

- (NSMutableArray*) search:(NSString *) searchText{
    NSString *type = GETMETHOD;
    NSString *myServerUrl = [[urlval stringByAppendingString:@"/api/v2/posts/search?text="] stringByAppendingString:searchText];
    NSString *postString = @"";
    NSString *prevUrl;
    NSString *nextUrl;
    NSMutableArray *arr;
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    if(obj != nil){
        NSDictionary *myDicts = obj;
        arr = [myDicts objectForKey:@"posts"];
        prevUrl = [myDicts objectForKey:@"prev_page_link"];
        nextUrl = [myDicts objectForKey:@"next_page_link"];
    }
    return [self getPosts:arr :prevUrl :nextUrl];
}

- (NSMutableArray*) getNotifications{
    NSString *type = GETMETHOD;
    NSString *myServerUrl = [[urlval stringByAppendingString:@"/api/v2/notifications/"] stringByAppendingString:currentuserid];
    NSString *postString = @"";
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    NSMutableArray *notifications = [[NSMutableArray alloc] init];
    if(obj != nil){
        NSDictionary *groupsDict =obj;
        NSMutableArray *arr = [[groupsDict objectForKey:@"result"]  objectForKey:@"entry"];
        NSString *unread_count = [[groupsDict objectForKey:@"result"]  objectForKey:@"unread_count"];
        [notifications addObject:unread_count];
        for (int i=0; i<[arr count]; i++ ){
            ST_Notifications *notification =[[ST_Notifications alloc] init];
            notification.id = [[arr objectAtIndex:i] objectForKey:@"id"];
            notification.verb= [[arr objectAtIndex:i] objectForKey:@"verb"];
            notification.oAuthorDisplayName= [[[[arr objectAtIndex:i] objectForKey:@"object"] objectForKey:@"author"] objectForKey:@"displayName"] ;
            notification.isRead= ([[arr objectAtIndex:i] objectForKey:@"read"]) ? true : false;
            notification.oAuthorUrl= [[[[arr objectAtIndex:i] objectForKey:@"object"] objectForKey:@"author"] objectForKey:@"url"] ;
            notification.oAuthorId= [[[[arr objectAtIndex:i] objectForKey:@"object"] objectForKey:@"author"] objectForKey:@"id"] ;
            notification.oUrl =  [[[arr objectAtIndex:i] objectForKey:@"object"] objectForKey:@"url"] ;
            notification.oType =  [[[arr objectAtIndex:i] objectForKey:@"object"] objectForKey:@"objectType"] ;
            notification.oId =  [[[arr objectAtIndex:i] objectForKey:@"object"] objectForKey:@"id"] ;
            notification.actors = [[NSMutableArray alloc] init];
            NSMutableArray *actors = [[arr objectAtIndex:i] objectForKey:@"actors"];
            for (int a=0; a<[actors count]; a++ ){
                ST_Actors *actor =[[ST_Actors alloc] init];
                actor.id =  [[actors objectAtIndex:a] objectForKey:@"id"];
                actor.url =  [[actors objectAtIndex:a] objectForKey:@"url"];
                actor.displayName =  [[actors objectAtIndex:a] objectForKey:@"displayName"];
                [notification.actors addObject:actor];
            }
            [notifications addObject:notification];
        }
    }
    return notifications;
}
- (NSMutableArray*) getPagePosts:(NSString*)space_id{
    NSString *type = GETMETHOD;
    NSString *myServerUrl =[[[urlval stringByAppendingString:@"/api/v2/spaces/"] stringByAppendingString:[NSString stringWithFormat:@"%@", space_id]] stringByAppendingString: @"/posts/"];
    NSString *postString = @"";
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    NSString *prevUrl;
    NSString *nextUrl;
    NSMutableArray *arr;
    
    if(obj != nil){
        NSDictionary *myDicts =obj;
        arr = [myDicts objectForKey:@"posts"];
        prevUrl = [myDicts objectForKey:@"prev_page_link"];
        nextUrl = [myDicts objectForKey:@"next_page_link"];
    }
    return [self getPosts:arr :prevUrl :nextUrl];
}
- (NSMutableArray*) getStreams{
    NSString *type = GETMETHOD;
    NSString *myServerUrl =[[[urlval stringByAppendingString:@"/api/v2/stream/"] stringByAppendingString:currentuserid] stringByAppendingString: @"/@all"];
    NSString *postString = @"";
    NSString *prevUrl;
    NSString *nextUrl;
    NSMutableArray *arr;
    
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    if(obj != nil){
        NSDictionary *myDicts = obj;
        arr = [myDicts objectForKey:@"posts"];
        prevUrl = [myDicts objectForKey:@"prev_page_link"];
        nextUrl = [myDicts objectForKey:@"next_page_link"];
    }
    return [self getPosts:arr :prevUrl :nextUrl];
}

- (NSMutableArray*) getUserPosts:(NSString *) userid{
    NSString *type = GETMETHOD;
    NSString *myServerUrl = [[urlval stringByAppendingString:@"/api/v2/posts/"] stringByAppendingString:userid];
    NSString *postString = @"";
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    NSString *prevUrl;
    NSString *nextUrl;
    NSMutableArray *arr;
    
    if(obj != nil){
        NSDictionary *myDicts =obj;
        arr = [myDicts objectForKey:@"posts"];
        prevUrl = [myDicts objectForKey:@"prev_page_link"];
        nextUrl = [myDicts objectForKey:@"next_page_link"];
    }
    return [self getPosts:arr :prevUrl :nextUrl];
}

- (NSMutableArray*) getallContacts{
    NSMutableArray *contacts = [self contacts:currentuserid];
    return contacts;
}

- (NSMutableArray*) contacts:(NSString *) userid{
    NSString *type = GETMETHOD;
    NSString *myServerUrl = [[[urlval stringByAppendingString:@"/api/v2/people/"] stringByAppendingString:userid] stringByAppendingString: @"/@following"];
    NSString *postString = @"";
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    NSMutableArray *ucontacts;
    if(obj != nil){
        NSDictionary *myDicts =obj;
        ucontacts= [[NSMutableArray alloc]init];
        NSMutableArray *arr = [[myDicts objectForKey:@"result"]  objectForKey:@"entry"];
        NSString *nextUrl;
        nextUrl = [myDicts objectForKey:@"next_page_link"];
        for (int i=0; i<[arr count]; i++ ){
            ST_People *person =[[ST_People alloc] init];
            person.aboutMe = [[arr objectAtIndex:i] objectForKey:@"aboutMe"];
            person.thumbnailurl= [[arr objectAtIndex:i] objectForKey:@"thumbnailurl"];
            person.birthday= [[arr objectAtIndex:i] objectForKey:@"birthday"];
            person.department= [[arr objectAtIndex:i] objectForKey:@"department"];
            person.gender= [[arr objectAtIndex:i] objectForKey:@"gender"];
            person.location= [[arr objectAtIndex:i] objectForKey:@"location"];
            person.id= [[arr objectAtIndex:i] objectForKey:@"id"];
            person.connected= ([[arr objectAtIndex:i] objectForKey:@"read"]) ? true : false;
            person.displayName = [[arr objectAtIndex:i] objectForKey:@"displayName"];
            person.emails = [[arr objectAtIndex:i] objectForKey:@"emails"];
            person.name = [[arr objectAtIndex:i] objectForKey:@"name"];
            person.profileUrl = [[arr objectAtIndex:i] objectForKey:@"profileUrl"];
            person.tags = [[arr objectAtIndex:i] objectForKey:@"tags"];
            [ucontacts addObject:person];
        }
    }
    return ucontacts;
}

- (NSMutableArray*) getPosts:(NSMutableArray*)arr :(NSString *) prevUrl :(NSString *)nextUrl{
    myPosts=[[NSMutableArray alloc] init];
    for (int i=0; i<[arr count]; i++ ){
        [myPosts addObject:[self getPost: [arr objectAtIndex:i]]];
    }
    NSString *moreurl = nextUrl;
    if ((NSNull *)moreurl == [NSNull null]) { moreurl=@""; }
    nextUrl = moreurl;
    if(nextUrl.length>0)[myPosts addObject:nextUrl];
    return myPosts;
}

- (ST_Posts *) getPost : (id) origPost {
    ST_Posts *post =[[ST_Posts alloc] init];
    post.author = [[ origPost objectForKey:@"actor"] objectForKey:@"displayName"];
    post.PublishedAt = [origPost objectForKey:@"published"];
    post.isPublic = ([origPost objectForKey:@"public"]) ? true : false;
    post.authorUrl = [[origPost objectForKey:@"actor"] objectForKey:@"url"];
    post.authorImageUrl = [[[[origPost objectForKey:@"actor"] objectForKey:@"image"] objectForKey:@"large"] objectForKey:@"url"];
    post.authorImageMediumUrl = [[[[origPost objectForKey:@"actor"] objectForKey:@"image"] objectForKey:@"medium"] objectForKey:@"url"];
    post.authorImageSmallUrl = [[[[origPost objectForKey:@"actor"] objectForKey:@"image"] objectForKey:@"thumbnail"] objectForKey:@"url"];
    //post.type = [origPost objectForKey:@"published"];
    post.postId = [origPost objectForKey:@"id"];
    int fval = (int)[[origPost objectForKey:@"id"]intValue];
    int sval = (int)[[[origPost objectForKey:@"object"] objectForKey:@"id"]intValue];
    if(fval== sval){
        post.isReshare = false;
    }else{
        post.isReshare = true;
    }
    if (post.isReshare) {
        post.reshareId = [[origPost objectForKey:@"object"] objectForKey:@"id"];
        post.rauthor = [[[origPost objectForKey:@"object"] objectForKey:@"actor"] valueForKey:@"displayName"];
        post.rauthorUrl = [[[origPost objectForKey:@"object"] objectForKey:@"actor"] objectForKey:@"url"];
        post.rauthorImageUrl = [[[[[origPost objectForKey:@"object"] objectForKey:@"actor"] objectForKey:@"image"]  objectForKey:@"large"] objectForKey:@"url"];
        post.rauthorImageMediumUrl =  [[[[[origPost objectForKey:@"object"] objectForKey:@"actor"] objectForKey:@"image"] objectForKey:@"medium"] objectForKey:@"url"];
        post.rauthorImageSmallUrl = [[[[[origPost objectForKey:@"object"] objectForKey:@"actor"] objectForKey:@"image"] objectForKey:@"thumbnail"] objectForKey:@"url"];
    }
    post.content = [[origPost objectForKey:@"object"] objectForKey:@"raw_content"];
    post.images = [[NSMutableArray alloc] init];
    NSMutableArray *imagelinks = [self getRegExImgLinks: post.content];
    if ([imagelinks count] > 0){
        for (int il=0; il<[imagelinks count]; il++ ){
            ST_Attachments *attachment =[[ST_Attachments alloc] init];
            attachment.smallUrl = [imagelinks objectAtIndex:il] ;
            attachment.type = @"image";
            [post.images addObject:attachment];
        }
    }
    //post.Attachments = [origPost objectForKey:@""];
    //post.Oembed = [origPost objectForKey:@""];
    NSMutableArray *links = [origPost objectForKey:@"links"];
    for (int link=0; link<[links count]; link++ ){
        NSString *rel = [[links objectAtIndex:link] objectForKey:@"rel"];
        if ([rel isEqual: @"like"]){
            post.likeUrl = [[links objectAtIndex:link] objectForKey:@"href"];
        } else if([rel isEqual: @"Comment"]){
            post.commentUrl = [[links objectAtIndex:link] objectForKey:@"href"];
        } else if([rel isEqual: @"Reshare"]){
            post.reshareUrl = [[links objectAtIndex:link] objectForKey:@"href"];
        } else if([rel isEqual: @"unlike"]){
            post.unlike = [[links objectAtIndex:link] objectForKey:@"href"];
        }else if([rel isEqual: @"Get Comments"]){
            post.allCommentsUrl = [[links objectAtIndex:link] objectForKey:@"href"];
        }
    }
    post.likeCount = (int)[[origPost objectForKey:@"likes_count"] intValue];
    post.reshareCount = (int)[[origPost objectForKey:@"reshares_count"] intValue];
    post.commentsCount = (int)[[origPost objectForKey:@"comments_count"] intValue];
    //COMMENTS
    post.commentsArr = [[NSMutableArray alloc] init];
    NSMutableArray *carr = [origPost objectForKey:@"comments"];
    for (int c=0; c<[carr count]; c++ ){
        [post.commentsArr addObject:[self getComment: [carr objectAtIndex:c]]];
    }
    post.attachments = [[NSMutableArray alloc] init];
    post.oembed = [[NSMutableArray alloc] init];
    post.images = [[NSMutableArray alloc] init];
    NSMutableArray *attarr = [[origPost objectForKey:@"object"] objectForKey:@"attachments"];
    for (int ac=0; ac<[attarr count]; ac++ ){
        NSMutableArray *iarr = [[attarr objectAtIndex:ac] objectForKey:@"images"];
        for (int ic=0; ic<[iarr count]; ic++ ){
            ST_Attachments *attachment =[[ST_Attachments alloc] init];
            attachment.Url = [[[iarr objectAtIndex:ic] objectForKey:@"large"] objectForKey:@"url"];
            attachment.mediumUrl = [[[iarr objectAtIndex:ic] objectForKey:@"medium"] objectForKey:@"url"];
            attachment.smallUrl = [[[iarr objectAtIndex:ic] objectForKey:@"thumbnail"] objectForKey:@"url"];
            attachment.type = @"image";
            if(ic==0)post.wallurl = attachment.smallUrl;
            [post.images addObject:attachment];
        }
        NSMutableArray *darr = [[attarr objectAtIndex:ac] objectForKey:@"documents"];
        for (int dc=0; dc<[darr count]; dc++ ){
            ST_Attachments *attachment =[[ST_Attachments alloc] init];
            attachment.Url = [[darr objectAtIndex:dc] objectForKey:@"url"];
            attachment.type = [[darr objectAtIndex:dc] objectForKey:@"type"];
            [post.attachments addObject:attachment];
        }
        
        ST_Oembed *oembed =[[ST_Oembed alloc] init];
        if ([[attarr objectAtIndex:ac] objectForKey:@"link"] != [NSNull null]){
            oembed.Url = [[[attarr objectAtIndex:ac] objectForKey:@"link"] objectForKey:@"url"];
            oembed.providerUrl = [[[attarr objectAtIndex:ac] objectForKey:@"link"] objectForKey:@"providerUrl"];
            oembed.providerName = [[[attarr objectAtIndex:ac] objectForKey:@"link"] objectForKey:@"providerName"];
            oembed.title = [[[attarr objectAtIndex:ac] objectForKey:@"link"] objectForKey:@"title"];
            oembed.description = [[[attarr objectAtIndex:ac] objectForKey:@"link"] objectForKey:@"description"];
            oembed.imageUrl = [[[[attarr objectAtIndex:ac] objectForKey:@"link"] objectForKey:@"image"] objectForKey:@"url"];
            if ([[[[attarr objectAtIndex:ac] objectForKey:@"link"] objectForKey:@"image"] objectForKey:@"width"] != [NSNull null])
                oembed.imageWidth = (int *)[[[[[attarr objectAtIndex:ac] objectForKey:@"link"] objectForKey:@"image"] objectForKey:@"width"] intValue];
            if ([[[[attarr objectAtIndex:ac] objectForKey:@"link"] objectForKey:@"image"] objectForKey:@"height"] != [NSNull null])
                oembed.imageHeight = (int *)[[[[[attarr objectAtIndex:ac] objectForKey:@"link"] objectForKey:@"image"] objectForKey:@"height"] intValue];
            [post.oembed addObject:oembed];
        }
    }
	
	return post;
}

- (ST_Comments *) getComment : (id) origComment {
	ST_Comments *comment =[[ST_Comments alloc] init];
    comment.cauthor = [[origComment objectForKey:@"actor"] objectForKey:@"displayName"];
    comment.ccommentAt = [origComment objectForKey:@"published"];
    comment.cauthorUrl = [[origComment objectForKey:@"actor"] objectForKey:@"url"];
    
    comment.cauthorImageUrl = [[[[origComment objectForKey:@"actor"] objectForKey:@"image"] objectForKey:@"large"] objectForKey:@"url"];
    comment.cauthorImageMediumUrl = [[[[origComment objectForKey:@"actor"] objectForKey:@"image"] objectForKey:@"medium"] objectForKey:@"url"];
    comment.cauthorImageSmallUrl = [[[[origComment objectForKey:@"actor"] objectForKey:@"image"] objectForKey:@"thumbnail"] objectForKey:@"url"];
    comment.ccommentID = [origComment objectForKey:@"id"];
    comment.ccommentMessage = [origComment objectForKey:@"content"];
    comment.likeCount =(int)[[origComment objectForKey:@"likes_count"] intValue];
    //comment.postId = (int)[origComment objectForKey:@"id"];
    NSMutableArray *clinks = [origComment objectForKey:@"links"];
    for (int clink=0; clink<[clinks count]; clink++ ){
        NSString *rel = [[clinks objectAtIndex:clink] objectForKey:@"rel"];
        if ([rel isEqual: @"like"]){
            comment.likeUrl = [[clinks objectAtIndex:clink] objectForKey:@"href"];
        } else if([rel isEqual: @"Delete comment"]){
            comment.deleteUrl = [[clinks objectAtIndex:clink] objectForKey:@"href"];
        } else if ([rel isEqual: @"unlike"]){
            comment.unlike = [[clinks objectAtIndex:clink] objectForKey:@"href"];
        }
    }
    return comment;
}

- (NSMutableArray*) paginatedPosts: (NSString *) url {
    NSString *type = GETMETHOD;
    NSString *myServerUrl = url;
    NSString *postString = @"";
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    NSString *prevUrl;
    NSString *nextUrl;
    NSMutableArray *arr;
    if(obj != nil){
        NSDictionary *myDicts = obj;
        arr = [myDicts objectForKey:@"posts"];
        prevUrl = [myDicts objectForKey:@"prev_page_link"];
        nextUrl = [myDicts objectForKey:@"next_page_link"];
    }
    return [self getPosts:arr :prevUrl :nextUrl];
}

- (ST_Tags *) createTag: (NSString *) name{
    NSString *type = POSTMETHOD;
    NSString *myServerUrl = [[[urlval stringByAppendingString:@"/api/v2/tags/"] stringByAppendingString:name] stringByAppendingString:@"/follow"];
    NSString *postString = @"";
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    ST_Tags *tag;
    if(obj != nil){
        NSDictionary *myDict = obj;
        tag=[[ST_Tags alloc] init];
        if ([myDict objectForKey:@"followed_tags"] != [NSNull null]){
            tag.id = [[myDict objectForKey:@"followed_tags"] objectForKey:@"id"];
            tag.name= [[myDict objectForKey:@"followed_tags"] objectForKey:@"name"];
        }
    }
    return tag;
}

- (void) deletePost: (NSString *) url {
    NSString *type = DELMETHOD;
    NSString *myServerUrl = url;
    NSString *postString = @"";
    [self jsonResponse :myServerUrl :postString :type ];
}

- (ST_Posts *) createPagePost: (NSString *) message : (NSString *) link : (NSString *) pageId{
    NSString *type = POSTMETHOD;
    NSString *myServerUrl = [urlval stringByAppendingString:@"/api/v2/posts/"];
    NSString *postString;
    if(link!=nil){
        postString= [[[[[@"message=" stringByAppendingString:message] stringByAppendingString:@"&oembed_url="] stringByAppendingString:link] stringByAppendingString:@"&page_id="] stringByAppendingString:pageId];
    }else{
        postString= [[[@"message=" stringByAppendingString:message] stringByAppendingString:@"&page_id="] stringByAppendingString:[NSString stringWithFormat:@"%@",pageId]];
    }
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    NSDictionary *myDict;
    if(obj != nil){
        myDict = obj;
    }
    return [self getPost: myDict];
}

- (ST_Posts *) postToAspects: (NSString *) message : (NSString *) link : (NSString *) aspect_ids {
    NSString *type = POSTMETHOD;
    NSString *myServerUrl = [urlval stringByAppendingString:@"/api/v2/posts/"];
    NSString *postString = [[[[[@"message=" stringByAppendingString:message] stringByAppendingString:@"&oembed_url="] stringByAppendingString:link] stringByAppendingString:@"&aspect_ids="] stringByAppendingString:aspect_ids];
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    NSDictionary *myDict;
    if(obj != nil){
        myDict= obj;
    }
    return [self getPost: myDict];
}

- (ST_Posts *) createPost: (NSString *) message : (NSString *) link{
    NSString *type = POSTMETHOD;
    NSString *myServerUrl = [urlval stringByAppendingString:@"/api/v2/posts/"];
    NSString *postString;
    if(link!=nil){
        postString= [[[@"message=" stringByAppendingString:message] stringByAppendingString:@"&oembed_url="] stringByAppendingString:link];
    }else{
        postString= [@"message=" stringByAppendingString:message];
    }
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    NSDictionary *myDict;
    if(obj != nil){
        myDict= obj;
    }
    return [self getPost: myDict];
}

- (NSMutableArray*) getImages:(NSString *) userid{
    NSString *type = GETMETHOD;
    NSString *myServerUrl = [[urlval stringByAppendingString:@"/api/v2/photos/"] stringByAppendingString:userid];
    NSString *postString = @"";
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    NSMutableArray *images;
    if(obj != nil){
        NSDictionary *groupsDict =obj;
        NSMutableArray *arr = [groupsDict objectForKey:@"photos"];
        for (int i=0; i<[arr count]; i++ ){
            ST_Attachments *attachment =[[ST_Attachments alloc] init];
            attachment.Url = [[[arr objectAtIndex:i] objectForKey:@"large"] objectForKey:@"url"];
            attachment.mediumUrl = [[[arr objectAtIndex:i] objectForKey:@"medium"] objectForKey:@"url"];
            attachment.smallUrl = [[[arr objectAtIndex:i] objectForKey:@"thumbnail"] objectForKey:@"url"];
            attachment.type = @"image";
            [images addObject:attachment];
        }
    }
    return images;
}

- (NSMutableArray*)getRegExImgLinks : (NSString *) text {
    NSMutableArray* urlArr = [NSMutableArray new];
    NSString *string = text;
    NSString *regexp = @"http[s]?://(?:([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w\?\\.-]+\\.(jpg|png|jpeg)))+";
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingAllSystemTypes error:nil];
    NSArray *matches = [linkDetector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in matches) {
        if ([match resultType] == NSTextCheckingTypeLink) {
            NSURL *url = [match URL];
            NSString *urlstring = [NSString stringWithFormat:@"%@",url];
            NSRegularExpression *regex = [NSRegularExpression
                                          regularExpressionWithPattern:regexp
                                          options:0
                                          error:nil];
            
            NSUInteger count = [regex numberOfMatchesInString:urlstring
                                                      options:0
                                                        range:NSMakeRange(0, [urlstring length])];
            if(count>=1){
                [urlArr addObject:urlstring];
            }
        }
    }
    return urlArr;
}

//stream_type=mentions, likes, comments
- (NSMutableArray*) getUserStreams : (NSString *) stream_type{
    NSString *type = GETMETHOD;
    NSString *myServerUrl =[[[[urlval stringByAppendingString:@"/api/v2/stream/"] stringByAppendingString:currentuserid] stringByAppendingString:@"/"] stringByAppendingString:stream_type];
    NSString *postString = @"";
    NSString *prevUrl;
    NSString *nextUrl;
    NSMutableArray *arr;
    
    id obj =  [self jsonResponse :myServerUrl :postString  :type ];
    if(obj != nil){
        NSDictionary *myDicts = obj;
        arr = [myDicts objectForKey:@"posts"];
        prevUrl = [myDicts objectForKey:@"prev_page_link"];
        nextUrl = [myDicts objectForKey:@"next_page_link"];
    }
    return [self getPosts:arr :prevUrl :nextUrl];
}
@end