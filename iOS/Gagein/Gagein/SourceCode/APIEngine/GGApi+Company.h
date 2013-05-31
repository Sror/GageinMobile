//
//  GGApi+Company.h
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum
{
    kGGCompanyUpdateRelevanceNormal     = 10
    , kGGCompanyUpdateRelevanceHigh     = 20
    , kGGCompanyUpdateRelevanceVeryHigh = 30
    , kGGCompanyUpdateRelevanceHighest  = 40
}EGGCompanyUpdateRelevance;



@interface GGApi (Company)

#pragma mark - company APIs

// get company updates by company id
-(AFHTTPRequestOperation *)getCompanyUpdatesWithCompanyID:(long long)aCompanyID
                               newsID:(long long)aNewsID
                             pageFlag:(EGGPageFlag)aPageFlag
                             pageTime:(long long)aPageTime
                            relevance:(EGGCompanyUpdateRelevance)aRelevance
                             callback:(GGApiBlock)aCallback;

// get company updates by agent id
-(AFHTTPRequestOperation *)getCompanyUpdatesWithAgentID:(long long)anAgentID
                             newsID:(long long)aNewsID
                           pageFlag:(EGGPageFlag)aPageFlag
                           pageTime:(long long)aPageTime
                          relevance:(EGGCompanyUpdateRelevance)aRelevance
                           callback:(GGApiBlock)aCallback;

//Get Company OverviewBack to top
-(AFHTTPRequestOperation *)getCompanyOverviewWithID:(long long)anOrgID
              needSocialProfile:(BOOL)aNeedSP
                       callback:(GGApiBlock)aCallback;

//SO04:Get Company SuggestionBack to top
-(AFHTTPRequestOperation *)getCompanySuggestionWithKeyword:(NSString *)aKeyword callback:(GGApiBlock)aCallback;

//SO01:Search CompaniesBack to top
-(AFHTTPRequestOperation *)searchCompaniesWithKeyword:(NSString *)aKeyword
                             page:(int)aPage
                         callback:(GGApiBlock)aCallback;

//MO03:Follow a CompanyBack to top
-(AFHTTPRequestOperation *)followCompanyWithID:(long long)aCompanyID callback:(GGApiBlock)aCallback;

//MO04:Unfollow a CompanyBack to top
-(AFHTTPRequestOperation *)unfollowCompanyWithID:(long long)aCompanyID callback:(GGApiBlock)aCallback;

//MO06:Get Followed CompaniesBack to top
-(AFHTTPRequestOperation *)getFollowedCompaniesWithPage:(int)aPage callback:(GGApiBlock)aCallback;

//3.Get a update detail
-(AFHTTPRequestOperation *)getCompanyUpdateDetailWithNewsID:(long long)aNewsID callback:(GGApiBlock)aCallback;

//OC01:Get Company ContactsBack to top
//GET
///svc/company/<orgid>/contacts, e,g, /svc/company/1399794/contacts
-(AFHTTPRequestOperation *)getCompanyPeopleWithOrgID:(long long)anOrgID
                      pageNumber:(NSUInteger)aPageNumber
                        callback:(GGApiBlock)aCallback;

//OT01:Get Company CompetitorsBack to top
//GET
///svc/company/<orgid>/competitors, e,g, /svc/company/1399794/competitors
-(AFHTTPRequestOperation *)getSimilarCompaniesWithOrgID:(long long)anOrgID
                         pageNumber:(NSUInteger)aPageNumber
                           callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)getRecommendedCompanieWithPage:(long long)aPageNumber callback:(GGApiBlock)aCallback;
@end
