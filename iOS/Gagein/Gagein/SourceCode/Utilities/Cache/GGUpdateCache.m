//
//  GGMentionedCompaniesCache.m
//  Gagein
//
//  Created by Dong Yiming on 6/24/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGUpdateCache.h"

#import "GGCompanyUpdate.h"

@implementation GGUpdateCache

-(BOOL)object:(id)anObject isTheSameWith:(id)anotherObject
{
    return ((GGCompanyUpdate *)anObject).ID == ((GGCompanyUpdate *)anotherObject).ID;
}

-(GGCompanyUpdate *)updateWithID:(long long)anUpdateID
{
    for (GGCompanyUpdate *update in _cache)
    {
        if (update.ID == anUpdateID)
        {
            return update;
        }
    }
    
    return nil;
}
@end
