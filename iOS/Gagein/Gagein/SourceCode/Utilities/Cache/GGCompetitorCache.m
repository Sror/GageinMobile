//
//  GGCompetitorCache.m
//  Gagein
//
//  Created by Dong Yiming on 6/24/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGCompetitorCache.h"

//
@implementation GGCompetitors

+(id)instanceWithCompetitors:(NSArray *)aCompetitors companyID:(long long)aCompanyID
{
    if (aCompanyID)
    {
        GGCompetitors * instance = [GGCompetitors model];
        instance.competitors = aCompetitors;
        instance.ID = aCompanyID;
        return instance;
    }
    
    return nil;
}

@end


//
@implementation GGCompetitorCache

-(BOOL)object:(id)anObject isTheSameWith:(id)anotherObject
{
    return ((GGCompetitors *)anObject).ID == ((GGCompetitors *)anotherObject).ID;
}

-(GGCompetitors *)competitorsWithCompanyID:(long long)aCompanyID
{
    for (GGCompetitors *competitors in _cache)
    {
        if (competitors.ID == aCompanyID)
        {
            return competitors;
        }
    }
    
    return nil;
}

@end
