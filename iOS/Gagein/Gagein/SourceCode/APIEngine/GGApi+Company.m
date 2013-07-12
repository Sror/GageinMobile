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


//OU01:Get Company UpdatesBack to top
//GET
//
///svc/company/<orgid>/updates, e,g, /svc/company/1399794/updates
//Get company updates in the past 90 days.
//Sample Url:
//https://www.gagein.com/svc/company/1399794/updates?appcode=09ad5d624c0294d1&access_token=96cb45c990fff4d5c4c369173505d761&relevance=10&newsid=0&pageflag=0&pagetime=0

// Get Company UpdatesBack to top
-(AFHTTPRequestOperation *)getCompanyUpdatesNoFilteWithCompanyID:(long long)aCompanyID
                                                   newsID:(long long)aNewsID
                                                 pageFlag:(EGGPageFlag)aPageFlag
                                                 pageTime:(long long)aPageTime
                                                relevance:(EGGCompanyUpdateRelevance)aRelevance
                                                 callback:(GGApiBlock)aCallback
{
    if (GGSharedRuntimeData.accessToken == nil) {
        return nil;
    }
    //GET
    NSString *path = [NSString stringWithFormat:@"company/%lld/updates", aCompanyID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aNewsID] forKey:@"newsid"];
    [parameters setObjectIfNotNil:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aCompanyID] forKey:@"orgid"];
    [parameters setObjectIfNotNil:[NSNumber numberWithInt:aRelevance] forKey:@"relevance"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

// get similar updates
-(AFHTTPRequestOperation *)getSimilarUpdatesWithID:(long long)aSimilarID
                                          callback:(GGApiBlock)aCallback
{
    if (GGSharedRuntimeData.accessToken == nil) {
        return nil;
    }
    //GET
    NSString *path = @"member/me/update/tracker";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:@(aSimilarID) forKey:@"storyline"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

// get company updates by company id
-(AFHTTPRequestOperation *)getCompanyUpdatesWithCompanyID:(long long)aCompanyID
                            newsID:(long long)aNewsID
                          pageFlag:(EGGPageFlag)aPageFlag
                          pageTime:(long long)aPageTime
                         relevance:(EGGCompanyUpdateRelevance)aRelevance
                          callback:(GGApiBlock)aCallback
{
    if (GGSharedRuntimeData.accessToken == nil) {
        return nil;
    }
    //GET
    NSString *path = @"member/me/update/tracker";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aNewsID] forKey:@"newsid"];
    [parameters setObjectIfNotNil:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aCompanyID] forKey:@"orgid"];
    [parameters setObjectIfNotNil:[NSNumber numberWithInt:aRelevance] forKey:@"relevance"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

// get company updates by agent id
-(AFHTTPRequestOperation *)getCompanyUpdatesWithAgentID:(long long)anAgentID
                            newsID:(long long)aNewsID
                          pageFlag:(EGGPageFlag)aPageFlag
                          pageTime:(long long)aPageTime
                         relevance:(EGGCompanyUpdateRelevance)aRelevance
                          callback:(GGApiBlock)aCallback
{
    if (GGSharedRuntimeData.accessToken == nil) {
        return nil;
    }
    
    //GET
    NSString *path = @"member/me/update/tracker";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aNewsID] forKey:@"newsid"];
    [parameters setObjectIfNotNil:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:anAgentID] forKey:@"agentid"];
    [parameters setObjectIfNotNil:[NSNumber numberWithInt:aRelevance] forKey:@"relevance"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}




//Get Company OverviewBack to top
-(AFHTTPRequestOperation *)getCompanyOverviewWithID:(long long)anOrgID
                                  needSocialProfile:(BOOL)aNeedSP
                                          contactID:(long long)aContactID
                                           callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"company/%lld/overview", anOrgID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:(aNeedSP ? @"true" : @"false") forKey:@"include_sp"];
    
    //include_contacts
    [parameters setObjectIfNotNil:@"true" forKey:@"include_contacts"];
    if (aContactID > 0)
    {
        [parameters setObjectIfNotNil:@(aContactID) forKey:@"contactid"];
    }
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

-(AFHTTPRequestOperation *)getCompanyOverviewWithID:(long long)anOrgID
              needSocialProfile:(BOOL)aNeedSP
                       callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"company/%lld/overview", anOrgID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:(aNeedSP ? @"true" : @"false") forKey:@"include_sp"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//SO04:Get Company SuggestionBack to top
//POST
//
///svc/search/companies/get_suggestions
-(AFHTTPRequestOperation *)getCompanySuggestionWithKeyword:(NSString *)aKeyword callback:(GGApiBlock)aCallback
{
    //POST
    NSString *path = @"search/companies/get_suggestions";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:aKeyword forKey:@"q"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//SO01:Search CompaniesBack to top
//POST
//
///svc/search/companies
//-(AFHTTPRequestOperation *)searchCompaniesWithKeyword:(NSString *)aKeyword
//                             page:(int)aPage
//                         callback:(GGApiBlock)aCallback
//{
//    //POST
//    NSString *path = @"search/companies";
//    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
//    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
//    [parameters setObjectIfNotNil:[NSNumber numberWithInt:aPage] forKey:@"page"];
//    [parameters setObjectIfNotNil:aKeyword forKey:@"q"];
//    
//    return [self _execPostWithPath:path params:parameters callback:aCallback];
//}

//MO03:Follow a CompanyBack to top
-(AFHTTPRequestOperation *)followCompanyWithID:(long long)aCompanyID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/company/follow";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aCompanyID] forKey:@"orgid"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//MO04:Unfollow a CompanyBack to top
-(AFHTTPRequestOperation *)unfollowCompanyWithID:(long long)aCompanyID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/company/unfollow";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aCompanyID] forKey:@"orgid"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//MO06:Get Followed CompaniesBack to top
//GET
//
///svc/member/me/company/get_followed
-(AFHTTPRequestOperation *)getFollowedCompaniesWithPage:(int)aPage callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/company/get_followed";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:[NSNumber numberWithInt:aPage] forKey:@"page"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//3.Get a update detail
//GET:update/<newsid>/detail
-(AFHTTPRequestOperation *)getCompanyUpdateDetailWithNewsID:(long long)aNewsID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"update/%lld/detail", aNewsID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:@"true" forKey:@"include_competitors"];
    //[parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aNewsID] forKey:@"newsid"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//OC01:Get Company ContactsBack to top
//GET
///svc/company/<orgid>/contacts, e,g, /svc/company/1399794/contacts
-(AFHTTPRequestOperation *)getCompanyPeopleWithOrgID:(long long)anOrgID
                      pageNumber:(NSUInteger)aPageNumber
                        callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"company/%lld/contacts", anOrgID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aPageNumber] forKey:@"page"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//OT01:Get Company CompetitorsBack to top
//GET
///svc/company/<orgid>/competitors, e,g, /svc/company/1399794/competitors
-(AFHTTPRequestOperation *)getSimilarCompaniesWithOrgID:(long long)anOrgID
                         pageNumber:(NSUInteger)aPageNumber
                           callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"company/%lld/competitors", anOrgID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aPageNumber] forKey:@"page"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

///me/company/get_recommended
-(AFHTTPRequestOperation *)getRecommendedCompanieWithPage:(long long)aPageNumber callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/company/get_recommended";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aPageNumber] forKey:@"page"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

@end
