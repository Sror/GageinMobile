//
//  GGApi+Tracker.h
//  Gagein
//
//  Created by dong yiming on 13-4-11.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGGStrMenuTypeCompanies     @"companies"
#define kGGStrMenuTypePeople        @"people"

@interface GGApi(Tracker)

//1.Get Menu
//Parameters:type=companies or type=people
-(AFHTTPRequestOperation *)getMenuByType:(NSString *)aType callback:(GGApiBlock)aCallback;

//4.Get a company event detail
-(AFHTTPRequestOperation *)getCompanyEventDetailWithID:(long long)anEventID callback:(GGApiBlock)aCallback;

//5.get a people event detail
-(AFHTTPRequestOperation *)getPeopleEventDetailWithID:(long long)anEventID callback:(GGApiBlock)aCallback;

//2.tracker company event
-(AFHTTPRequestOperation *)getHappeningsWithCompanyID:(long long)aCompanyID  eventID:(long long)anEventID
                         pageFlag:(EGGPageFlag)aPageFlag
                         pageTime:(long long)aPageTime
                         callback:(GGApiBlock)aCallback;

//2.tracker people event
-(AFHTTPRequestOperation *)getHappeningsWithPersonID:(long long)aPersonID  eventID:(long long)anEventID
                        pageFlag:(EGGPageFlag)aPageFlag
                        pageTime:(long long)aPageTime
                        callback:(GGApiBlock)aCallback;

//2.tracker function area event
-(AFHTTPRequestOperation *)getHappeningsWithFunctionalAreaID:(long long)anAreaID  eventID:(long long)anEventID
                                pageFlag:(EGGPageFlag)aPageFlag
                                pageTime:(long long)aPageTime
                                callback:(GGApiBlock)aCallback;

//MU01:Save an UpdateBack to top
//POST
///svc/member/me/update/save
-(AFHTTPRequestOperation *)saveUpdateWithID:(long long)anUpdateID callback:(GGApiBlock)aCallback;

//MU02:Unsave an UpdateBack to top
//POST
///svc/member/me/update/unsave
-(AFHTTPRequestOperation *)unsaveUpdateWithID:(long long)anUpdateID callback:(GGApiBlock)aCallback;

//MU03:Get Saved UpdatesBack to top
//POST
//
///svc/member/me/update/get_saved
-(AFHTTPRequestOperation *)getSaveUpdatesWithPageIndex:(int)aPageIndex
                          isUnread:(BOOL)aIsUnread
                          callback:(GGApiBlock)aCallback;

//SU01:Search UpdatesBack to top
//POST
//
///svc/search/updates
-(AFHTTPRequestOperation *)searchForCompanyUpdatesWithKeyword:(NSString *)aKeyword
                                pageIndex:(NSUInteger)aPageIndex
                                 callback:(GGApiBlock)aCallback;

//SU04:Get Keywords Suggestion for UpdatesBack to top
//POST
///svc/search/updates/get_suggestions
-(AFHTTPRequestOperation *)getUpdateSuggestionWithKeyword:(NSString *)aKeyword
                             callback:(GGApiBlock)aCallback;

//Like
-(AFHTTPRequestOperation *)likeUpdateWithID:(long long)anUpdateID callback:(GGApiBlock)aCallback;

// unlike
-(AFHTTPRequestOperation *)unlikeUpdateWithID:(long long)anUpdateID callback:(GGApiBlock)aCallback;

@end
