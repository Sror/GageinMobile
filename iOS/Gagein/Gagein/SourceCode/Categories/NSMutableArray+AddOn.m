//
//  NSMutableArray+AddOn.m
//  Gagein
//
//  Created by Dong Yiming on 5/22/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "NSMutableArray+AddOn.h"

@implementation NSMutableArray (AddOn)
-(id)objectAtIndexSafe:(NSUInteger)index
{
    if (index < self.count)
    {
        return self[index];
    }
    
    return nil;
}

@end
