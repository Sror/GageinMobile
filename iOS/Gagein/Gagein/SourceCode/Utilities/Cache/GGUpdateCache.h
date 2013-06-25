//
//  GGMentionedCompaniesCache.h
//  Gagein
//
//  Created by Dong Yiming on 6/24/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGCache.h"

@interface GGUpdateCache : GGCache
-(GGCompanyUpdate *)updateWithID:(long long)anUpdateID;
@end
