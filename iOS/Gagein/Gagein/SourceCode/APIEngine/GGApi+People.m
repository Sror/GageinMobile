//
//  GGApi+People.m
//  Gagein
//
//  Created by dong yiming on 13-4-26.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGApi+People.h"

@implementation GGApi (People)

//SC01:Search ContactsBack to top
//POST
///svc/search/contacts
-(AFHTTPRequestOperation *)searchPeopleWithKeyword:(NSString *)aKeyword
                             page:(int)aPage
                         callback:(GGApiBlock)aCallback
{
    //POST
    NSString *path = @"search/contacts";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:[NSNumber numberWithInt:aPage] forKey:@"page"];
    [parameters setObjectIfNotNil:aKeyword forKey:@"q"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//4. get suggested contacts when search contacts.
//POST: /svc/search/contact/get_suggestions
//Parameters: access_token=b4790223c67f68b744d6ac3bb9b830e6&q=c
-(AFHTTPRequestOperation *)getSuggestedPeopleWithKeyword:(NSString *)aKeyword
                                                    page:(int)aPage
                                                callback:(GGApiBlock)aCallback
{
    //POST
    NSString *path = @"search/contacts/get_suggestions";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:aKeyword forKey:@"q"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//MC01:Follow ContactBack to top
//GET
///svc/member/me/contact/follow
-(AFHTTPRequestOperation *)followPersonWithID:(long long)aPersonID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/contact/follow";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aPersonID] forKey:@"contactid"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//MC02:UnFollow ContactBack to top
//GET
///svc/member/me/contact/unfollow
-(AFHTTPRequestOperation *)unfollowPersonWithID:(long long)aPersonID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/contact/unfollow";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aPersonID] forKey:@"contactid"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}


//5.get followed
//GET: /svc/member/me/contact/get_followed
//Parameters: access_token=b4790223c67f68b744d6ac3bb9b830e6&page=1
//
-(AFHTTPRequestOperation *)getFollowedPeopleWithPage:(long long)aPageNumber callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/contact/get_followed";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__LONGLONG(aPageNumber) forKey:@"page"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//6.get recommended contacts for follow
//GET: /svc/member/me/contact/get_recommended
//Parameters: access_token=b4790223c67f68b744d6ac3bb9b830e6&page=1
-(AFHTTPRequestOperation *)getRecommendedPeopleWithPage:(long long)aPageNumber callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/contact/get_recommended";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__LONGLONG(aPageNumber) forKey:@"page"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//C01:Contact OverviewBack to top
//GET
///svc/contact/<contactid>/overview, e,g, /svc/contact/150704/overview
-(AFHTTPRequestOperation *)getPersonOverviewWithID:(long long)aPersonID callback:(GGApiBlock)aCallback
{
    // GET
    NSString *path = [NSString stringWithFormat:@"contact/%lld/overview", aPersonID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

-(AFHTTPRequestOperation *)getMyOverview:(GGApiBlock)aCallback
{
    // GET
    NSString *path = @"member/me/overview";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    //[parameters setObjectIfNotNil:@"me" forKey:@"memid"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//2.send upgrade link
//POST:/svc/config/plan/send_link
-(AFHTTPRequestOperation *)sendUpgradeLink:(GGApiBlock)aCallback
{
    // GET
    NSString *path = @"config/plan/send_link";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    //[parameters setObjectIfNotNil:@"me" forKey:@"memid"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

@end
