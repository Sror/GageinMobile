//
//  GGNApiClient.m
//  GageinApp
//
//  Created by dong yiming on 13-3-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGNApi.h"

#define APP_CODE_KEY        @"appcode"
#define APP_CODE_VALUE      @"09ad5d624c0294d1"
#define ACCESS_TOKEN_KEY    @"access_token"
#define ACCESS_TOKEN_VALUE  @"4d861dfe219170e3c58c7031578028a5"

@implementation GGNApi

+ (GGNApi *)sharedApi
{
    
    static dispatch_once_t pred;
    static GGNApi *_sharedApi = nil;
    
    dispatch_once(&pred, ^{ _sharedApi = [[self alloc] initWithBaseURL:[NSURL URLWithString:GGN_STR_API_BASE_URL]]; });
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


//www.gagein.com/svc/company/1399794/info?appcode=09ad5d624c0294d1&access_token=4d861dfe219170e3c58c7031578028a5&include_sp=true
-(void)getCompanyInfoWithID:(long)aCompanyID includeSp:(BOOL)aIsIncludeSp callback:(GGNApiBlock)aCallback
{
    NSString *path = [NSString stringWithFormat:@"company/%ld/info", aCompanyID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:ACCESS_TOKEN_VALUE forKey:ACCESS_TOKEN_KEY];
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

@end
