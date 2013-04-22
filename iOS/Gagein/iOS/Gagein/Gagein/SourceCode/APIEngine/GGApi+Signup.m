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
-(void)loginWithEmail:(NSString *)anEmail password:(NSString *)aPassword callback:(GGApiBlock)aCallback
{
    NSString *path = @"login";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:anEmail forKey:@"mem_email"];
    [parameters setObject:aPassword forKey:@"mem_password"];
    
    [self _execPostWithPath:path params:parameters callback:aCallback];
}

-(void)retisterWithEmail:(NSString *)anEmail
                password:(NSString *)aPassword
               firstName:(NSString *)aFirstName
                lastName:(NSString *)aLastName
                callback:(GGApiBlock)aCallback
{
    NSString *path = @"register";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:anEmail forKey:@"mem_email"];
    [parameters setObject:aPassword forKey:@"mem_password"];
    [parameters setObject:aFirstName forKey:@"mem_first_name"];
    [parameters setObject:aLastName forKey:@"mem_last_name"];
    
    [self _execPostWithPath:path params:parameters callback:aCallback];
}

@end
