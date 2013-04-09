//
//  GGAPITest.m
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGAPITest.h"

@implementation GGAPITest
DEF_SINGLETON(GGAPITest)

-(void)run
{
    [self _testGetMyAgentsList];
}

-(void)_testGetMyAgentsList
{
    [GGSharedAPI getMyAgentsList:^(id operation, id aResultObject, NSError *anError) {
        
    }];
}

-(void)_testSelectAgentIDs
{
    [GGSharedAPI selectAgents:[NSArray arrayWithObjects:__INT(1), __INT(2), nil] callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

-(void)_testGetCompanyOverviewWithID
{
    [GGSharedAPI getCompanyOverviewWithID:1399794 needSocialProfile:YES callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

@end
