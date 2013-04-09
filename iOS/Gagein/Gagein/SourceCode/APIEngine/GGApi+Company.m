//
//  GGApi+Company.m
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGApi+Company.h"

@implementation GGApi (Company)

#pragma mark - company APIs
-(void)getCompanyUpdatesWithNewsID:(long long)aNewsID
                          pageFlag:(EGGPageFlag)aPageFlag
                          pageTime:(long long)aPageTime
                         relevance:(EGGCompanyUpdateRelevance)aRelevance
                          callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/update/tracker";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithLongLong:aNewsID] forKey:@"newsid"];
    [parameters setObject:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
    [parameters setObject:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
    [parameters setObject:[NSNumber numberWithInt:aRelevance] forKey:@"relevance"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//Get Company OverviewBack to top
-(void)getCompanyOverviewWithID:(long long)anOrgID
              needSocialProfile:(BOOL)aNeedSP
                       callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"company/%lld/overview", anOrgID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithBool:aNeedSP] forKey:@"include_sp"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//MO03:Follow a CompanyBack to top
-(void)followCompanyWithID:(long long)aCompanyID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/company/follow";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithLongLong:aCompanyID] forKey:@"orgid"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//MO04:Unfollow a CompanyBack to top
-(void)unfollowCompanyWithID:(long long)aCompanyID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/company/unfollow";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithLongLong:aCompanyID] forKey:@"orgid"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}
@end