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
    [self _testGetSaveUpdatesWithPageIndex];
}

-(void)_testGetSaveUpdatesWithPageIndex
{
    [GGSharedAPI getSaveUpdatesWithPageIndex:0 callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

-(void)_testGetCompanyEventDetailWithID
{
    [GGSharedAPI getCompanyEventDetailWithID:5854 callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

-(void)_testGetHappeningsWithFunctionalAreaID
{
    [GGSharedAPI getHappeningsWithFunctionalAreaID:GG_ALL_RESULT_ID pageFlag:kGGPageFlagFirstPage pageTime:0 callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

-(void)_testGetHappeningsWithPersonID
{
    [GGSharedAPI getHappeningsWithPersonID:GG_ALL_RESULT_ID pageFlag:kGGPageFlagFirstPage pageTime:0 callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

-(void)_testGetHappeningsWithCompanyID
{
    [GGSharedAPI getHappeningsWithCompanyID:GG_ALL_RESULT_ID pageFlag:kGGPageFlagFirstPage pageTime:0 callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

-(void)_testGetMemu
{
    [GGSharedAPI getMenuByType:kGGStrMenuTypePeople callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

-(void)_testGetMyAgentsList
{
    [GGSharedAPI getAgents:^(id operation, id aResultObject, NSError *anError) {
        
    }];
}

-(void)_testSelectAgentIDs
{
    [GGSharedAPI selectAgents:[NSArray arrayWithObjects:__INT(1), __INT(2), nil] callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

-(void)_testAddCustomAgent
{
    [GGSharedAPI addCustomAgentWithName:@"steve jobs" keywords:@"steve, jobs" callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

-(void)_testUpdateCustomAgent
{
    [GGSharedAPI updateCustomAgentWithID:1347 name:@"bill gates" keywords:@"bill,gates" callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

-(void)_testDeleteCustomAgent
{
    [GGSharedAPI deleteCustomAgentWithID:1347 callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

//////////////////////////////////////////////////////////////////
-(void)_testGetFunctionalAreas
{
    [GGSharedAPI getFunctionalAreas:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

-(void)_testSelectFunctionalAreas
{
    [GGSharedAPI selectFunctionalAreas:[NSArray arrayWithObjects:__INT(1010), __INT(1020), nil] callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

/////////////////////////////////////////////////////////////////
-(void)_testGetCompanyOverviewWithID
{
    [GGSharedAPI getCompanyOverviewWithID:1399794 needSocialProfile:YES callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

@end
