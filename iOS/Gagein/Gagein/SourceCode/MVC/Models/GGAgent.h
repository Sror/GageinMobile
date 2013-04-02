//
//  GGAgent.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

@interface GGAgent : GGDataModel
@property (assign)  int         type;
@property (copy)    NSString    *agentID;
@property (copy)    NSString    *name;
@property (copy)    NSString    *keywords;
@end
