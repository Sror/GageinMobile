//
//  GGApi+Tracker.m
//  Gagein
//
//  Created by dong yiming on 13-4-11.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGApi+Tracker.h"

@implementation GGApi(Tracker)


//1.Get Menu
//GET:/member/me/tracker/menu
//Parameters:type=companies or type=people
//
-(void)getMenuByType:(NSString *)aType callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/tracker/menu";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:aType forKey:@"type"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//2.tracker event
//GET: /member/me/event/tracker
//Parameters:
//Get company events:orgid=xxx&pageflag=0&pagetime=0&eventid=0
//xxx is the id value, if the value is -10,return the all result.
-(void)getHappeningsWithCompanyID:(long long)aCompanyID
                         pageFlag:(EGGPageFlag)aPageFlag
                         pageTime:(long long)aPageTime
                         callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/event/tracker";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:__LONGLONG(0) forKey:@"eventid"];
    [parameters setObject:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
    [parameters setObject:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
    
    [parameters setObject:[NSNumber numberWithLongLong:aCompanyID] forKey:@"orgid"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//Get people events:  contactid=xxx&pageflag=0&pagetime=0&eventid=0
-(void)getHappeningsWithPersonID:(long long)aPersonID
                         pageFlag:(EGGPageFlag)aPageFlag
                         pageTime:(long long)aPageTime
                         callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/event/tracker";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:__LONGLONG(0) forKey:@"eventid"];
    [parameters setObject:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
    [parameters setObject:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
    
    [parameters setObject:[NSNumber numberWithLongLong:aPersonID] forKey:@"contactid"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//Get funcational area events: functional_areaid=xxx&pageflag=0&pagetime=0&eventid=0
-(void)getHappeningsWithFunctionalAreaID:(long long)anAreaID
                        pageFlag:(EGGPageFlag)aPageFlag
                        pageTime:(long long)aPageTime
                        callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/event/tracker";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:__LONGLONG(0) forKey:@"eventid"];
    [parameters setObject:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
    [parameters setObject:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
    
    [parameters setObject:[NSNumber numberWithLongLong:anAreaID] forKey:@"functional_areaid"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//4.Get a company event detail
//GET:company/event/{eventid}/detail
-(void)getCompanyEventDetailWithID:(long long)anEventID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"company/event/%lld/detail", anEventID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//5.get a people event detail
//GET:contact/event/{eventid}/detail
-(void)getPeopleEventDetailWithID:(long long)anEventID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"contact/event/%lld/detail", anEventID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

@end
