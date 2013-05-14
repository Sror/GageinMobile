//
//  GGCustomAgentVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGAgent;

@interface GGCustomAgentVC : GGBaseViewController
//@property (assign) long long agentID;
@property (strong) GGAgent      *agent;
@end
