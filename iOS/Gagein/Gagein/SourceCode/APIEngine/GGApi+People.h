//
//  GGApi+People.h
//  Gagein
//
//  Created by dong yiming on 13-4-26.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGApi (People)

//SC01:Search ContactsBack to top
-(AFHTTPRequestOperation *)searchPeopleWithKeyword:(NSString *)aKeyword
                          page:(int)aPage
                      callback:(GGApiBlock)aCallback;

//MC01:Follow ContactBack to top
-(AFHTTPRequestOperation *)followPersonWithID:(long long)aPersonID callback:(GGApiBlock)aCallback;

//MC02:UnFollow ContactBack to top
-(AFHTTPRequestOperation *)unfollowPersonWithID:(long long)aPersonID callback:(GGApiBlock)aCallback;


//C01:Contact OverviewBack to top
-(AFHTTPRequestOperation *)getPersonOverviewWithID:(long long)aPersonID callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)getMyOverview:(GGApiBlock)aCallback;

//2.send upgrade link
//#warning TODO: use the API - sendUpgradeLink
-(AFHTTPRequestOperation *)sendUpgradeLink:(GGApiBlock)aCallback;

//4. get suggested contacts when search contacts.
#warning TODO: use the API - getSuggestedPeopleWithKeyword
-(AFHTTPRequestOperation *)getSuggestedPeopleWithKeyword:(NSString *)aKeyword
                                                    page:(int)aPage
                                                callback:(GGApiBlock)aCallback;

//5.get followed
#warning TODO: use the API - getFollowedPeople
-(AFHTTPRequestOperation *)getFollowedPeople:(GGApiBlock)aCallback;

//6.get recommended contacts for follow
#warning TODO: use the API - getRecommendedPeople
-(AFHTTPRequestOperation *)getRecommendedPeople:(GGApiBlock)aCallback;

@end
