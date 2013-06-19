//
//  GGTagetActionPair.m
//  Gagein
//
//  Created by Dong Yiming on 6/19/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGTagetActionPair.h"

@implementation GGTagetActionPair

+(GGTagetActionPair *)pairWithTaget:(id)aTarget action:(SEL)anAction
{
    GGTagetActionPair *instance = [[GGTagetActionPair alloc] init];
    instance.target = aTarget;
    instance.action = anAction;
    
    return instance;
}

@end
