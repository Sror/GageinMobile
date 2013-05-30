//
//  NSMutableArray+AddOn.m
//  Gagein
//
//  Created by Dong Yiming on 5/22/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "NSMutableArray+AddOn.h"

@implementation NSArray (AddOn)

-(id)objectAtIndexSafe:(NSUInteger)index
{
    if (index < self.count)
    {
        return self[index];
    }
    
    return nil;
}

@end

@implementation NSMutableArray (AddOn)


-(void)addObjectIfNotNil:(id)anObject
{
    if (anObject)
    {
        [self addObject:anObject];
    }
}

@end
