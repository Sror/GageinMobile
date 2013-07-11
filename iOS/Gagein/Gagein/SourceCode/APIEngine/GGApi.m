//
//  GGNApiClient.m
//  GageinApp
//
//  Created by dong yiming on 13-3-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGApi.h"
#import "YRDropdownView.h"

//static AFNetworkReachabilityStatus s_netStatus = AFNetworkReachabilityStatusUnknown;

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
    
    //UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    GGApi *this = self;
    [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //s_netStatus = status;
        
        [this _tellUserIfNoConnection];
        
    }];
    
    return self;
}

-(void)_tellUserIfNoConnection
{
    if (self.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [GGAlert showWarning:@"No internet connection" message:nil];
            
        });
    }
}

-(void)canceAllOperations
{
    [self.operationQueue cancelAllOperations];
}

#pragma mark - internal
-(void)_logRawResponse:(id)anOperation
{
    AFHTTPRequestOperation *httpOp = anOperation;
    
    if (!httpOp.isCancelled
        && httpOp.responseString.length <= 0
        && self.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable)
    {
        [GGAlert showWarning:@"Network Error" message:nil];
        [self postNotification:GG_NOTIFY_HIDE_ALL_LOADING_HUD];
    }
    
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

-(AFHTTPRequestOperation *)_execGetWithPath:(NSString *)aPath params:(NSDictionary *)aParams callback:(GGApiBlock)aCallback
{
    [self _tellUserIfNoConnection];
    
    AFHTTPRequestOperation *operation = [self getPath:aPath
       parameters:aParams
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [self _handleResult:responseObject operation:operation error:nil callback:aCallback];
              [self postNotification:GG_NOTIFY_API_OPERATION_SUCCESS withObject:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              [self _handleResult:nil operation:operation error:error callback:aCallback];
              [self postNotification:GG_NOTIFY_API_OPERATION_FAILED withObject:operation];
          }];
    
    return operation;
}

-(AFHTTPRequestOperation *)_execPostWithPath:(NSString *)aPath params:(NSDictionary *)aParams callback:(GGApiBlock)aCallback
{
    [self _tellUserIfNoConnection];
    
    AFHTTPRequestOperation *operation = [self postPath:aPath
        parameters:aParams
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               
               [self _handleResult:responseObject operation:operation error:nil callback:aCallback];
               [self postNotification:GG_NOTIFY_API_OPERATION_SUCCESS withObject:operation];
               
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               
               [self _handleResult:nil operation:operation error:error callback:aCallback];
               [self postNotification:GG_NOTIFY_API_OPERATION_FAILED withObject:operation];
           }];
    
    return operation;
}


#pragma mark - basic APIs
//1. get client latest version info
//GET: /svc/system/get_version
//Parameters: appcode=78cfc17502a1e05a
//Appcode:
//public static final String APPCODE_SF = "a7dca5b5cc6b94e5";  // sf - Salesforce CRM
//public static final String APPCODE_FU = "413501848376a54d";  // fu - Oracle Fusion CRM
//public static final String APPCODE_SU = "eb4ed7832822d870";  // su - sugerCRM
//public static final String APPCODE_IPHONE = "78cfc17502a1e05a";  // iphone
//public static final String APPCODE_IPAD = "c0d67d02e7c74d36";  // ipad
-(AFHTTPRequestOperation *)getVersion:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"system/get_version";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

@end
