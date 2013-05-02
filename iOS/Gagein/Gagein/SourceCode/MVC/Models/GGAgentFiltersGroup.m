//
//  GGAgentGroup.m
//  Gagein
//
//  Created by dong yiming on 13-5-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGAgentFiltersGroup.h"

@implementation GGAgentFilter

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.name = [aData objectForKey:@"name"];
    self.checkFlag = [[aData objectForKey:@"check_flag"] boolValue];
    self.IdStr = [aData objectForKey:@"id"];
}

@end

@implementation GGAgentFiltersGroup
- (id)init
{
    self = [super init];
    if (self) {
        _options = [NSMutableArray array];
    }
    return self;
}

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.name = [aData objectForKey:@"group_name"];
    self.enabled = [[aData objectForKey:@"enabled"] boolValue];
    
    NSArray *options = [aData objectForKey:@"group_options"];
    for (id item in options) {
        GGAgentFilter *agent = [GGAgentFilter model];
        [agent parseWithData:item];
        [_options addObject:agent];
    }
}

@end
