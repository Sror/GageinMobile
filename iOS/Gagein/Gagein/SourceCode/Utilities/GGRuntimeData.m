//
//  GGRuntimeData.m
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGRuntimeData.h"

@implementation GGRuntimeData
DEF_SINGLETON(GGRuntimeData)

-(BOOL)isLoggedIn
{
    return self.accessToken.length;
}

-(BOOL)isFirstRun
{
    return !self.runedBefore;
}
@end
