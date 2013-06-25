//
//  GGCompetitorCache.h
//  Gagein
//
//  Created by Dong Yiming on 6/24/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGCache.h"
#import "GGDataModel.h"


//
@interface GGCompetitors : GGDataModel
@property (strong)  NSArray *competitors;

+(id)instanceWithCompetitors:(NSArray *)aCompetitors companyID:(long long)aCompanyID;
@end


//
@interface GGCompetitorCache : GGCache
-(GGCompetitors *)competitorsWithCompanyID:(long long)aCompanyID;
@end
