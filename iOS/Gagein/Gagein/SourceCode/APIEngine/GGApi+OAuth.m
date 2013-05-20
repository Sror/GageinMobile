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


-(void)snGetUserInfoWithType:(EGGSnType)aSnType
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
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:__INT(aSnType) forKey:@"sn_type"];
    [parameters setObject:aSnToken forKey:@"sn_token"];
    [parameters setObject:aSnSecret forKey:@"sn_secret"];
    
    if (aSnType == kGGSnTypeSalesforce) {
        [parameters setObject:aSfAccountID forKey:@"sn_account_id"];
        [parameters setObject:aSfRefreshToken forKey:@"sn_refresh_token"];
        [parameters setObject:aSfInstanceUrl forKey:@"sn_instance_url"];
    }
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
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
//
-(void)snRegisterWithEmail:(NSString *)aEmail
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
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:__INT(aSnType) forKey:@"sn_type"];
    [parameters setObject:aSnToken forKey:@"sn_token"];
    [parameters setObject:aSnSecret forKey:@"sn_secret"];
    [parameters setObject:aSnAccountID forKey:@"sn_account_id"];
    [parameters setObject:aSnFirstName forKey:@"sn_first_name"];
    [parameters setObject:aSnAccountID forKey:@"sn_last_name"];
    [parameters setObject:aSnAccountID forKey:@"sn_email"];
    [parameters setObject:aSnAccountID forKey:@"sn_account_name"];
    [parameters setObject:aSnAccountID forKey:@"sn_profile_url"];
    
    if (aSnType == kGGSnTypeSalesforce) {
        [parameters setObject:aSfRefreshToken forKey:@"sn_refresh_token"];
        [parameters setObject:aSfInstanceUrl forKey:@"sn_instance_url"];
    }
    
    [self _execPostWithPath:path params:parameters callback:aCallback];
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
-(void)snSaveLinedInWithToken:(NSString *)aToken secret:(NSString *)aSecret callback:(GGApiBlock)aCallback
{
    return [self snSaveWithType:kGGSnTypeLinkedIn token:aToken secret:aSecret sfAccountID:nil sfRefreshToken:nil sfInstanceURL:nil callback:aCallback];
}

-(void)snSaveWithType:(EGGSnType)aSnType
                token:(NSString *)aSnToken
               secret:(NSString *)aSnSecret
          sfAccountID:(NSString *)aSfAccountID
       sfRefreshToken:(NSString *)aSfRefreshToken
        sfInstanceURL:(NSString *)aSfInstanceUrl
             callback:(GGApiBlock)aCallback
{
    NSString *path = @"socialnetwork/save_sn_info";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:__INT(aSnType) forKey:@"sn_type"];
    [parameters setObject:aSnToken forKey:@"sn_token"];
    [parameters setObject:aSnSecret forKey:@"sn_secret"];
    
    if (aSnType == kGGSnTypeSalesforce) {
        [parameters setObject:aSfAccountID forKey:@"sn_account_id"];
        [parameters setObject:aSfRefreshToken forKey:@"sn_refresh_token"];
        [parameters setObject:aSfInstanceUrl forKey:@"sn_instance_url"];
    }
    
    [self _execPostWithPath:path params:parameters callback:aCallback];
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
-(void)snGetList:(GGApiBlock)aCallback
{
    // GET
    NSString *path = @"socialnetwork/linked/list";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
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
-(void)snShareNewsWithID:(long long)aNewsID
                  snType:(EGGSnType)aSnType
               message:(NSString *)aMessage
              headLine:(NSString *)aHeadLine
               summary:(NSString *)aSummary
            pictureURL:(NSString *)aPictureURL callback:(GGApiBlock)aCallback
{
    NSString *path = [NSString stringWithFormat:@"me/update/%lld/share", aNewsID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:__INT(aSnType) forKey:@"sn_type"];
    [parameters setObject:aMessage forKey:@"message"];
    [parameters setObject:aHeadLine forKey:@"title"];
    [parameters setObject:aSummary forKey:@"summary"];
    [parameters setObject:aPictureURL forKey:@"picture"];
    
    [self _execPostWithPath:path params:parameters callback:aCallback];
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
-(void)snShareComanyEventWithID:(long long)anEventID
                  snType:(EGGSnType)aSnType
                 message:(NSString *)aMessage callback:(GGApiBlock)aCallback
{
    NSString *path = [NSString stringWithFormat:@"me/company/event/%lld/share", anEventID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:__INT(aSnType) forKey:@"sn_type"];
    [parameters setObject:aMessage forKey:@"message"];
    
    [self _execPostWithPath:path params:parameters callback:aCallback];
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
-(void)snSharePersonEventWithID:(long long)anEventID
                         snType:(EGGSnType)aSnType
                        message:(NSString *)aMessage callback:(GGApiBlock)aCallback
{
    NSString *path = [NSString stringWithFormat:@"me/contact/event/%lld/share", anEventID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:__INT(aSnType) forKey:@"sn_type"];
    [parameters setObject:aMessage forKey:@"message"];
    
    [self _execPostWithPath:path params:parameters callback:aCallback];
}


@end
