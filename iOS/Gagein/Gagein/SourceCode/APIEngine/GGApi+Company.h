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
    kGGPageFlagFirstPage = 0
    , kGGPageFlagMoveDown
    , kGGPageFlagMoveUp
}EGGPageFlag;

typedef enum
{
    kGGCompanyUpdateRelevanceNormal     = 10
    , kGGCompanyUpdateRelevanceHigh     = 20
    , kGGCompanyUpdateRelevanceVeryHigh = 30
    , kGGCompanyUpdateRelevanceHighest  = 40
}EGGCompanyUpdateRelevance;

#define GG_EXPLORING_ID         -10

@interface GGApi (Company)

#pragma mark - company APIs
// get company updates
-(void)getExploringUpdatesWithNewsID:(long long)aNewsID
                          pageFlag:(EGGPageFlag)aPageFlag
                          pageTime:(long long)aPageTime
                         relevance:(EGGCompanyUpdateRelevance)aRelevance
                          callback:(GGApiBlock)aCallback;

// get company updates by company id
-(void)getCompanyUpdatesWithCompanyID:(long long)aCompanyID
                               newsID:(long long)aNewsID
                             pageFlag:(EGGPageFlag)aPageFlag
                             pageTime:(long long)aPageTime
                            relevance:(EGGCompanyUpdateRelevance)aRelevance
                             callback:(GGApiBlock)aCallback;

// get company updates by agent id
-(void)getCompanyUpdatesWithAgentID:(long long)anAgentID
                             newsID:(long long)aNewsID
                           pageFlag:(EGGPageFlag)aPageFlag
                           pageTime:(long long)aPageTime
                          relevance:(EGGCompanyUpdateRelevance)aRelevance
                           callback:(GGApiBlock)aCallback;

//Get Company OverviewBack to top
-(void)getCompanyOverviewWithID:(long long)anOrgID
              needSocialProfile:(BOOL)aNeedSP
                       callback:(GGApiBlock)aCallback;

//SO04:Get Company SuggestionBack to top
-(void)getCompanySuggestionWithKeyword:(NSString *)aKeyword callback:(GGApiBlock)aCallback;

//SO01:Search CompaniesBack to top
-(void)searchCompaniesWithKeyword:(NSString *)aKeyword
                             page:(int)aPage
                         callback:(GGApiBlock)aCallback;

//MO03:Follow a CompanyBack to top
-(void)followCompanyWithID:(long long)aCompanyID callback:(GGApiBlock)aCallback;

//MO04:Unfollow a CompanyBack to top
-(void)unfollowCompanyWithID:(long long)aCompanyID callback:(GGApiBlock)aCallback;

@end
