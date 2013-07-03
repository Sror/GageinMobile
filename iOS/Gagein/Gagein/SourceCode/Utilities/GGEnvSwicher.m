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



@end
