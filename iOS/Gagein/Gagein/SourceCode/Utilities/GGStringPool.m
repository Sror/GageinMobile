//
//  GGStringPool.m
//  Gagein
//
//  Created by Dong Yiming on 5/30/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGStringPool.h"

@implementation GGStringPool

+(NSString *)stringWithMessageCode:(EGGMessageCode)aMessageCode
{
    switch (aMessageCode)
    {
        case kGGMsgCodeAuthError:
        {
            return @"The email address or password you provided does not match our records. Please try again.";
            //return @"Sorry, our server was unable to process your sign in. Please try again.";
        }
            break;
            
        case kGGMsgCodeRegEmailExists:
        case kGGMsgCodeRegEmailExistsAccountNotConfirmed:
        {
            return @"Sorry, it looks like this email belongs to an existing account. ";
        }
            break;
            
        case kGGMsgCodeRegEmailInvalid:
        {
            return @"This doesn’t look like a valid email. Please try again.";
        }
            break;
            
        case kGGMsgCodeRegWorkEmailNotEqualAdditional:
        {
            return @"This email is already in use. Please try again.";
        }
            break;
            
        case kGGMsgCodeRegError:
        {
            return @"Sorry, our server was unable to process your sign up. Please try again. ";
        }
            break;
            
        case kGGMsgCodeBillingCantFollowMoreCompany:
        {
            return @"Upgrade your account to follow more companies.";
        }
            break;
            
        case kGGMsgCodeBillingCantFollowMorePeople:
        {
            return @"Upgrade your account to follow more people.";
        }
            break;
            
        case kGGMsgCodeBillingCantAccessUpdateNeedPay:
        {
            return @"Upgrade your account to access this information.";
        }
            break;
            
        case kGGMsgCodeBillingCantAccessUpdateNeedUpgrade:
        {
            return @"Upgrade your account to access this information.";
        }
            break;
            
        case kGGMsgCodeBillingExceededQuota:
        {
            return @"Upgrade your account to enable this feature.";
        }
            break;
            
        case kGGMsgCodeBillingCantSaveAnyMoreUpdate:
        {
            return @"Upgrade your account to save more updates.";
        }
            break;
            
        case kGGMsgCodeCompanyAlreadyFollowed:
        {
            return @"You are already following this company.";
        }
            break;
            
        case kGGMsgCodeCompanyNotFollowed:
        {
            return @"Please follow this company first.";
        }
            break;
            
        case kGGMsgCodeCompanyBuzExists:
        {
            return @"";
        }
            break;
            
        case kGGMsgCodeCompanyWebConnectFailed:
        {
            return @"";
        }
            break;
            
        case kGGMsgCodeMemberProfileLoadError:
        {
            return @"Sorry, our server was unable to retrieve your profile. Please try again. ";
        }
            break;
            
        case kGGMsgCodePeopleNotFound:
        {
            return @"Sorry, this person doesn’t seem to exist in our database anymore. ";
        }
            break;
            
        case kGGMsgCodeSavedSearchDoesNotExist:
        {
            return @"";
        }
            break;
            
        case kGGMsgCodeUpdateNotSaved:
        {
            return @"";
        }
            break;
            
        case kGGMsgCodeTagNameCreated:
        {
            return @"";
        }
            break;
            
        case kGGMsgCodeNoSavedUpdates:
        {
            return @"";
        }
            break;
            
        case kGGMsgCodeSnShareUpdateError:
        case kGGMsgCodeSnShareEventError:
        {
            return @"Sorry, our server was unable to share your update. Please try again.";
        }
            break;
            
        case kGGMsgCodeSnLinkedInAccountDisconnected:
        {
            return @"Please link your LinkedIn account to GageIn first.";
        }
            break;
            
        case kGGMsgCodeSnCantGetUserInfo:
        {
            return @"Sorry, our server was unable to link to this account. Please try again.";
        }
            break;
            
        case kGGMsgCodeSnSaleforceCantAuth:
        {
            return @"Salesforce has declined your request to connect, as your current Salesforce account edition does not authorize such actions.";
        }
            break;
            
        case kGGMsgCodeCrmAlreadyConnected:
        {
            return @"";
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

@end

