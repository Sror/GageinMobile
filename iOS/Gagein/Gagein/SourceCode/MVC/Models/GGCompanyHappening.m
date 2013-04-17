//
//  GGCompanyHappening.m
//  Gagein
//
//  Created by dong yiming on 13-4-17.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyHappening.h"

#define SOURCE_TEXT_LINKEDIN  @"Linkedin"
#define SOURCE_TEXT_CRUNCHBASE  @"CrunchBase"
#define SOURCE_TEXT_YAHOO  @"Yahoo"
#define SOURCE_TEXT_HOOVERS  @"Hoovers"

#define CHANGE_TYPE_JOIN  @"JOIN"
#define CHANGE_TYPE_LEFT  @"LEAVE"

/***************** company html template  *********************/
//<contact name> has joined <company name> as <job title>
#define EVENT_MSG_COM_PERSON_JONIED  @"%@ has joined %@ as %@"
//<contact name>, <job title>, has left <company name>
#define EVENT_MSG_COM_PERSON_LEFT @"%@, as %@, has left %@"

//<company name>'s [annual / quarterly] revenue has increased xx.xx%
#define EVENT_MSG_COM_REVENUE_INCREASED @"%@%@ %@ revenue has increased %@"
//<company name>'s [annual / quarterly] revenue has decreased xx.xx%
#define EVENT_MSG_COM_REVENUE_DECREASED @"%@%@ %@ revenue has decreased %@"

//<company name> closed <funding amount> in <round> funding
#define EVENT_MSG_COM_FUNDING_CLOSED @"%@ closed %@ in %@ funding"
//<company name> has a new address: <address>
#define EVENT_MSG_COM_ADDRESS_CHANGED @"%@ has a new address: %@"
//<contact name>, <old job title>, is now <new job title> at <company name>
#define EVENT_MSG_COM_PERSON_TITLE_CHANGED @"%@, %@, is now %@ at %@"

//The employee size at <company name> has increased to <number>
#define EMPLOYEE_SIZE_INCREASED @"The employee size at %@ has increased to %@ "
//The employee size at <company name> has decreased  to <number>
#define EMPLOYEE_SIZE_DECREASED @"The employee size at %@ has decreased to %@ "

/***************** contact html template  *********************/
//<contact name> has an updated profile picture on Linkedin
#define EVENT_MSG_CON_HAS_UPDATED_PROFILE_PICTURE @"%@ has an updated profile picture on LinkedIn"
//<contact name>,has joined another company:<company name>
#define EVENT_MSG_CON_JOIN_ANOTHER_COMPANY @"%@ has joined another company: %@"
//<contact name> has a new location:<location name>
#define EVENT_MSG_CON_NEW_LOCATION @"%@ has a new location: %@"
//<contact name> has a new job title:<job title>
#define EVENT_MSG_CON_NEW_JOB_TITLE @"%@ has a new job title: %@"


@implementation GGCompanyHappeningPerson

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"id"] longLongValue];
    self.name = [aData objectForKey:@"name"];
    self.profile = [aData objectForKey:@"profile"];
}

@end

@implementation GGCompanyHappeningCompany
-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"id"] longLongValue];
    self.name = [aData objectForKey:@"name"];
    self.profile = [aData objectForKey:@"profile"];
}
@end

@implementation GGCompanyHappening
- (id)init
{
    self = [super init];
    if (self) {
        _person = [GGCompanyHappeningPerson model];
        _company = [GGCompanyHappeningCompany model];
    }
    return self;
}

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.change = [aData objectForKey:@"change"];
    self.timestamp = [[[aData objectForKey:@"timestamp"] objectForKey:@"timestamp"] longLongValue];
    self.jobTitle = [[aData objectForKey:@"jobtitle"] objectForKey:@"title"];
    [self.person parseWithData:[aData objectForKey:@"person"]];
    [self.company parseWithData:[aData objectForKey:@"company"]];
    self.ID = [[aData objectForKey:@"eventid"] longLongValue];
    self.type = [[aData objectForKey:@"type"] intValue];
    self.source = [[aData objectForKey:@"source"] intValue];
    self.orgID = [aData objectForKey:@"orgid"];
    self.orgName = [aData objectForKey:@"org_name"];
    self.orgLogoPath = [aData objectForKey:@"org_logo_path"];
}

