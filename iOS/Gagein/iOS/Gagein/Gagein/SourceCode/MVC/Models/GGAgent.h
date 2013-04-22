//
//  GGAgent.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

typedef enum {
    kGGAgentTypePredefined = 1
    , kGGAgentTypeCustom = 2
}EGGAgentType;

@interface GGAgent : GGDataModel
@property (assign)  int         type;
@property (assign)  BOOL         checked;
@property (copy)    NSString    *agentID;
@property (copy)    NSString    *name;
@property (copy)    NSString    *keywords;

@end
