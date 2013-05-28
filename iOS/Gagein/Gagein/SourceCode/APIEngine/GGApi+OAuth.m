//
//  GGApi+OAuth.m
//  Gagein
//
//  Created by Dong Yiming on 5/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGApi+OAuth.h"


@implementation GGApi (OAuth)

//1.get user info by access token
//
//GET:/svc/socialnetwork/get_userinfo
//
//Parameters:
//
//@QueryParam("sn_type") String sn_type,
//
//@QueryParam("sn_token") String sn_token,
//
//@QueryParam("sn_secret") String sn_secret,
//
//@QueryParam("sn_account_id") String sn_account_id, //only for salesforce
//
//@QueryParam("sn_refresh_token") String sn_refresh_token, //only for salesforce
//
//@QueryParam("sn_instance_url") String sn_instance_url //only for salesforce
//
//Sn_type defined:
//
//public static final int FACEBOOK = 1;
//
//public static final int LINKEDIN = 2;
//
//public static final int TWITTER = 3;
//
//public static final int SALESFORCE = 101;
//
//public static final int YAMMER = 102;
//
-(AFHTTPRequestOperation *)snGetUserInfoLinedInWithToken:(NSString *)aToken secret:(NSString *)aSecret callback:(GGApiBlock)aCallback
{
    return [self snGetUserInfoWithType:kGGSnTypeLinkedIn token:aToken secret:aSecret sfAccountID:nil sfRefreshToken:nil sfInstanceURL:nil callback:aCallback];
}

-(AFHTTPRequestOperation *)snGetUserInfoFacebookWithToken:(NSString *)aToken callback:(GGApiBlock)aCallback
{
    return [self snGetUserInfoWithType:kGGSnTypeFacebook token:aToken secret:nil sfAccountID:nil sfRefreshToken:nil sfInstanceURL:nil callback:aCallback];
}

-(AFHTTPRequestOperation *)snGetUserInfoSalesforceWithToken:(NSString *)aToken
                       accountID:(NSString *)anAccountID
                    refreshToken:(NSString *)aRefreshToken
                     instanceURL:(NSString *)anInstanceURL callback:(GGApiBlock)aCallback
{
    return [self snGetUserInfoWithType:kGGSnTypeSalesforce token:aToken secret:nil sfAccountID:anAccountID sfRefreshToken:aRefreshToken sfInstanceURL:anInstanceURL callback:aCallback];
}

-(AFHTTPRequestOperation *)snGetUserInfoTwitterWithToken:(NSString *)aToken secret:(NSString *)aSecret callback:(GGApiBlock)aCallback
{
    return [self snGetUserInfoWithType:kGGSnTypeTwitter token:aToken secret:aSecret sfAccountID:nil sfRefreshToken:nil sfInstanceURL:nil callback:aCallback];
}

-(AFHTTPRequestOperation *)snGetUserInfoWithType:(EGGSnType)aSnType
                       token:(NSString *)aSnToken
                      secret:(NSString *)aSnSecret
                 sfAccountID:(NSString *)aSfAccountID
              sfRefreshToken:(NSString *)aSfRefreshToken
               sfInstanceURL:(NSString *)aSfInstanceUrl
                    callback:(GGApiBlock)aCallback
{
    // GET
    NSString *path = @"socialnetwork/get_userinfo";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__INT(aSnType) forKey:@"sn_type"];
    [parameters setObjectIfNotNil:aSnToken forKey:@"sn_token"];
    [parameters setObjectIfNotNil:aSnSecret forKey:@"sn_secret"];
    
    if (aSnType == kGGSnTypeSalesforce) {
        [parameters setObjectIfNotNil:aSfAccountID forKey:@"sn_account_id"];
        [parameters setObjectIfNotNil:aSfRefreshToken forKey:@"sn_refresh_token"];
        [parameters setObjectIfNotNil:aSfInstanceUrl forKey:@"sn_instance_url"];
    }
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

//
//
//2.register
//
//POST:/svc/register
//
//Parameters:
//
//@FormParam("mem_email") String mem_email,
//
//@FormParam("mem_password") String mem_password,
//
//@FormParam("mem_first_name") String mem_first_name,
//
//@FormParam("mem_last_name") String mem_last_name,
//
//@FormParam("sn_type") String sn_type,
//
//@FormParam("sn_token") String sn_token,
//
//@FormParam("sn_secret") String sn_secret,
//
//@FormParam("sn_refresh_token") String sn_refresh_token, //only for salesforce
//
//@FormParam("sn_instance_url") String sn_instance_url, //only for salesforce
//
//@FormParam("sn_first_name") String sn_first_name,
//
//@FormParam("sn_last_name") String sn_last_name,
//
//@FormParam("sn_email") String sn_email,
//
//@FormParam("sn_account_id") String sn_account_id,
//
//@FormParam("sn_account_name") String sn_account_name,
//
//@FormParam("sn_profile_url") String sn_profile_url
//


