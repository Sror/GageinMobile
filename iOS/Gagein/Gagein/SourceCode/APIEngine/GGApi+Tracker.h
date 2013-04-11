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
-(void)getMenuByType:(NSString *)aType callback:(GGApiBlock)aCallback;

//4.Get a company event detail
-(void)getCompanyEventDetailWithID:(long long)anEventID callback:(GGApiBlock)aCallback;

//5.get a people event detail
-(void)getPeopleEventDetailWithID:(long long)anEventID callback:(GGApiBlock)aCallback;

//2.tracker company event
-(void)getHappeningsWithCompanyID:(long long)aCompanyID
                         pageFlag:(EGGPageFlag)aPageFlag
                         pageTime:(long long)aPageTime
                         callback:(GGApiBlock)aCallback;

//2.tracker people event
-(void)getHappeningsWithPersonID:(long long)aPersonID
                        pageFlag:(EGGPageFlag)aPageFlag
                        pageTime:(long long)aPageTime
                        callback:(GGApiBlock)aCallback;

//2.tracker function area event
-(void)getHappeningsWithFunctionalAreaID:(long long)anAreaID
                                pageFlag:(EGGPageFlag)aPageFlag
                                pageTime:(long long)aPageTime
                                callback:(GGApiBlock)aCallback;

@end
