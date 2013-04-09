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
-(void)getMyAgentsList:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"config/sales_trigger/list";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//4.Select/unselect agents     (New API)
//POST:config/sales_trigger/save
//Parameter: agentid=1&agentid=2&agentid=3
//agentid:all of the checked id
-(void)selectAgents:(NSArray *)aAgentIDs callback:(GGApiBlock)aCallback
{
    NSAssert(aAgentIDs.count, @"u must provide at lest 1 agent id");
    //POST
    NSString *path = @"config/sales_trigger/save";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:aAgentIDs forKey:@"agentid"];
    
    [self _execPostWithPath:path params:parameters callback:aCallback];
}

//5. add custom agent (New API)
//POST: config/filters/custom_agent/add
//Parameter: name=Agent name&keywords=Agent keywords
//
//6.update custom agent (New API)
//POST: config/filters/custom_agent/<id>/update
//Parameter: name=Agent name&keywords=Agent keywords.
//
//7.delete custom agent (New API)
//GET: config/filters/custom_agent/<id>/delete
//
//
//Member - Functional Area
//8.get functional areas list     (New API)
//GET:config/functional_area/list
//Parameter:functional_areaid=1010&functional_areaid=1020
//
//
//9. select/unselect functional areas (New API)
//POST:config/functional_area/save

@end
