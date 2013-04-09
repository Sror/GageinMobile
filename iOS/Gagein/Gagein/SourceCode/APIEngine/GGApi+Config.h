//
//  GGApi+Member.h
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGApi(Config)

#pragma mark - Agent
//3. get agent list (New API)
-(void)getMyAgentsList:(GGApiBlock)aCallback;
-(void)selectAgents:(NSArray *)aAgentIDs callback:(GGApiBlock)aCallback;

@end
