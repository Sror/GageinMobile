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

#pragma mark - internal
-(void)_logRawResponse:(id)anOperation
{
    AFHTTPRequestOperation *httpOp = anOperation;
    
    DLog(@"\nRequest:\n%@\n\nRAW DATA:\n%@\n", httpOp.request.URL.absoluteString, httpOp.responseString);
}

-(void)_handleResult:(id)aResultObj
           operation:(id)anOperation
               error:(NSError *)anError
            callback:(GGApiBlock)aCallback
{
    [self _logRawResponse:anOperation];
    
    if (aCallback) {
        aCallback(anOperation, aResultObj, anError);
    }
}

-(void)_execGetWithPath:(NSString *)aPath params:(NSDictionary *)aParams callback:(GGApiBlock)aCallback
{
    [self getPath:aPath
       parameters:aParams
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [self _handleResult:responseObject operation:operation error:nil callback:aCallback];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              [self _handleResult:nil operation:operation error:error callback:aCallback];
    
          }];
}

-(void)_execPostWithPath:(NSString *)aPath params:(NSDictionary *)aParams callback:(GGApiBlock)aCallback
{
    [self postPath:aPath
        parameters:aParams
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               
               [self _handleResult:responseObject operation:operation error:nil callback:aCallback];
               
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               
               [self _handleResult:nil operation:operation error:error callback:aCallback];
               
           }];
}


//www.gagein.com/svc/company/1399794/info?appcode=09ad5d624c0294d1&access_token=4d861dfe219170e3c58c7031578028a5&include_sp=true
-(void)getCompanyInfoWithID:(long)aCompanyID includeSp:(BOOL)aIsIncludeSp callback:(GGApiBlock)aCallback
{
    NSString *path = [NSString stringWithFormat:@"company/%ld/info", aCompanyID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:(aIsIncludeSp ? @"true" : @"false") forKey:@"include_sp"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}






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

#pragma mark - company APIs
-(void)getCompanyUpdatesWithNewsID:(long long)aNewsID
                         pageFlag:(EGGPageFlag)aPageFlag
                         pageTime:(long long)aPageTime
                        relevance:(EGGCompanyUpdateRelevance)aRelevance
                         callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/update/tracker";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:[NSNumber numberWithLongLong:aNewsID] forKey:@"newsid"];
    [parameters setObject:[NSNumber numberWithLongLong:aPageFlag] forKey:@"pageflag"];
    [parameters setObject:[NSNumber numberWithLongLong:aPageTime] forKey:@"pagetime"];
    [parameters setObject:[NSNumber numberWithLongLong:aRelevance] forKey:@"relevance"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}


#pragma mark - Member - Agent
//3. get agent list (New API)
-(void)getMyAgentsList:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/config/sales_trigger/list";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}
//4.Select/unselect agents     (New API)
//POST:/member/me/config/sales_trigger/save
//Parameter: sales_triggerid=1&sales_triggerid=2&sales_triggerid=3
//sales_triggerid:all of the checked id
//
//
//5. add custom agent (New API)
//POST: /member/me/config/filters/custom_agent/add
//Parameter: name=Agent name&keywords=Agent keywords
//
//6.update custom agent (New API)
//POST: /member/me/config/filters/custom_agent/<id>/update
//Parameter: name=Agent name&keywords=Agent keywords.
//
//7.delete custom agent (New API)
//GET: /member/me/config/filters/custom_agent/<id>/delete
//
//
//Member - Functional Area
//8.get functional areas list     (New API)
//GET:/member/me/config/functional_area/list
//Parameter:functional_areaid=1010&functional_areaid=1020
//
//
//9. select/unselect functional areas (New API)
//POST:/member/me/config/functional_area/save

@end