-(AFHTTPRequestOperation *)snRegisterWithEmail:(NSString *)aEmail
                  password:(NSString *)aPassword
                 firstName:(NSString *)aFirstName
                  lastName:(NSString *)aLastName
                    snType:(EGGSnType)aSnType
                     token:(NSString *)aSnToken
                    secret:(NSString *)aSnSecret
               snAccountID:(NSString *)aSnAccountID
               snFirstName:(NSString *)aSnFirstName
                snLastName:(NSString *)aSnLastName
                   snEmail:(NSString *)aSnEmail
             snAccountName:(NSString *)aSnAccountName
              snProfileURL:(NSString *)aSNProfileURL
            sfRefreshToken:(NSString *)aSfRefreshToken
             sfInstanceURL:(NSString *)aSfInstanceUrl
                  callback:(GGApiBlock)aCallback
{
    NSString *path = @"register";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    [parameters setObjectIfNotNil:aEmail forKey:@"mem_email"];
    [parameters setObjectIfNotNil:aPassword forKey:@"mem_password"];
    [parameters setObjectIfNotNil:aFirstName forKey:@"mem_first_name"];
    [parameters setObjectIfNotNil:aLastName forKey:@"mem_last_name"];
    
    [parameters setObjectIfNotNil:__INT(aSnType) forKey:@"sn_type"];
    [parameters setObjectIfNotNil:aSnToken forKey:@"sn_token"];
    [parameters setObjectIfNotNil:aSnSecret forKey:@"sn_secret"];
    [parameters setObjectIfNotNil:aSnAccountID forKey:@"sn_account_id"];
    [parameters setObjectIfNotNil:aSnFirstName forKey:@"sn_first_name"];
    [parameters setObjectIfNotNil:aSnLastName forKey:@"sn_last_name"];
    [parameters setObjectIfNotNil:aSnEmail forKey:@"sn_email"];
    [parameters setObjectIfNotNil:aSnAccountName forKey:@"sn_account_name"];
    [parameters setObjectIfNotNil:aSNProfileURL forKey:@"sn_profile_url"];
    
    if (aSnType == kGGSnTypeSalesforce) {
        [parameters setObjectIfNotNil:aSfRefreshToken forKey:@"sn_refresh_token"];
        [parameters setObjectIfNotNil:aSfInstanceUrl forKey:@"sn_instance_url"];
    }
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//
//3.save accesstoken
//
//POST: /svc/socialnetwork/save_sn_info
//
//Parameters:             @FormParam("access_token") String access_token,
//
//@FormParam("sn_type") String sn_type,
//
//@FormParam("sn_token") String sn_token,
//
//@FormParam("sn_secret") String sn_secret,
//
//@FormParam("sn_account_id") String sn_account_id,  //only for salesforce
//
//@FormParam("sn_refresh_token") String sn_refresh_token, //only for salesforce
//
//@FormParam("sn_instance_url") String sn_instance_url //only for salesforce
//
-(AFHTTPRequestOperation *)snSaveLinedInWithToken:(NSString *)aToken secret:(NSString *)aSecret callback:(GGApiBlock)aCallback
{
    return [self snSaveWithType:kGGSnTypeLinkedIn token:aToken secret:aSecret sfAccountID:nil sfRefreshToken:nil sfInstanceURL:nil callback:aCallback];
}

-(AFHTTPRequestOperation *)snSaveFacebookWithToken:(NSString *)aToken callback:(GGApiBlock)aCallback
{
    return [self snSaveWithType:kGGSnTypeFacebook token:aToken secret:nil sfAccountID:nil sfRefreshToken:nil sfInstanceURL:nil callback:aCallback];
}

-(AFHTTPRequestOperation *)snSaveSalesforceWithToken:(NSString *)aToken
                       accountID:(NSString *)anAccountID
                    refreshToken:(NSString *)aRefreshToken
                     instanceURL:(NSString *)anInstanceURL callback:(GGApiBlock)aCallback
{
    return [self snSaveWithType:kGGSnTypeSalesforce token:aToken secret:nil sfAccountID:anAccountID sfRefreshToken:aRefreshToken sfInstanceURL:anInstanceURL callback:aCallback];
}

-(AFHTTPRequestOperation *)snSaveTwitterWithToken:(NSString *)aToken secret:(NSString *)aSecret callback:(GGApiBlock)aCallback
{
    return [self snSaveWithType:kGGSnTypeTwitter token:aToken secret:aSecret sfAccountID:nil sfRefreshToken:nil sfInstanceURL:nil callback:aCallback];
}

-(AFHTTPRequestOperation *)snSaveWithType:(EGGSnType)aSnType
                token:(NSString *)aSnToken
               secret:(NSString *)aSnSecret
          sfAccountID:(NSString *)aSfAccountID
       sfRefreshToken:(NSString *)aSfRefreshToken
        sfInstanceURL:(NSString *)aSfInstanceUrl
             callback:(GGApiBlock)aCallback
{
    NSString *path = @"socialnetwork/save_sn_info";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__INT(aSnType) forKey:@"sn_type"];
    [parameters setObjectIfNotNil:aSnToken forKey:@"sn_token"];
    
    [parameters setObjectIfNotNil:aSnSecret forKey:@"sn_secret"];
    
    if (aSnType == kGGSnTypeSalesforce) {
        [parameters setObjectIfNotNil:aSfAccountID forKey:@"sn_account_id"];
        [parameters setObjectIfNotNil:aSfRefreshToken forKey:@"sn_refresh_token"];
        [parameters setObjectIfNotNil:aSfInstanceUrl forKey:@"sn_instance_url"];
    }
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}


