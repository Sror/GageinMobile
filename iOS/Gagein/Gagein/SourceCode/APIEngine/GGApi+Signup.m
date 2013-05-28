//
//  GGApi+Signup.m
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGApi+Signup.h"

@implementation GGApi (Signup)

#pragma mark - signup APIs
-(AFHTTPRequestOperation *)loginWithEmail:(NSString *)anEmail password:(NSString *)aPassword callback:(GGApiBlock)aCallback
{
    NSString *path = @"login";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:anEmail forKey:@"mem_email"];
    [parameters setObjectIfNotNil:aPassword forKey:@"mem_password"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

-(AFHTTPRequestOperation *)retisterWithEmail:(NSString *)anEmail
                password:(NSString *)aPassword
               firstName:(NSString *)aFirstName
                lastName:(NSString *)aLastName
                callback:(GGApiBlock)aCallback
{
    NSString *path = @"register";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:anEmail forKey:@"mem_email"];
    [parameters setObjectIfNotNil:aPassword forKey:@"mem_password"];
    [parameters setObjectIfNotNil:aFirstName forKey:@"mem_first_name"];
    [parameters setObjectIfNotNil:aLastName forKey:@"mem_last_name"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

@end
