//
//  GGAgent.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGAgent.h"

@implementation GGAgent

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"agentid"] longLongValue];
    self.type = [[aData objectForKey:@"type"] intValue];
    self.checked = [[aData objectForKey:@"checked"] boolValue];
    self.keywords = [aData objectForKey:@"agent_keywords"];
    self.name = [aData objectForKey:@"agent_name"];
}

@end
