//
//  GGSocialProfile.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSocialProfile.h"

@implementation GGSocialProfile

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.type = [aData objectForKey:@"type"];
    self.url = [aData objectForKey:@"url"];
    self.hasProfileUrl = [[aData objectForKey:@"hasProfileUrl"] boolValue];
}

@end
