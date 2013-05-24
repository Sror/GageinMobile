//
//  NSString+GGAddOn.m
//  Gagein
//
//  Created by Dong Yiming on 5/24/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "NSString+GGAddOn.h"

@implementation NSString (GGAddOn)

-(NSString *)stringLimitedToLength:(NSUInteger)aLength
{
    if (self.length < aLength)
    {
        return self;
    }
    
    return [[self substringToIndex:aLength] stringByAppendingString:@"..."];
}

@end