-(NSString *)sourceText
{
    switch (self.source) {
        case kGGHappeningSourceLindedIn:
        {
            return SOURCE_TEXT_LINKEDIN;
        }
            break;
            
        case kGGHappeningSourceCrunchBase:
        {
            return SOURCE_TEXT_CRUNCHBASE;
        }
            break;
            
        case kGGHappeningSourceYahoo:
        {
            return SOURCE_TEXT_YAHOO;
        }
            break;
            
        case kGGHappeningSourceHoovers:
        {
            return SOURCE_TEXT_HOOVERS;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

-(NSString *)headLineText
{
    switch (self.type)
    {
        case kGGHappeningCompanyPersonJion:
        {
            if ([self.change isEqualToString:CHANGE_TYPE_JOIN])
            {
                //<contact name> has joined <company name> as <job title>
                return [NSString stringWithFormat:EVENT_MSG_COM_PERSON_JONIED, self.person.name, self.company.name, self.jobTitle];
            }
            else
            {
                //<contact name>, <job title>, has left <company name>
                return [NSString stringWithFormat:EVENT_MSG_COM_PERSON_LEFT, self.person.name, self.jobTitle, self.company.name];
            }
        }
            break;
            
        case kGGHappeningCompanyPersonJionDetail:
        {
            //<contact name>, <old job title>, is now <new job title> at <company name>
            //#define EVENT_MSG_COM_PERSON_TITLE_CHANGED @"%@, %@, is now %@ at %@"
            return nil;
        }
            break;
            
        case kGGHappeningCompanyRevenueChange:
        {
            //<company name>'s [annual / quarterly] revenue has increased xx.xx%
            //#define EVENT_MSG_COM_REVENUE_INCREASED @"%@%@ %@ revenue has increased %@"
        }
            break;
            
        case kGGHappeningCompanyNewFunding:
        {
            //<company name> closed <funding amount> in <round> funding
            //#define EVENT_MSG_COM_FUNDING_CLOSED @"%@ closed %@ in %@ funding"
        }
            break;
            
        case kGGHappeningCompanyNewLocation:
        {
            //<company name> has a new address: <address>
//#define EVENT_MSG_COM_ADDRESS_CHANGED @"%@ has a new address: %@"
        }
            break;
            
        case kGGHappeningCompanyEmloyeeSizeIncrease:
        {
            //The employee size at <company name> has increased to <number>
//#define EMPLOYEE_SIZE_INCREASED @"The employee size at %@ has increased to %@ "
           
        }
            break;
            
        case kGGHappeningCompanyEmloyeeSizeDecrease:
        {
            //The employee size at <company name> has decreased  to <number>
//#define EMPLOYEE_SIZE_DECREASED @"The employee size at %@ has decreased to %@ "
        }
            break;
            
        case kGGHappeningPersonUpdateProfilePic:
        {
//            //<contact name> has an updated profile picture on Linkedin
//#define EVENT_MSG_CON_HAS_UPDATED_PROFILE_PICTURE @"%@ has an updated profile picture on LinkedIn"

        }
            break;
            
        case kGGHappeningPersonJoinOtherCompany:
        {
            //            //<contact name>,has joined another company:<company name>
            //#define EVENT_MSG_CON_JOIN_ANOTHER_COMPANY @"%@ has joined another company: %@"
            
        }
            break;
            
        case kGGHappeningPersonNewLocation:
        {
            //            //<contact name> has a new location:<location name>
            //#define EVENT_MSG_CON_NEW_LOCATION @"%@ has a new location: %@"
            
        }
            break;
            
        case kGGHappeningPersonNewJobTitle:
        {
            //            //<contact name> has a new job title:<job title>
            //#define EVENT_MSG_CON_NEW_JOB_TITLE @"%@ has a new job title: %@"
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

@end
