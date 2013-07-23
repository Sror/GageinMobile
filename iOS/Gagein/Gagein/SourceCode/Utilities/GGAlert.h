//
//  OTSAlert.h
//  OneStore
//
//  Created by Yim Daniel on 13-1-16.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;

@interface GGAlert : NSObject

+(void)alertWithApiParser:(GGApiParser *)aParser;
+(void)alertWithApiMessage:(NSString *)aMessage;

+(void)alertWithMessage:(NSString *)aMessage;
+(void)alertWithMessage:(NSString *)aMessage title:(NSString *)aTitle;

+(void)alertNetError;
+(void)alertCancelOK:(NSString *)aMessage delegate:(id)aDelegate;
+(void)alertCancelOK:(NSString *)aMessage  title:(NSString *)aTitle  delegate:(id)aDelegate;
+(void)alertErrorForParser:(GGApiParser *)aParser;

#pragma mark - warnings
+(void)showWarning:(NSString *)aTitle message:(NSString *)aMessage;

+(MBProgressHUD *)showCheckMarkHUDWithText:(NSString *)aText inView:(UIView *)aView;
+(MBProgressHUD *)showHUDWithCustomView:(UIView*)aCustomView text:(NSString *)aText inView:(UIView *)aView;

+(MBProgressHUD *)showLoadingHUDInView:(UIView *)aView;

+(MBProgressHUD *)showLoadingHUDWithOffsetY:(float)aOffsetY inView:(UIView *)aView;
+(MBProgressHUD *)showLoadingHUDWithOffset:(CGSize)aOffset inView:(UIView *)aView;

+(MBProgressHUD *)showLoadingHUDWithOffset:(CGSize)aOffset
                                     title:(NSString *)aTitle
                                   message:(NSString *)aMessage
                                    inView:(UIView *)aView;

+(MBProgressHUD *)showLoadingHUDWithTitle:(NSString *)aTitle inView:(UIView *)aView;

+(MBProgressHUD *)showLoadingHUDWithMessage:(NSString *)aMessage inView:(UIView *)aView;

+(MBProgressHUD *)showToast:(NSString *)aMessage inView:(UIView *)aView;

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
    , kGGMsgCodeBillingCantFollowMorePeople = 20002             // user reaches the max limitation for people he can follow
    , kGGMsgCodeBillingCantAccessUpdateNeedPay = 20003         // user need to pay for further access
    , kGGMsgCodeBillingCantAccessUpdateNeedUpgrade = 20004      // user need to upgrad for further access
    , kGGMsgCodeBillingExceededQuota = 20005                   // user reaches the limitation of his plan
    , kGGMsgCodeBillingCantSaveAnyMoreUpdate = 20006           // user reaches the limitation for updates he can save
    , kGGMsgCodeBillingFreeCantFollowGradeC = 20007
    
    // company
    , kGGMsgCodeCompanyAlreadyFollowed = 30001          // company has already been followed
    , kGGMsgCodeCompanyNotFollowed = 30002              // company has not benn followed yet
    , kGGMsgCodeCompanyBuzExists = 30003                // N/A FOR IOS
    , kGGMsgCodeCompanyWebConnectFailed = 30004           // N/A FOR IOS
    , kGGMsgCodeCompanyCantFollowGradeB = 30007
    , kGGMsgCodeCompanyFollowedGradC = 30008
    , kGGMsgCodeCompanyGradeBNoUpdate = 30009           // not_updates_for_the_grade_b_company
    , kGGMsgCodeCompanyGradeCNoUpdate = 30010           // not_updates_for_the_grade_c_company
    
    // people
    , kGGMsgCodeMemberProfileLoadError  = 31001          // member's profile cant be found in database
    , kGGMsgCodePeopleNotFound          = 31002          // people not found in database
    , kGGMsgCodePeopleNotFollowed       = 31003          // not_follow_the_contact
    
    // updates
    , kGGMsgCodeNoUpdateForLessFollowedCompanies = 32001   // Empty Page Message No.2
    , kGGMsgCodeNoUpdateForMoreFollowedCompanies = 32002          // Empty Page Message No.3
    , kGGMsgCodeNoUpdateForAllSalesTriggers      = 32003          // Empty Page Message No.1
    , kGGMsgCodeNoUpdateForTheCompany            = 32004          // Empty Page Message No.5 & No.7
    , kGGMsgCodeNoUpdateTheSaleTrigger           = 32005           // Empty Page Message No.??? -- no update for a specific agent
    , kGGMsgCodeNoUpdateTheUnfollowedCompany     = 32006           // Empty Page Message No.8
    , kGGMsgCodeNoUpdateTheUnavailableCompany    = 32007           // Empty Page Message No.9
    
    // events
    , kGGMsgCodeNoEventForLessFollowedCompanies = 33001    // Empty Page Message No.4
    , kGGMsgCodeNoEventForMoreFollowedCompanies = 33002           // Empty Page Message No.4
    , kGGMsgCodeNoEventForTheCompany            = 33003          // Empty Page Message No.6 & No.10
    , kGGMsgCodeNoEventForLessFollowedContacts  = 33004            // Empty Page Message No.12
    , kGGMsgCodeNoEventForMoreFollowedContacts  = 33005            // Empty Page Message No.13
    , kGGMsgCodeNoEventForTheContact            = 33006            // Empty Page Message No.14
    , kGGMsgCodeNoEventForTheAllSelectedFunctionals  = 33007       // Empty Page Message No.11
    , kGGMsgCodeNoEventForTheFunctional              = 33008       // Empty Page Message No.??? -- no happening for a specific func area
    
    // saved updates/searches
//#warning TODO: search keywords need to be saved locally
    , kGGMsgCodeSavedSearchDoesNotExist = 34001             // N/A FOR IOS
    , kGGMsgCodeUpdateNotSaved                              // N/A FOR IOS
    , kGGMsgCodeTagNameCreated                              // N/A FOR IOS
    , kGGMsgCodeNoSavedUpdates                              // no saved update
    
    // social network
    , kGGMsgCodeSnShareUpdateError = 40001                  // failed sharing an update
    , kGGMsgCodeSnShareEventError                           // failed sharing a happening

    , kGGMsgCodeSnLinkedInAccountDisconnected               // try to send a message to a linkedIn contact, but not connected
    , kGGMsgCodeSnCantGetUserInfo                           // failed to get user info using social account
    , kGGMsgCodeSnSaleforceCantAuth                         // salesforce_account_edition_cannot_authorize_actions = "40005"
    
    // crm
    , kGGMsgCodeCrmAlreadyConnected = 80001               // N/A FOR IOS
    
}EGGMessageCode;
