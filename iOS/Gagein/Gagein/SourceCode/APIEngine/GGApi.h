//
//  GGNApi.h
//  GageinApp
//
//  Created by dong yiming on 13-3-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_CODE_KEY        @"appcode"
#define APP_CODE_VALUE      @"09ad5d624c0294d1"
#define ACCESS_TOKEN_KEY    @"access_token"
#define ACCESS_TOKEN_VALUE  @"4d861dfe219170e3c58c7031578028a5"

typedef void(^GGApiBlock)(id operation, id aResultObject, NSError* anError);

@interface GGApi : AFHTTPClient

// singleton method to get a shared api all over the app
+ (GGApi *)sharedApi;

-(void)getCompanyInfoWithID:(long)aCompanyID includeSp:(BOOL)aIsIncludeSp callback:(GGApiBlock)aCallback;

//login
-(void)loginWithEmail:(NSString *)anEmail password:(NSString *)aPassword callback:(GGApiBlock)aCallback;
@end

#define GGSharedAPI [GGApi sharedApi]
