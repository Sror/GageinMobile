//
//  GGEnvSwicher.m
//  Gagein
//
//  Created by Dong Yiming on 7/2/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGEnvSwicher.h"
#import "GGAppDelegate.h"

@implementation GGEnvSwicher
DEF_SINGLETON(GGEnvSwicher)

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setCurrentPathWithEnv:kGGServerProduction];
    }
    return self;
}

-(void)setCurrentPathWithEnv:(EGGServerEnvironment)aEnvironment
{
    _currentEnv = aEnvironment;
    
    switch (aEnvironment)
    {
        case kGGServerProduction:
        {
            _currentPath = GGN_STR_PRODUCTION_SERVER_URL;
        }
            break;
            
        case kGGServerDemo:
        {
            _currentPath = GGN_STR_DEMO_SERVER_URL;
        }
            break;
            
        case kGGServerCN:
        {
            _currentPath = GGN_STR_CN_SERVER_URL;
        }
            break;
            
        case kGGServerStaging:
        {
            _currentPath = GGN_STR_STAGING_SERVER_URL;
        }
            break;
            
        case kGGServerRoshen:
        {
            _currentPath = GGN_STR_ROSHEN_SERVER_URL;
        }
            break;
            
        default:
            break;
    }
}

-(void)switchToEnvironment:(EGGServerEnvironment)aEnvironment
{
    [self setCurrentPathWithEnv:aEnvironment];
    
    [GGSharedDelegate logout];
}

@end
