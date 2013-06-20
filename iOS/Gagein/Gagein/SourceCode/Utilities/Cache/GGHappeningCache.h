//
//  GGHappeningCache.h
//  Gagein
//
//  Created by Dong Yiming on 6/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGCache.h"

@class GGHappening;

@interface GGHappeningCache : GGClassCacheBase
-(GGHappening *)happeningWithID:(long long)aHappeningID;
@end
