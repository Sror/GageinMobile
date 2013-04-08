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


typedef void(^GGApiBlock)(id operation, id aResultObject, NSError* anError);

#define GGSharedAPI [GGApi sharedApi]

@interface GGApi : AFHTTPClient

// singleton method to get a shared api all over the app
+ (GGApi *)sharedApi;

-(void)canceAllOperations;

-(void)_execPostWithPath:(NSString *)aPath params:(NSDictionary *)aParams callback:(GGApiBlock)aCallback;
-(void)_execGetWithPath:(NSString *)aPath params:(NSDictionary *)aParams callback:(GGApiBlock)aCallback;

@end

#import "GGApi+Company.h"
#import "GGApi+Signup.h"
#import "GGApi+Member.h"