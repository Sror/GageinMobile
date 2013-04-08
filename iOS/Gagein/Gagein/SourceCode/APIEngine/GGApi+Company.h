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


@interface GGApi (Company)

#pragma mark - company APIs
// get company updates
-(void)getCompanyUpdatesWithNewsID:(long long)aNewsID
                          pageFlag:(EGGPageFlag)aPageFlag
                          pageTime:(long long)aPageTime
                         relevance:(EGGCompanyUpdateRelevance)aRelevance
                          callback:(GGApiBlock)aCallback;

@end
