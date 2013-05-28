//
//  OTSAlert.h
//  OneStore
//
//  Created by Yim Daniel on 13-1-16.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGAlert : NSObject

+(void)alertWithApiMessage:(NSString *)aMessage;

+(void)alertWithMessage:(NSString *)aMessage;
+(void)alertWithMessage:(NSString *)aMessage title:(NSString *)aTitle;

+(void)alertNetError;
+(void)alertCancelOK:(NSString *)aMessage delegate:(id)aDelegate;
+(void)alertCancelOK:(NSString *)aMessage  title:(NSString *)aTitle  delegate:(id)aDelegate;
+(void)alertErrorForParser:(GGApiParser *)aParser;
@end

typedef enum {
    kGGMsgCodeAuthError = 10001         // user login failed
    
    // register
    , kGGMsgCodeRegEmailExists = 11001              // email user entered exists when signing up
    , kGGMsgCodeRegEmailExistsAccountNotConfirmed   // N/A FOR IOS
    , kGGMsgCodeRegEmailInvalid                     // email format invalid
    , kGGMsgCodeRegWorkEmailNotEqualAdditional      // user's working email is the same as additional email, which is illegal
    , kGGMsgCodeRegError                            // registration failed
    
    // billing
    , kGGMsgCodeBillingCantFollowMoreCompany = 20001    // user reaches the max limitation for companies he can follow
    , kGGMsgCodeBillingCantFollowMorePeople             // user reaches the max limitation for people he can follow
    , kGGMsgCodeBillingCantAccessUpdateNeedPay          // user need to pay for further access
    , kGGMsgCodeBillingCantAccessUpdateNeedUpgrade      // user need to upgrad for further access
    , kGGMsgCodeBillingExceededQuota                    // user reaches the limitation of his plan
    , kGGMsgCodeBillingCantSaveAnyMoreUpdate            // user reaches the limitation for updates he can save
    
    // company
    , kGGMsgCodeCompanyAlreadyFollowed = 30001          // company has already been followed
    , kGGMsgCodeCompanyNotFollowed                      // company has not benn followed yet
    , kGGMsgCodeCompanyBuzExists                        // N/A FOR IOS
    , kGGMsgCodeCompanyWebConnectFailed                 // N/A FOR IOS
    
    // people
    , kGGMsgCodeMemberProfileLoadError = 31001          // member's profile cant be found in database
    , kGGMsgCodePeopleNotFound                          // people not found in database
    
    // updates
    , kGGMsgCodeNoUpdateForLessFollowedCompanies = 32001   // Empty Page Message No.2
    , kGGMsgCodeNoUpdateForMoreFollowedCompanies           // Empty Page Message No.3
    , kGGMsgCodeNoUpdateForAllSalesTriggers                // Empty Page Message No.1
    , kGGMsgCodeNoUpdateForTheCompany                      // Empty Page Message No.5 & No.7
    , kGGMsgCodeNoUpdateTheSaleTrigger                      // Empty Page Message No.??? -- no update for a specific agent
    , kGGMsgCodeNoUpdateTheUnfollowedCompany                // Empty Page Message No.8
    , kGGMsgCodeNoUpdateTheUnavailableCompany               // Empty Page Message No.9
    
    // events
    , kGGMsgCodeNoEventForLessFollowedCompanies = 33001    // Empty Page Message No.4
    , kGGMsgCodeNoEventForMoreFollowedCompanies            // Empty Page Message No.4
    , kGGMsgCodeNoEventForTheCompany                       // Empty Page Message No.6 & No.10
    , kGGMsgCodeNoEventForLessFollowedContacts              // Empty Page Message No.12
    , kGGMsgCodeNoEventForMoreFollowedContacts              // Empty Page Message No.13
    , kGGMsgCodeNoEventForTheContact                        // Empty Page Message No.14
    , kGGMsgCodeNoEventForTheAllSelectedFunctionals         // Empty Page Message No.11
    , kGGMsgCodeNoEventForTheFunctional                     // Empty Page Message No.??? -- no happening for a specific func area
    
    // saved updates/searches
#warning TODO: search keywords need to be saved locally
    , kGGMsgCodeSavedSearchDoesNotExist = 34001             // N/A FOR IOS
    , kGGMsgCodeUpdateNotSaved                              // N/A FOR IOS
    , kGGMsgCodeTagNameCreated                              // N/A FOR IOS
    , kGGMsgCodeNoSavedUpdates                              // no saved update
    
    // social network
    , kGGMsgCodeSnShareUpdateError = 40001                  // failed sharing an update
    , kGGMsgCodeSnShareEventError                           // failed sharing a happening
#warning BACKLOG:send message to linkedIn account
    , kGGMsgCodeSnLinkedInAccountDisconnected               // try to send a message to a linkedIn contact, but not connected
    , kGGMsgCodeSnCantGetUserInfo                           // failed to get user info using social account
    
    // crm
    , kGGMsgCodeCrmAlreadyConnected = 80001               // N/A FOR IOS
    
}EGGMessageCode;
