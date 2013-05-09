//
//  GGAgentGroup.m
//  Gagein
//
//  Created by dong yiming on 13-5-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGAgentFilter.h"

@implementation GGAgentFilter


//{
//    "agentid": "1042",
//    "agent_name": "Iphone Agent",
//    "agent_keywords": "Imac,iphone",
//    "type": 2,
//    "checked": false
//}

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"agentid"] longLongValue];
    self.name = [aData objectForKey:@"agent_name"];
    self.keywords = [aData objectForKey:@"agent_keywords"];
    self.type = [[aData objectForKey:@"type"] intValue];
    self.checked = [[aData objectForKey:@"checked"] boolValue];
    
}

@end

//@implementation GGAgentFiltersGroup
//- (id)init
//{
//    self = [super init];
//    if (self) {
//        _options = [NSMutableArray array];
//    }
//    return self;
//}
//
//-(void)parseWithData:(NSDictionary *)aData
//{
//    [super parseWithData:aData];
//    
//    self.name = [aData objectForKey:@"group_name"];
//    self.enabled = [[aData objectForKey:@"enabled"] boolValue];
//    
//    NSArray *options = [aData objectForKey:@"group_options"];
//    for (id item in options) {
//        GGAgentFilter *agent = [GGAgentFilter model];
//        [agent parseWithData:item];
//        [_options addObject:agent];
//    }
//}
//
//@end
