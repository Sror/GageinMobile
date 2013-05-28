//
//  GGNApi.h
//  GageinApp
//
//  Created by dong yiming on 13-3-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>  

#define APP_CODE_KEY        @"appcode"
#define ACCESS_TOKEN_KEY    @"access_token"

//GET: /member/me/event/tracker --- if the value is -10,return the all result.
#define GG_ALL_RESULT_ID         -10
#define GG_PAGE_START_INDEX         1

typedef void(^GGApiBlock)(id operation, id aResultObject, NSError* anError);

typedef enum
{
    kGGPageFlagFirstPage = 0
    , kGGPageFlagMoveDown
    , kGGPageFlagMoveUp
}EGGPageFlag;

@interface GGApi : AFHTTPClient

// singleton method to get a shared api all over the app
+ (GGApi *)sharedApi;

-(void)canceAllOperations;

-(AFHTTPRequestOperation *)_execPostWithPath:(NSString *)aPath params:(NSDictionary *)aParams callback:(GGApiBlock)aCallback;
-(AFHTTPRequestOperation *)_execGetWithPath:(NSString *)aPath params:(NSDictionary *)aParams callback:(GGApiBlock)aCallback;

#pragma mark - basic APIs
//1. get client latest version info
#warning TODO: need use the API - getVersion
-(AFHTTPRequestOperation *)getVersion:(GGApiBlock)aCallback;

@end

#define GGSharedAPI [GGApi sharedApi]

/////////////////////
#import "GGApi+Company.h"
#import "GGApi+Signup.h"
#import "GGApi+Config.h"
#import "GGApi+Tracker.h"
#import "GGApi+People.h"
#import "GGApi+OAuth.h"