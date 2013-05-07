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
-(void)searchPeopleWithKeyword:(NSString *)aKeyword
                             page:(int)aPage
                         callback:(GGApiBlock)aCallback
{
    //POST
    NSString *path = @"search/contacts";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithInt:aPage] forKey:@"page"];
    [parameters setObject:aKeyword forKey:@"q"];
    
    [self _execPostWithPath:path params:parameters callback:aCallback];
}

//MC01:Follow ContactBack to top
//GET
///svc/member/me/contact/follow
-(void)followPersonWithID:(long long)aPersonID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/contact/follow";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithLongLong:aPersonID] forKey:@"contactid"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//MC02:UnFollow ContactBack to top
//GET
///svc/member/me/contact/unfollow
-(void)unfollowPersonWithID:(long long)aPersonID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/contact/unfollow";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithLongLong:aPersonID] forKey:@"contactid"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}


//C01:Contact OverviewBack to top
//GET
///svc/contact/<contactid>/overview, e,g, /svc/contact/150704/overview
-(void)getPersonOverviewWithID:(long long)aPersonID callback:(GGApiBlock)aCallback
{
    // GET
    NSString *path = [NSString stringWithFormat:@"contact/%lld/overview", aPersonID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

-(void)getMyOverview:(GGApiBlock)aCallback
{
    // GET
    NSString *path = @"member/me/overview";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    //[parameters setObject:@"me" forKey:@"memid"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

@end
