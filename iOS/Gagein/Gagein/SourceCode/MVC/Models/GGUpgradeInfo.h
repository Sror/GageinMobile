//
//  GGUpgradeInfo.h
//  Gagein
//
//  Created by Dong Yiming on 5/29/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

typedef enum {
    kGGVersionNumIdxMajor = 0
    , kGGVersionNumIdxMinor
    , kGGVersionNumIdxRevision
}EGGVersionNumberIndex;

@interface GGUpgradeInfo : GGDataModel
@property (copy)    NSString        *version;
@property (strong)  NSMutableArray  *features;
@property (copy)    NSString        *url;


-(BOOL)needUpgrade;

-(NSString *)upgradeTitle;
-(NSString *)upgradeMessage;

@end
