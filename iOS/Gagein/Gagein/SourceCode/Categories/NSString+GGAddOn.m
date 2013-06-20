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

-(NSString *)stringSeperatedWith:(NSString *)aSeporator componentsCount:(NSUInteger)aCompCount maxLength:(NSUInteger)aMaxLength
{
    if (aSeporator.length <= 0 || aCompCount <= 0)
    {
        return nil;
    }
    
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *components = [str componentsSeparatedByString:aSeporator];
    
    if (aCompCount > components.count)
    {
        return self;
    }
    
    NSMutableString *resultStr = [NSMutableString string];
    for (int i = 0; i < aCompCount; i++)
    {
        if (i)
        {
            [resultStr appendString:@" "];
        }
        
        NSString *comp = components[i];
        if (resultStr.length + comp.length > aMaxLength)
        {
            break;
        }
        
        [resultStr appendString:comp];
    }
    
    return resultStr;
}

-(BOOL)isCaseInsensitiveEqualToString:(NSString *)aString
{
    return [self.lowercaseString isEqualToString:aString.lowercaseString];
}

@end
