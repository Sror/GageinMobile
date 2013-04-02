//
//  GGMember.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPerson.h"

@class GGMemberPlan;

@interface GGMember : GGPerson <NSCoding>
@property (assign)  int         timeZone;
@property (copy)    NSString    *accessToken;
@property (strong)  GGMemberPlan *plan;
@end
