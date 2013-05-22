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
                  callback:(GGApiBlock)aCallback;

// ------- get user info ------
-(void)snGetUserInfoLinedInWithToken:(NSString *)aToken secret:(NSString *)aSecret callback:(GGApiBlock)aCallback;

-(void)snGetUserInfoFacebookWithToken:(NSString *)aToken callback:(GGApiBlock)aCallback;

-(void)snGetUserInfoSalesforceWithToken:(NSString *)aToken
                              accountID:(NSString *)anAccountID
                           refreshToken:(NSString *)aRefreshToken
                            instanceURL:(NSString *)anInstanceURL callback:(GGApiBlock)aCallback;

-(void)snGetUserInfoTwitterWithToken:(NSString *)aToken secret:(NSString *)aSecret callback:(GGApiBlock)aCallback;


// ---- get list ---
-(void)snGetList:(GGApiBlock)aCallback;


// -------- save --------------
-(void)snSaveLinedInWithToken:(NSString *)aToken secret:(NSString *)aSecret callback:(GGApiBlock)aCallback;

-(void)snSaveFacebookWithToken:(NSString *)aToken callback:(GGApiBlock)aCallback;

-(void)snSaveSalesforceWithToken:(NSString *)aToken
                       accountID:(NSString *)anAccountID
                    refreshToken:(NSString *)aRefreshToken
                     instanceURL:(NSString *)anInstanceURL callback:(GGApiBlock)aCallback;

-(void)snSaveTwitterWithToken:(NSString *)aToken secret:(NSString *)aSecret callback:(GGApiBlock)aCallback;

// ------- share ------
-(void)snShareNewsWithID:(long long)aNewsID
                  snType:(EGGSnType)aSnType
                 message:(NSString *)aMessage
                headLine:(NSString *)aHeadLine
                 summary:(NSString *)aSummary
              pictureURL:(NSString *)aPictureURL callback:(GGApiBlock)aCallback;

-(void)snShareComanyEventWithID:(long long)anEventID
                         snType:(EGGSnType)aSnType
                        message:(NSString *)aMessage callback:(GGApiBlock)aCallback;

-(void)snSharePersonEventWithID:(long long)anEventID
                         snType:(EGGSnType)aSnType
                        message:(NSString *)aMessage callback:(GGApiBlock)aCallback;

@end
