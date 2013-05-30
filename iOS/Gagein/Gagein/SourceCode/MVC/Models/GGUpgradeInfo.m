//
//  GGUpgradeInfo.m
//  Gagein
//
//  Created by Dong Yiming on 5/29/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGUpgradeInfo.h"

@implementation GGUpgradeInfo

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    _version = [aData objectForKey:@"version"];
    
    NSArray *descriptions = [aData objectForKey:@"description"];
    _features =  (descriptions.count <= 0) ? nil : [NSMutableArray arrayWithArray:descriptions];
    
    _url = [aData objectForKey:@"upgrade_url"];
}

-(NSString *)upgradeTitle
{
    return [NSString stringWithFormat:@"There is a new version available, %@, would you like to upgrade?", [GGUtils appVersionBuild]];
}

-(NSString *)upgradeMessage
{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"What's new in version %@:", _version];
    for (int i = 0; i < _features.count; i++)
    {
        [str appendFormat:@"\n%d. %@", i + 1, _features[i]];
    }
    
    return str;
}

-(BOOL)needUpgrade
{
    NSString *localVersion = [GGUtils appVersion];
    NSArray *localVersionNums = [localVersion componentsSeparatedByString:@"."];
    NSArray *latestVersionNums = [_version componentsSeparatedByString:@"."];
    
    //EGGVersionNumberIndex index = kGGVersionNumIdxMajor;
    for (int i = kGGVersionNumIdxMajor; i < localVersionNums.count; i++)
    {
        NSString *localNum = [localVersionNums objectAtIndexSafe:i];
        NSString *latestNum = [latestVersionNums objectAtIndexSafe:i];
        if (localNum.intValue < latestNum.intValue)
        {
            return YES;
        }
    }
    
    return NO;
}

@end
