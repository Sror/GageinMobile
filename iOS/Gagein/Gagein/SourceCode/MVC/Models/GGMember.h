//
//  GGMember.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPerson.h"

typedef enum {
    kGGSignupProcessAgentsSelect = 1
    , kGGSignupProcessAreasSelect = 2
    , kGGSignupProcessOK = 3
    , kGGSignupProcessOK2 = 4
}EGGSignupProcessStatus;

@class GGMemberPlan;
@class GGAutoLoginInfo;

@interface GGMember : GGPerson <NSCoding>
@property (assign)  int         timeZone;
@property (copy)    NSString    *accessToken;
@property (assign)  int         signupProcessStatus;
@property (copy)    NSString    *accountEmail;
@property (copy)    NSString    *accountPassword;
@property (strong)  GGMemberPlan *plan;

-(BOOL)isSignupOK;
+(GGMember *)memberFromLoginInfo:(GGAutoLoginInfo *)aLoginInfo;

@end
