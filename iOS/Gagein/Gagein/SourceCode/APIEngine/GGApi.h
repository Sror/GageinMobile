//
//  GGNApi.h
//  GageinApp
//
//  Created by dong yiming on 13-3-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>       

typedef void(^GGApiBlock)(id operation, id aResultObject, NSError* anError);

@interface GGApi : AFHTTPClient

// singleton method to get a shared api all over the app
+ (GGApi *)sharedApi;

-(void)canceAllOperations;

-(void)getCompanyInfoWithID:(long)aCompanyID includeSp:(BOOL)aIsIncludeSp callback:(GGApiBlock)aCallback;

//login
-(void)loginWithEmail:(NSString *)anEmail password:(NSString *)aPassword callback:(GGApiBlock)aCallback;

// register
-(void)retisterWithEmail:(NSString *)anEmail
                password:(NSString *)aPassword
               firstName:(NSString *)aFirstName
                lastName:(NSString *)aLastName
                callback:(GGApiBlock)aCallback;
@end

#define GGSharedAPI [GGApi sharedApi]
