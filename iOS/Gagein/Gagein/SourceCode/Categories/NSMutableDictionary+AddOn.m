//
//  NSMutableDictionary+AddOn.m
//  Gagein
//
//  Created by Dong Yiming on 5/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "NSMutableDictionary+AddOn.h"

@implementation NSMutableDictionary (AddOn)

-(void)setObjectIfNotNil:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject)
    {
        [self setObject:anObject forKey:aKey];
    }
}
@end
