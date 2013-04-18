//
//  GGImagePool.m
//  Gagein
//
//  Created by dong yiming on 13-4-18.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGImagePool.h"

@implementation GGImagePool
DEF_SINGLETON(GGImagePool)

- (id)init
{
    self = [super init];
    if (self) {
        _placeholder = [UIImage imageNamed:@"placeholder.png"];
    }
    return self;
}


@end
