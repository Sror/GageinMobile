//
//  GGApi+OAuth.h
//  Gagein
//
//  Created by Dong Yiming on 5/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kGGSnTypeFacebook = 1
    , kGGSnTypeLinkedIn = 2
    , kGGSnTypeTwitter = 3
    , kGGSnTypeSalesforce = 101
    , kGGSnTypeYammer = 102
} EGGSnType;


@interface GGApi (OAuth)

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
                  callback:(GGApiBlock)aCallback;

// ------- get user info ------
-(AFHTTPRequestOperation *)snGetUserInfoLinedInWithToken:(NSString *)aToken secret:(NSString *)aSecret callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)snGetUserInfoFacebookWithToken:(NSString *)aToken callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)snGetUserInfoSalesforceWithToken:(NSString *)aToken
                              accountID:(NSString *)anAccountID
                           refreshToken:(NSString *)aRefreshToken
                            instanceURL:(NSString *)anInstanceURL callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)snGetUserInfoTwitterWithToken:(NSString *)aToken secret:(NSString *)aSecret callback:(GGApiBlock)aCallback;


// ---- get list ---
-(AFHTTPRequestOperation *)snGetList:(GGApiBlock)aCallback;


// -------- save --------------
-(AFHTTPRequestOperation *)snSaveLinedInWithToken:(NSString *)aToken secret:(NSString *)aSecret callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)snSaveFacebookWithToken:(NSString *)aToken callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)snSaveSalesforceWithToken:(NSString *)aToken
                       accountID:(NSString *)anAccountID
                    refreshToken:(NSString *)aRefreshToken
                     instanceURL:(NSString *)anInstanceURL callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)snSaveTwitterWithToken:(NSString *)aToken secret:(NSString *)aSecret callback:(GGApiBlock)aCallback;

// ------- share ------
-(AFHTTPRequestOperation *)snShareNewsWithID:(long long)aNewsID
                  snType:(EGGSnType)aSnType
                 message:(NSString *)aMessage
                headLine:(NSString *)aHeadLine
                 summary:(NSString *)aSummary
              pictureURL:(NSString *)aPictureURL callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)snShareComanyEventWithID:(long long)anEventID
                         snType:(EGGSnType)aSnType
                        message:(NSString *)aMessage callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)snSharePersonEventWithID:(long long)anEventID
                         snType:(EGGSnType)aSnType
                        message:(NSString *)aMessage callback:(GGApiBlock)aCallback;


//7.get the status of importing companies from salesforce or linkedin.
//#warning TODO: need use the API - getCompanyImportStatusWithType
//-(AFHTTPRequestOperation *)getCompanyImportStatusWithType:(EGGSnType)aSnType callback:(GGApiBlock)aCallback;


//1.import companies from linkedin/salesforce
//#warning TODO: need use the API - importCompaniesWithType
-(AFHTTPRequestOperation *)importCompaniesWithType:(EGGSnType)aSnType callback:(GGApiBlock)aCallback;

@end
