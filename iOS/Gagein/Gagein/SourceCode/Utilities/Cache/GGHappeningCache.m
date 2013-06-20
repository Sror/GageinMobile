//
//  GGHappeningCache.m
//  Gagein
//
//  Created by Dong Yiming on 6/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGHappeningCache.h"

#import "GGHappening.h"

@implementation GGHappeningCache


- (id)init
{
    self = [super initWithClass:[GGHappening class]];
    if (self) {
        //
    }
    return self;
}


-(BOOL)object:(id)anObject isTheSameWith:(id)anotherObject
{
    return ((GGHappening *)anObject).ID == ((GGHappening *)anotherObject).ID;
}

-(GGHappening *)happeningWithID:(long long)aHappeningID
{
    for (GGHappening *happening in _cache)
    {
        if (happening.ID == aHappeningID)
        {
            return happening;
        }
    }
    
    return nil;
}

@end
