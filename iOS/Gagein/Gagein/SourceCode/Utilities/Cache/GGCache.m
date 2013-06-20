//
//  GGCache.m
//  Gagein
//
//  Created by Dong Yiming on 6/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGCache.h"

#define DEFAULT_CAPACITY    20
#define DEFAULT_CREDIT      10

@implementation GGCache
{
    NSUInteger          _capacity;
    int                 _credit;
}

- (id)init
{
    self = [super init];
    if (self) {
        _cache = [NSMutableArray array];
        _capacity = DEFAULT_CAPACITY;
        _credit = DEFAULT_CREDIT;
    }
    return self;
}

-(BOOL)object:(id)anObject isTheSameWith:(id)anotherObject
{
    return anObject == anotherObject;
}

-(void)add:(id)anObect
{
    BOOL hasIt = NO;
    
    for (id object in _cache)
    {
        if ([self object:object isTheSameWith:anObect])
        {
            hasIt = YES;
            break;
        }
    }
    
    if (!hasIt)
    {
        [_cache addObjectIfNotNil:anObect];
        
        _credit --;
        if (_credit <= 0)
        {
            [self loseWeight];
        }
    }
}

-(void)remove:(id)anObject
{
    [_cache removeObject:anObject];
}

-(void)setMaxCapacity:(NSUInteger)aCapacity
{
    _capacity = aCapacity;
}

-(void)loseWeight
{
    int count = _cache.count;
    int diff = count - _capacity;
    if (diff > 0)
    {
        //NSMutableArray *newCache = [NSMutableArray arrayWithCapacity:_capacity];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(diff, _capacity)];
        _cache = [NSMutableArray arrayWithArray:[_cache objectsAtIndexes:indexSet]];
//        for (int i = diff - 1; i < count; count ++)
//        {
//            [newCache addObject:_cache[i]];
//        }
//        _cache = newCache;
    }
    
    _credit = DEFAULT_CREDIT;
}

@end



//////
@implementation GGClassCacheBase
{
    
}

-(id)initWithClass:(Class)aClass
{
    self = [super init];
    if (self)
    {
        _class = aClass;
    }
    return self;
}

-(void)add:(id)anObect
{
    if ([anObect isKindOfClass:_class])
    {
        [super add:anObect];
    }
}

@end

