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
-(AFHTTPRequestOperation *)getMenuByType:(NSString *)aType callback:(GGApiBlock)aCallback
{
    if (GGSharedRuntimeData.accessToken == nil) {
        return nil;
    }
    
    //GET
    NSString *path = @"member/me/tracker/menu";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:aType forKey:@"type"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//2.tracker event
//GET: /member/me/event/tracker
//Parameters:
//Get company events:orgid=xxx&pageflag=0&pagetime=0&eventid=0
//xxx is the id value, if the value is -10,return the all result.
-(AFHTTPRequestOperation *)getHappeningsWithCompanyID:(long long)aCompanyID  eventID:(long long)anEventID
                         pageFlag:(EGGPageFlag)aPageFlag
                         pageTime:(long long)aPageTime
                         callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/event/tracker";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__LONGLONG(anEventID) forKey:@"eventid"];
    [parameters setObjectIfNotNil:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
    
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aCompanyID] forKey:@"orgid"];
    [parameters setObjectIfNotNil:@"text" forKey:@"msg_format"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//Get people events:  contactid=xxx&pageflag=0&pagetime=0&eventid=0
-(AFHTTPRequestOperation *)getHappeningsWithPersonID:(long long)aPersonID eventID:(long long)anEventID
                         pageFlag:(EGGPageFlag)aPageFlag
                         pageTime:(long long)aPageTime
                         callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/event/tracker";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__LONGLONG(anEventID) forKey:@"eventid"];
    [parameters setObjectIfNotNil:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
    
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aPersonID] forKey:@"contactid"];
    [parameters setObjectIfNotNil:@"text" forKey:@"msg_format"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//Get funcational area events: functional_areaid=xxx&pageflag=0&pagetime=0&eventid=0
-(AFHTTPRequestOperation *)getHappeningsWithFunctionalAreaID:(long long)anAreaID eventID:(long long)anEventID
                        pageFlag:(EGGPageFlag)aPageFlag
                        pageTime:(long long)aPageTime
                        callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/event/tracker";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__LONGLONG(anEventID) forKey:@"eventid"];
    [parameters setObjectIfNotNil:[NSNumber numberWithInt:aPageFlag] forKey:@"pageflag"];
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
    
    [parameters setObjectIfNotNil:[NSNumber numberWithLongLong:anAreaID] forKey:@"functional_areaid"];
    [parameters setObjectIfNotNil:@"text" forKey:@"msg_format"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//4.Get a company event detail
//GET:company/event/{eventid}/detail
-(AFHTTPRequestOperation *)getCompanyEventDetailWithID:(long long)anEventID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"company/event/%lld/detail", anEventID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:@"text" forKey:@"msg_format"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//5.get a people event detail
//GET:contact/event/{eventid}/detail
-(AFHTTPRequestOperation *)getPeopleEventDetailWithID:(long long)anEventID callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"contact/event/%lld/detail", anEventID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:@"text" forKey:@"msg_format"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//MU01:Save an UpdateBack to top
//POST
///svc/member/me/update/save
-(AFHTTPRequestOperation *)saveUpdateWithID:(long long)anUpdateID callback:(GGApiBlock)aCallback
{
    //POST
    NSString *path = @"member/me/update/save";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__LONGLONG(anUpdateID) forKey:@"newsid"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//MU02:Unsave an UpdateBack to top
//POST
///svc/member/me/update/unsave
-(AFHTTPRequestOperation *)unsaveUpdateWithID:(long long)anUpdateID callback:(GGApiBlock)aCallback
{
    //POST
    NSString *path = @"member/me/update/unsave";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__LONGLONG(anUpdateID) forKey:@"newsid"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//MU03:Get Saved UpdatesBack to top
//POST
//
///svc/member/me/update/get_saved
-(AFHTTPRequestOperation *)getSaveUpdatesWithPageIndex:(int)aPageIndex
                          isUnread:(BOOL)aIsUnread
                          callback:(GGApiBlock)aCallback
{
    if (GGSharedRuntimeData.accessToken == nil) {
        return nil;
    }
    
    //POST
    NSString *path = @"member/me/update/get_saved";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__INT(aPageIndex) forKey:@"page"];
    [parameters setObjectIfNotNil:(aIsUnread ? @"unread" : @"all") forKey:@"type"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//SU01:Search UpdatesBack to top
//POST
//
///svc/search/updates
-(AFHTTPRequestOperation *)searchForCompanyUpdatesWithKeyword:(NSString *)aKeyword
                                pageIndex:(NSUInteger)aPageIndex
                                 callback:(GGApiBlock)aCallback
{
    //POST
    NSString *path = @"search/updates";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__INT(aPageIndex) forKey:@"page"];
    [parameters setObjectIfNotNil:aKeyword forKey:@"q"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//SU04:Get Keywords Suggestion for UpdatesBack to top
//POST
///svc/search/updates/get_suggestions
-(AFHTTPRequestOperation *)getUpdateSuggestionWithKeyword:(NSString *)aKeyword
                                 callback:(GGApiBlock)aCallback
{
    //POST
    NSString *path = @"search/updates/get_suggestions";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:aKeyword forKey:@"q"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

@end
