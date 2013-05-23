//
//  GGApi+Member.m
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGApi+Config.h"

@implementation GGApi(Config)

#pragma mark - Agent
//3. get agent list (New API)
-(AFHTTPRequestOperation *)getAgents:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"config/sales_trigger/list";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//4.Select/unselect agents     (New API)
//POST:config/sales_trigger/save
//Parameter: agentid=1&agentid=2&agentid=3
//agentid:all of the checked id
-(AFHTTPRequestOperation *)selectAgents:(NSArray *)aAgentIDs callback:(GGApiBlock)aCallback
{
    NSAssert(aAgentIDs.count, @"u must provide at lest 1 agent id");
    //POST
    NSString *path = @"config/sales_trigger/save";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:aAgentIDs forKey:@"agentid"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//5. add custom agent (New API)
//POST: config/filters/custom_agent/add
//Parameter: name=Agent name&keywords=Agent keywords
-(AFHTTPRequestOperation *)addCustomAgentWithName:(NSString *)aName
                     keywords:(NSString *)aKeyword
                     callback:(GGApiBlock)aCallback
{
    //POST
    NSString *path = @"config/filters/custom_agent/add";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:aName forKey:@"name"];
    [parameters setObject:aKeyword forKey:@"keywords"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//6.update custom agent (New API)
//POST: config/filters/custom_agent/<id>/update
//Parameter: name=Agent name&keywords=Agent keywords.
-(AFHTTPRequestOperation *)updateCustomAgentWithID:(long long)aAgentID
                          name:(NSString *)aName
                      keywords:(NSString *)aKeyword
                      callback:(GGApiBlock)aCallback
{
    //POST
    NSString *path = [NSString stringWithFormat:@"config/filters/custom_agent/%lld/update", aAgentID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:aName forKey:@"name"];
    [parameters setObject:aKeyword forKey:@"keywords"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//7.delete custom agent (New API)
//GET: config/filters/custom_agent/<id>/delete
-(AFHTTPRequestOperation *)deleteCustomAgentWithID:(long long)aAgentID
                      callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"config/filters/custom_agent/%lld/delete", aAgentID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

#pragma mark - Functional Area
//8.get functional areas list     (New API)
//GET:config/functional_area/list
//Parameter:functional_areaid=1010&functional_areaid=1020
-(AFHTTPRequestOperation *)getFunctionalAreas:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"config/functional_area/list";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//9. select/unselect functional areas (New API)
//POST:config/functional_area/save
-(AFHTTPRequestOperation *)selectFunctionalAreas:(NSArray *)aAreaIDs callback:(GGApiBlock)aCallback
{
    NSAssert(aAreaIDs.count, @"u must provide at lest 1 area id");
    //POST
    NSString *path = @"config/functional_area/save";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:aAreaIDs forKey:@"functional_areaid"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}


#pragma mark - 
//  doRequest("GET", "config/filters/agent/list","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)getAgentFiltersList:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"config/filters/agent/list";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//  doRequest("POST", "config/filters/agent/enable/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)setAgentFilterEnabled:(BOOL)anEnabled callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"config/filters/agent/enable/%@", (anEnabled ? @"true" : @"false")];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//  doRequest("POST", "config/filters/agent/2/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");

-(AFHTTPRequestOperation *)selectAgentFilterWithID:(long long)aFilterID selected:(BOOL)aSelected callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = [NSString stringWithFormat:@"config/filters/agent/%lld/%@", aFilterID, (aSelected ? @"true" : @"false")];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//
//  doRequest("GET", "config/filters/category/list","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)getCategoryFiltersList:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"config/filters/category/list";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//  doRequest("POST", "config/filters/category/enable/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)setCategoryFilterEnabled:(BOOL)anEnabled callback:(GGApiBlock)aCallback
{
    NSString *path = [NSString stringWithFormat:@"config/filters/category/enable/%@", (anEnabled ? @"true" : @"false")];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//  doRequest("POST", "config/filters/category/1/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)selectCategoryFilterWithID:(long long)aFilterID selected:(BOOL)aSelected callback:(GGApiBlock)aCallback
{
    NSString *path = [NSString stringWithFormat:@"config/filters/category/%lld/%@", aFilterID, (aSelected ? @"true" : @"false")];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//  doRequest("POST", "config/filters/media/enable/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)setMediaFilterEnabled:(BOOL)anEnabled callback:(GGApiBlock)aCallback
{
    NSString *path = [NSString stringWithFormat:@"config/filters/media/enable/%@", (anEnabled ? @"true" : @"false")];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//  doRequest("GET", "config/filters/media/list","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)getMediaFiltersList:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"config/filters/media/list";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//  doRequest("POST", "config/filters/media/131/delete","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)deleteMediaFilterWithID:(long long)aFilterID callback:(GGApiBlock)aCallback
{
    NSString *path = [NSString stringWithFormat:@"config/filters/media/%lld/delete", aFilterID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//  doRequest("POST", "config/filters/media/add","access_token=b4790223c67f68b744d6ac3bb9b830e6&media_name=Washington Blade");
-(AFHTTPRequestOperation *)addMediaFilterWithID:(long long)aMediaID callback:(GGApiBlock)aCallback
{
    NSString *path = @"config/filters/media/add";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:__LONGLONG(aMediaID) forKey:@"media_id"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

-(AFHTTPRequestOperation *)addMediaFilterWithIDs:(NSArray *)aMediaIDs callback:(GGApiBlock)aCallback
{
    NSString *path = @"config/filters/media/add";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    for (NSNumber *ID in aMediaIDs)
    {
        [parameters setObject:ID forKey:@"media_id"];
    }
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//  doRequest("GET", "config/filters/media/suggested/list","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)getMediaSuggestedList:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"config/filters/media/suggested/list";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//  doRequest("POST", "config/filters/media/search","access_token=b4790223c67f68b744d6ac3bb9b830e6&q=ga");
-(AFHTTPRequestOperation *)searchMediaWithKeyword:(NSString *)aKeyword callback:(GGApiBlock)aCallback
{
    NSString *path = @"config/filters/media/search";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:aKeyword forKey:@"q"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

#pragma mark - update profile API
#define PATH_CHANGE_PROFILE     @"member/me/info/update"

-(AFHTTPRequestOperation *)changeProfileWithFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName callback:(GGApiBlock)aCallback
{
    //NSString *path = @"member/me/info/update";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:aFirstName forKey:@"mem_first_name"];
    [parameters setObject:aLastName forKey:@"mem_last_name"];
    
    return [self _execPostWithPath:PATH_CHANGE_PROFILE params:parameters callback:aCallback];
}

-(AFHTTPRequestOperation *)changeProfileWithEmail:(NSString *)aEmail callback:(GGApiBlock)aCallback
{
    //NSString *path = @"member/me/info/update";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:aEmail forKey:@"mem_email"];
    
    return [self _execPostWithPath:PATH_CHANGE_PROFILE params:parameters callback:aCallback];
}

-(AFHTTPRequestOperation *)changeProfileWithTitle:(NSString *)aTitle callback:(GGApiBlock)aCallback
{
    //NSString *path = @"member/me/info/update";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:aTitle forKey:@"mem_org_title"];
    
    return [self _execPostWithPath:PATH_CHANGE_PROFILE params:parameters callback:aCallback];
}

-(AFHTTPRequestOperation *)changeProfileWithTimezone:(NSString *)aTimezone callback:(GGApiBlock)aCallback
{
    //NSString *path = @"member/me/info/update";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:aTimezone forKey:@"mem_add_timezone"];
    
    return [self _execPostWithPath:PATH_CHANGE_PROFILE params:parameters callback:aCallback];
}

-(AFHTTPRequestOperation *)changeProfileWithOrgID:(long long)anOrgID callback:(GGApiBlock)aCallback
{
    //NSString *path = @"me/info/update";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:__LONGLONG(anOrgID) forKey:@"orgid"];
    
    return [self _execPostWithPath:PATH_CHANGE_PROFILE params:parameters callback:aCallback];
}

-(AFHTTPRequestOperation *)changeProfileWithOrgName:(NSString *)anOrgName callback:(GGApiBlock)aCallback
{
    //NSString *path = @"me/info/update";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:anOrgName forKey:@"org_name"];
    
    return [self _execPostWithPath:PATH_CHANGE_PROFILE params:parameters callback:aCallback];
}

///me/info/update

//          @FormParam("mem_first_name") String mem_first_name,
//          @FormParam("mem_last_name") String mem_last_name,
//          @FormParam("mem_email") String mem_email,
//          @FormParam("mem_org_title") String mem_org_title,
//          @FormParam("mem_add_timezone") String mem_add_timezone,
//          @FormParam("orgid") String orgid,
//          @FormParam("org_name") String org_name

@end
