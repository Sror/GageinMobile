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
//-(void)getExploringUpdatesWithNewsID:(long long)aNewsID
//                          pageFlag:(EGGPageFlag)aPageFlag
//                          pageTime:(long long)aPageTime
//                         relevance:(EGGCompanyUpdateRelevance)aRelevance
//                          callback:(GGApiBlock)aCallback
//{
//    [self getCompanyUpdatesWithCompanyID:GG_ALL_RESULT_ID newsID:aNewsID pageFlag:aPageFlag pageTime:aPageTime relevance:aRelevance callback:aCallback];
//}

// get company updates by company id
-(void)getCompanyUpdatesWithCompanyID:(long long)aCompanyID
                            newsID:(long long)aNewsID
                          pageFlag:(EGGPageFlag)aPageFlag
                          pageTime:(long long)aPageTime
                         relevance:(EGGCompanyUpdateRelevance)aRelevance
                          callback:(GGApiBlock)aCallback
{
    if (GGSharedRuntimeData.accessToken == nil) {
        return;
    }
    //GET
    NSString *path = @"member/me/update/tracker";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithLongLong:aNewsID] forKey:@"newsid"];
    [parameters setObject:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
    [parameters setObject:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
    [parameters setObject:[NSNumber numberWithLongLong:aCompanyID] forKey:@"orgid"];
    [parameters setObject:[NSNumber numberWithInt:aRelevance] forKey:@"relevance"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

// get company updates by agent id
-(void)getCompanyUpdatesWithAgentID:(long long)anAgentID
                            newsID:(long long)aNewsID
                          pageFlag:(EGGPageFlag)aPageFlag
                          pageTime:(long long)aPageTime
                         relevance:(EGGCompanyUpdateRelevance)aRelevance
                          callback:(GGApiBlock)aCallback
{
    if (GGSharedRuntimeData.accessToken == nil) {
        return;
    }
    
    //GET
    NSString *path = @"member/me/update/tracker";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithLongLong:aNewsID] forKey:@"newsid"];
    [parameters setObject:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
    [parameters setObject:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
    [parameters setObject:[NSNumber numberWithLongLong:anAgentID] forKey:@"agentid"];
    [parameters setObject:[NSNumber numberWithInt:aRelevance] forKey:@"relevance"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

// get company event by company id
//-(void)getEventsWithCompanyID:(long long)aCompanyID
//                           pageFlag:(EGGPageFlag)aPageFlag
//                     pageTime:(long long)aPageTime
//                      eventID:(long long)anEventID
//                           callback:(GGApiBlock)aCallback
//{
//    if (GGSharedRuntimeData.accessToken == nil) {
//        return;
//    }
//    
//    //GET
//    NSString *path = @"member/me/event/tracker";
//    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
//    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
//    [parameters setObject:[NSNumber numberWithLongLong:aCompanyID] forKey:@"orgid"];
//    [parameters setObject:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
//    [parameters setObject:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
//    [parameters setObject:[NSNumber numberWithLongLong:anEventID] forKey:@"eventid"];
//    
//    [self _execGetWithPath:path params:parameters callback:aCallback];
//}

//// get people event by person id
//-(void)getEventsWithPersonID:(long long)aPersonID
//                     pageFlag:(EGGPageFlag)aPageFlag
//                     pageTime:(long long)aPageTime
//                      eventID:(long long)anEventID
//                     callback:(GGApiBlock)aCallback
//{
//    if (GGSharedRuntimeData.accessToken == nil) {
//        return;
//    }
//    
//    //GET
//    NSString *path = @"member/me/event/tracker";
//    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
//    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
//    [parameters setObject:[NSNumber numberWithLongLong:aPersonID] forKey:@"contactid"];
//    [parameters setObject:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
//    [parameters setObject:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
//    [parameters setObject:[NSNumber numberWithLongLong:anEventID] forKey:@"eventid"];
//    
//    [self _execGetWithPath:path params:parameters callback:aCallback];
//}

//// get area event by area id
//-(void)getEventsWithAreaID:(long long)anAreaID
//                    pageFlag:(EGGPageFlag)aPageFlag
//                    pageTime:(long long)aPageTime
//                     eventID:(long long)anEventID
//                    callback:(GGApiBlock)aCallback
//{
//    if (GGSharedRuntimeData.accessToken == nil) {
//        return;
//    }
//    
//    //GET
//    NSString *path = @"member/me/event/tracker";
//    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
//    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
//    [parameters setObject:[NSNumber numberWithLongLong:anAreaID] forKey:@"functional_areaid"];
//    [parameters setObject:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
//    [parameters setObject:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
//    [parameters setObject:[NSNumber numberWithLongLong:anEventID] forKey:@"eventid"];
//    
//    [self _execGetWithPath:path params:parameters callback:aCallback];
//}

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
    [parameters setObject:(aNeedSP ? @"true" : @"false") forKey:@"include_sp"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//SO04:Get Company SuggestionBack to top
//POST
//
///svc/search/companies/get_suggestions
-(void)getCompanySuggestionWithKeyword:(NSString *)aKeyword callback:(GGApiBlock)aCallback
{
    //POST
    NSString *path = @"search/companies/get_suggestions";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:aKeyword forKey:@"q"];
    
    [self _execPostWithPath:path params:parameters callback:aCallback];
}

//SO01:Search CompaniesBack to top
//POST
//
///svc/search/companies
-(void)searchCompaniesWithKeyword:(NSString *)aKeyword
                             page:(int)aPage
                         callback:(GGApiBlock)aCallback
{
    //POST
    NSString *path = @"search/companies";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithInt:aPage] forKey:@"page"];
    [parameters setObject:aKeyword forKey:@"q"];
    
    [self _execPostWithPath:path params:parameters callback:aCallback];
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

//MO06:Get Followed CompaniesBack to top
//GET
//
///svc/member/me/company/get_followed
-(void)getFollowedCompaniesWithPage:(int)aPage callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/company/get_followed";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithInt:aPage] forKey:@"page"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//3.Get a update detail
//GET:update/<newsid>/detail
-(void)getCompanyUpdateDetailWithNewsID:(long long)aNewsID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"update/%lld/detail", aNewsID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    //[parameters setObject:[NSNumber numberWithLongLong:aNewsID] forKey:@"newsid"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//OC01:Get Company ContactsBack to top
//GET
///svc/company/<orgid>/contacts, e,g, /svc/company/1399794/contacts
-(void)getCompanyPeopleWithOrgID:(long long)anOrgID
                      pageNumber:(NSUInteger)aPageNumber
                        callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"company/%lld/contacts", anOrgID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithLongLong:aPageNumber] forKey:@"page"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//OT01:Get Company CompetitorsBack to top
//GET
///svc/company/<orgid>/competitors, e,g, /svc/company/1399794/competitors
-(void)getSimilarCompaniesWithOrgID:(long long)anOrgID
                         pageNumber:(NSUInteger)aPageNumber
                           callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"company/%lld/competitors", anOrgID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithLongLong:aPageNumber] forKey:@"page"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

@end
