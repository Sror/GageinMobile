//
//  GGNApiClient.m
//  GageinApp
//
//  Created by dong yiming on 13-3-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGApi.h"

#define APP_CODE_KEY        @"appcode"
#define ACCESS_TOKEN_KEY    @"access_token"

@implementation GGApi

+(NSString *)apiBaseUrl
{
    return [NSString stringWithFormat:@"%@/svc/", CURRENT_SERVER_URL];
}

+ (GGApi *)sharedApi
{
    
    static dispatch_once_t pred;
    static GGApi *_sharedApi = nil;
    
    dispatch_once(&pred, ^{ _sharedApi = [[self alloc] initWithBaseURL:[NSURL URLWithString:[self apiBaseUrl]]]; });
    return _sharedApi;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"text/json"];
    
    return self;
}

-(void)canceAllOperations
{
    [self.operationQueue cancelAllOperations];
}


//www.gagein.com/svc/company/1399794/info?appcode=09ad5d624c0294d1&access_token=4d861dfe219170e3c58c7031578028a5&include_sp=true
-(void)getCompanyInfoWithID:(long)aCompanyID includeSp:(BOOL)aIsIncludeSp callback:(GGApiBlock)aCallback
{
    NSString *path = [NSString stringWithFormat:@"company/%ld/info", aCompanyID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:(aIsIncludeSp ? @"true" : @"false") forKey:@"include_sp"];
    
    
    [self getPath:path
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (aCallback) {
                  aCallback(operation, responseObject, nil);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (aCallback) {
                  aCallback(operation, nil, error);
              }
          }];
}

#pragma mark - signup
-(void)loginWithEmail:(NSString *)anEmail password:(NSString *)aPassword callback:(GGApiBlock)aCallback
{
    NSString *path = @"login";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:anEmail forKey:@"mem_email"];
    [parameters setObject:aPassword forKey:@"mem_password"];
    
    [self postPath:path
        parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               
               if (aCallback) {
                   aCallback(operation, responseObject, nil);
               }
               
               
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (aCallback) {
            aCallback(operation, nil, error);
        }
        
    }];
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
    
    [self postPath:path
        parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               
               if (aCallback) {
                   aCallback(operation, responseObject, nil);
               }
               
               
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               
               if (aCallback) {
                   aCallback(operation, nil, error);
               }
               
           }];
}

@end
