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
-(void)getAgents:(GGApiBlock)aCallback;

//4.Select/unselect agents     (New API)
-(void)selectAgents:(NSArray *)aAgentIDs callback:(GGApiBlock)aCallback;

//5. add custom agent (New API)
-(void)addCustomAgentWithName:(NSString *)aName
                     keywords:(NSString *)aKeyword
                     callback:(GGApiBlock)aCallback;

//6.update custom agent (New API)
-(void)updateCustomAgentWithID:(long long)aAgentID
                          name:(NSString *)aName
                      keywords:(NSString *)aKeyword
                      callback:(GGApiBlock)aCallback;

//7.delete custom agent (New API)
-(void)deleteCustomAgentWithID:(long long)aAgentID
                      callback:(GGApiBlock)aCallback;

#pragma mark - Functional Area
//8.get functional areas list     (New API)
-(void)getFunctionalAreas:(GGApiBlock)aCallback;

//9. select/unselect functional areas (New API)
-(void)selectFunctionalAreas:(NSArray *)aAreaIDs callback:(GGApiBlock)aCallback;

//X03:Get Filter OptionsBack to top
-(void)getConfigFilterOptions:(GGApiBlock)aCallback;

@end
