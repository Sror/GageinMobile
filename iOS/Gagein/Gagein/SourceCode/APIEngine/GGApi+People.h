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
@end