//
//
//4.get linked socialnetwork list
//
//GET: /svc/socialnetwork//linked/list
//
//Parameters: @QueryParam("access_token") String access_token
//
//
-(AFHTTPRequestOperation *)snGetList:(GGApiBlock)aCallback
{
    // GET
    NSString *path = @"socialnetwork/linked/list";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}


//
//
//
//5.share a update
//
//POST:/me/update/{newsid}/share
//
//Parameters:                   @FormParam("access_token") String access_token,
//
//@PathParam("newsid") String newsid,
//
//@FormParam("sn_type") Set<String> sn_types,
//
//@FormParam("message") String message, //input by user
//
//@FormParam("title") String title,  //news headline
//
//@FormParam("summary") String summary,//truncated by news_content,news_textview
//
//@FormParam("picture") String picture //picture url
//
-(AFHTTPRequestOperation *)snShareNewsWithID:(long long)aNewsID
                  snType:(EGGSnType)aSnType
               message:(NSString *)aMessage
              headLine:(NSString *)aHeadLine
               summary:(NSString *)aSummary
            pictureURL:(NSString *)aPictureURL callback:(GGApiBlock)aCallback
{
    NSString *path = [NSString stringWithFormat:@"member/me/update/%lld/share", aNewsID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__INT(aSnType) forKey:@"sn_type"];
    [parameters setObjectIfNotNil:aMessage forKey:@"message"];
    [parameters setObjectIfNotNil:aHeadLine forKey:@"title"];
    [parameters setObjectIfNotNil:aSummary forKey:@"summary"];
    
    [parameters setObjectIfNotNil:aPictureURL forKey:@"picture"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}

//
//
//6.share a company event
//
//POST: /me/company/event/{eventid}/share
//
//Parameters:                     @FormParam("access_token") String access_token,
//
//@PathParam("eventid") String eventid,
//
//@FormParam("message") String message, //input by user
//
//@FormParam("sn_type") Set<String> sn_types
//
//
-(AFHTTPRequestOperation *)snShareComanyEventWithID:(long long)anEventID
                  snType:(EGGSnType)aSnType
                 message:(NSString *)aMessage callback:(GGApiBlock)aCallback
{
    NSString *path = [NSString stringWithFormat:@"member/me/company/event/%lld/share", anEventID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__INT(aSnType) forKey:@"sn_type"];
    [parameters setObjectIfNotNil:aMessage forKey:@"message"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}


//
//
//
//6.share a contact event
//
//POST: /me/contact/event/{eventid}/share
//
//Parameters:                     @FormParam("access_token") String access_token,
//
//@PathParam("eventid") String eventid,
//
//@FormParam("message") String message, //input by user
//
//@FormParam("sn_type") Set<String> sn_types
-(AFHTTPRequestOperation *)snSharePersonEventWithID:(long long)anEventID
                         snType:(EGGSnType)aSnType
                        message:(NSString *)aMessage callback:(GGApiBlock)aCallback
{
    NSString *path = [NSString stringWithFormat:@"member/me/contact/event/%lld/share", anEventID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__INT(aSnType) forKey:@"sn_type"];
    [parameters setObjectIfNotNil:aMessage forKey:@"message"];
    
    return [self _execPostWithPath:path params:parameters callback:aCallback];
}


//7.get the status of importing companies from salesforce or linkedin.
//GET:/svc/socialnetwork/company/import_status
//Parameters: access_token=b4790223c67f68b744d6ac3bb9b830e6&sn_type=2
//Result: {"status":"1","msg":"ok","data":{"proc_status":2}}
//proc_status 的值： public final static int NOT_EXIST = 0;  //不存在这个任务
//public final static int PROCESSING = 1; //正在处理
//public final static int SUCCESS = 2;   //处理完了，并且成功了
//public final static int ERROR = 3;  //处理完了，但是失败了。
-(AFHTTPRequestOperation *)getCompanyImportStatusWithType:(EGGSnType)aSnType callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"socialnetwork/company/import_status";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__LONGLONG(aSnType) forKey:@"sn_type"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}


//1.import companies from linkedin/salesforce
//GET: svc/socialnetwork/import_companies
//Parameters: access_token=b4790223c67f68b744d6ac3bb9b830e6&sn_type=2
-(AFHTTPRequestOperation *)importCompaniesWithType:(EGGSnType)aSnType callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"socialnetwork/import_companies";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObjectIfNotNil:[GGUtils appcodeString] forKey:APP_CODE_KEY];
    [parameters setObjectIfNotNil:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObjectIfNotNil:__LONGLONG(aSnType) forKey:@"sn_type"];
    
    return [self _execGetWithPath:path params:parameters callback:aCallback];
}

@end
