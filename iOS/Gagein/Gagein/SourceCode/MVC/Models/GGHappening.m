//
//  GGCompanyHappening.m
//  Gagein
//
//  Created by dong yiming on 13-4-17.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGHappening.h"
#import "GGSocialProfile.h"

#define SOURCE_TEXT_LINKEDIN  @"Linkedin"
#define SOURCE_TEXT_CRUNCHBASE  @"CrunchBase"
#define SOURCE_TEXT_YAHOO  @"Yahoo"
#define SOURCE_TEXT_HOOVERS  @"Hoovers"

#define CHANGE_TYPE_JOIN  @"JOIN"
#define CHANGE_TYPE_LEFT  @"LEAVE"

/***************** company html template  *********************/

// d)      Employees Join Another Company (<Contact Name> <Old title> at <Old Company> has joined <Company> as <Title>)
#define EVENT_MSG_COM_PERSON_JONIED     @"%@ %@ at %@ has joined %@ as %@"
//<contact name> has joined <company name> as <job title>
#define EVENT_MSG_COM_PERSON_JONIED_OLD  @"%@ has joined %@ as %@"

//e)      Employees Left Company (<Contact Name> <Old title>, has left <Old Company> and is now  <Title> at <Company>)
#define EVENT_MSG_COM_PERSON_LEFT       @"%@ %@, has left %@ and is now %@ at %@"
//<contact name>, <job title>, has left <company name>
#define EVENT_MSG_COM_PERSON_LEFT_OLD   @"%@, as %@, has left %@"


//<company name>'s [annual / quarterly] revenue has increased xx.xx%
#define EVENT_MSG_COM_REVENUE_INCREASED_OLD @"%@'s %@ revenue has increased %.2f%%"
//<company name>'s [annual / quarterly] revenue has decreased xx.xx%
#define EVENT_MSG_COM_REVENUE_DECREASED_OLD @"%@'s %@ revenue has decreased %.2f%%"

//<company name> closed <funding amount> in <round> funding
#define EVENT_MSG_COM_FUNDING_CLOSED_OLD @"%@ closed %@ in %@ funding"

//<company name> has a new address: <address>
#define EVENT_MSG_COM_ADDRESS_CHANGED_OLD @"%@ has a new address: %@"

//<contact name>, <old job title>, is now <new job title> at <company name>
#define EVENT_MSG_COM_PERSON_TITLE_CHANGED_OLD @"%@, %@, is now %@ at %@"

//The employee size at <company name> has increased to <number>
#define EMPLOYEE_SIZE_INCREASED_OLD @"The employee size at %@ has increased to %@ "
//The employee size at <company name> has decreased  to <number>
#define EMPLOYEE_SIZE_DECREASED_OLD @"The employee size at %@ has decreased to %@ "


//////////////////// OLD: contact html template /////////////////////////
//<contact name> has an updated profile picture on Linkedin
#define EVENT_MSG_CON_HAS_UPDATED_PROFILE_PICTURE_OLD @"%@ has an updated profile picture on LinkedIn"

//<contact name>,has joined another company:<company name>
#define EVENT_MSG_CON_JOIN_ANOTHER_COMPANY_OLD @"%@ has joined another company: %@"

//<contact name> has a new location:<location name>
#define EVENT_MSG_CON_NEW_LOCATION_OLD @"%@ has a new location: %@"

//<contact name> has a new job title:<job title>
#define EVENT_MSG_CON_NEW_JOB_TITLE_OLD @"%@ has a new job title: %@"

/***************** NEW: contact html template  *********************/
//<Contact Name>, <Title> at <Company Name>, has an updated profile picture on <Source>
#define EVENT_MSG_CON_HAS_UPDATED_PROFILE_PICTURE @"%@, %@ at %@ has an updated profile picture on %@"

// (<Contact Name>, <Old Title> at <Old Company Name>, has joined <Company Name> as <Title>)
#define EVENT_MSG_CON_JOIN_ANOTHER_COMPANY @"%@, %@ at %@, has joined %@ as %@"

// Location Changes (<Contact Name>, <Title> at <Company Name>, has moved from <Old Address> to <Address>.)
#define EVENT_MSG_CON_NEW_LOCATION @"%@, %@ at %@, has moved from %@ to %@"

//d)  Job Title Changes (<Contact Name>, <Old Title>, is now <Title> at <Company Name>.)
#define EVENT_MSG_CON_NEW_JOB_TITLE @"%@, %@, is now %@ at %@"


@implementation GGHappeningPerson

//
-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"id"] longLongValue];
    self.name = [aData objectForKey:@"name"];
    self.profile = [aData objectForKey:@"profile"];
    
    self.contactID = [[aData objectForKey:@"contactid"] longLongValue];
    self.orgID = [[aData objectForKey:@"orgid"] longLongValue];
    self.orgName = [aData objectForKey:@"org_name"];
    self.orgTitle = [aData objectForKey:@"org_title"];
    self.jobLevel = [[aData objectForKey:@"job_level"] longLongValue];
    self.address = [aData objectForKey:@"address"];
    self.linkedInID = [aData objectForKey:@"linkedin_id"];
    self.photoPath = [aData objectForKey:@"photo_path"];
    
    NSArray *socialProfiles = [aData objectForKey:@"social_profiles"];
    if (socialProfiles.count)
    {
        self.socialProfiles = [NSMutableArray array];
        for (id profile in socialProfiles)
        {
            GGSocialProfile * sp = [GGSocialProfile model];
            [sp parseWithData:profile];
            
            [self.socialProfiles addObject:sp];
        }
    }
    
    self.actionType = [aData objectForKey:@"action_type"];
    self.contactName = [aData objectForKey:@"contact_name"];
}

@end


//
@implementation GGHappeningCompany
-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"id"] longLongValue];
    self.name = [aData objectForKey:@"name"];
    self.profile = [aData objectForKey:@"profile"];
    
    self.orgID = [[aData objectForKey:@"orgid"] longLongValue];
    self.orgName = [aData objectForKey:@"org_name"];
    
    self.orgWebSite = [aData objectForKey:@"org_website"];
    self.orgLogoPath = [aData objectForKey:@"org_logo_path"];
    self.type = [aData objectForKey:@"type"];
    self.ownership = [aData objectForKey:@"ownership"];
    self.fortuneRank = [aData objectForKey:@"fortune_rank"];
    self.revenueSize = [aData objectForKey:@"revenue_size"];
    self.employeeSize = [aData objectForKey:@"employee_size"];
    self.country = [aData objectForKey:@"country"];
    self.state = [aData objectForKey:@"state"];
    self.city = [aData objectForKey:@"city"];
    self.zipcode = [aData objectForKey:@"zipcode"];
    self.address = [aData objectForKey:@"address"];
    
}

-(NSString *)addressCityStateCountry
{
    return [NSString stringWithFormat:@"%@,%@,%@", _city, _state, _country];
}

@end



//
@implementation GGHappening
- (id)init
{
    self = [super init];
    if (self) {
        _person = [GGHappeningPerson model];
        _company = [GGHappeningCompany model];
        _oldCompany = [GGHappeningCompany model];
    }
    return self;
}

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.change = [aData objectForKey:@"change"];
    
    self.timestamp = [[[aData objectForKey:@"timestamp"] objectForKey:@"timestamp"] longLongValue];
    self.newTimestamp = [[[aData objectForKey:@"newTimestamp"] objectForKey:@"timestamp"] longLongValue];
    self.oldTimestamp = [[[aData objectForKey:@"oldTimestamp"] objectForKey:@"timestamp"] longLongValue];
    self.fundingTimestamp = [[[aData objectForKey:@"oldTimestamp"] objectForKey:@"timestamp"] longLongValue];
    
    self.protocol = [[aData objectForKey:@"protocol"] longLongValue];
    self.dateStr = [aData objectForKey:@"date_str"];
    
    self.contactID = [[aData objectForKey:@"contactid"] longLongValue];
    self.name = [aData objectForKey:@"name"];
    self.photoPath = [aData objectForKey:@"photo_path"];
    
    [self.person parseWithData:[aData objectForKey:@"person"]];
    [self.company parseWithData:[aData objectForKey:@"company"]];
    [self.oldCompany parseWithData:[aData objectForKey:@"oldCompany"]];
    
    self.ID = [[aData objectForKey:@"eventid"] longLongValue];
    self.type = [[aData objectForKey:@"type"] intValue];
    self.source = [[aData objectForKey:@"source"] intValue];
    
    self.orgID = [aData objectForKey:@"orgid"];
    self.orgName = [aData objectForKey:@"org_name"];
    self.orgLogoPath = [aData objectForKey:@"org_logo_path"];
    
    self.profilePic = [aData objectForKey:@"profilepic"];
    self.oldProfilePic = [aData objectForKey:@"oldProfilepic"];
    
    self.title = [[aData objectForKey:@"title"] objectForKey:@"title"];
    self.jobTitle = [[aData objectForKey:@"jobtitle"] objectForKey:@"title"];
    
    self.oldJobTitle = [[aData objectForKey:@"oldjobtitle"] objectForKey:@"title"];
    if (_oldJobTitle.length <= 0)   // stupid!!! use different key for the same variable, the only diff is Capitalize or not
    {
        _oldJobTitle = [[aData objectForKey:@"oldJobtitle"] objectForKey:@"title"];
    }
    
    self.theNewJobTitle = [[aData objectForKey:@"newjobtitle"] objectForKey:@"title"];

    self.address = [[aData objectForKey:@"address"] objectForKey:@"address"];
    self.addressMap = [aData objectForKey:@"address_map"];
    self.oldAddress = [[aData objectForKey:@"oldAddress"] objectForKey:@"address"];
    
    _oldRevenue = [aData objectForKey:@"oldRevenue"];
    _theNewRevenue = [aData objectForKey:@"newRevenue"];
    _percentage = [aData objectForKey:@"percentage"];
    _period = [aData objectForKey:@"period"];

    _funding = [aData objectForKey:@"funding"];
    _round = [aData objectForKey:@"round"];

    _oldEmployNum = [aData objectForKey:@"oldEmployNum"];
    _employNum = [aData objectForKey:@"employNum"];
    _direction = [aData objectForKey:@"direction"];
}

-(BOOL)_isOldData
{
    return _protocol != 2;
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

-(BOOL)isJoin
{
    return [self.change isEqualToString:CHANGE_TYPE_JOIN];
}

-(NSString *)headLineText
{
    switch (self.type)
    {
        case kGGHappeningCompanyPersonJion:
        {
            if ([self isJoin])
            {
                return [self _isOldData] ? [NSString stringWithFormat:EVENT_MSG_COM_PERSON_JONIED_OLD, self.person.name, self.company.name, self.jobTitle]
                : [NSString stringWithFormat:EVENT_MSG_COM_PERSON_JONIED, self.person.name
                   , self.oldJobTitle, self.oldCompany.name
                   , self.company.name, self.jobTitle];

            }
            else
            {
                //<contact name>, <job title>, has left <company name>
                if ([self _isOldData])
                {
                    return  [NSString stringWithFormat:EVENT_MSG_COM_PERSON_LEFT_OLD, self.person.name, self.jobTitle, self.company.name];
                }
                else
                {
                    if (_company.name)
                    {
                        return [NSString stringWithFormat:EVENT_MSG_COM_PERSON_LEFT, self.person.name
                         , self.oldJobTitle, self.oldCompany.name
                         , self.jobTitle, self.company.name];
                    }
                    else
                    {
                        return [NSString stringWithFormat:EVENT_MSG_COM_PERSON_LEFT_OLD, self.person.name, self.oldJobTitle, self.oldCompany.name];
                    }
                }
                
            }
        }
            break;
            
        case kGGHappeningCompanyPersonJionDetail:
        {
            
            
            //<contact name>, <old job title>, is now <new job title> at <company name>
            //#define EVENT_MSG_COM_PERSON_TITLE_CHANGED @"%@, %@, is now %@ at %@"
            return [NSString stringWithFormat:EVENT_MSG_COM_PERSON_TITLE_CHANGED_OLD, self.person.name, self.oldJobTitle, self.theNewJobTitle, self.company.name];
        }
            break;
            
        case kGGHappeningCompanyRevenueChange:
        {
            //NSString *percentageStr = [_percentage stringByReplacingOccurrencesOfString:@"-" withString:@""];
            float percent = [_percentage floatValue] * 100.f;
            if (percent >= 0) // increased
            {
                return [NSString stringWithFormat:EVENT_MSG_COM_REVENUE_INCREASED_OLD, self.company.name, self.period, percent];
            }
            
            else
            {
                return [NSString stringWithFormat:EVENT_MSG_COM_REVENUE_DECREASED_OLD, self.company.name, self.period, - percent];
            }
        }
            break;
            
        case kGGHappeningCompanyNewFunding:
        {
            //<company name> closed <funding amount> in <round> funding
            //#define EVENT_MSG_COM_FUNDING_CLOSED @"%@ closed %@ in %@ funding"
            return [NSString stringWithFormat:EVENT_MSG_COM_FUNDING_CLOSED_OLD, self.company.name, self.funding, self.round];
        }
            break;
            
        case kGGHappeningCompanyNewLocation:
        {
            //<company name> has a new address: <address>
//#define EVENT_MSG_COM_ADDRESS_CHANGED @"%@ has a new address: %@"
            return [NSString stringWithFormat:EVENT_MSG_COM_ADDRESS_CHANGED_OLD, self.company.name, self.address];
        }
            break;
            
        case kGGHappeningCompanyEmloyeeSizeIncrease:
        {
            //The employee size at <company name> has increased to <number>
//#define EMPLOYEE_SIZE_INCREASED @"The employee size at %@ has increased to %@ "
           return [NSString stringWithFormat:EMPLOYEE_SIZE_INCREASED_OLD, self.company.name, self.employNum];
        }
            break;
            
        case kGGHappeningCompanyEmloyeeSizeDecrease:
        {
            //The employee size at <company name> has decreased  to <number>
//#define EMPLOYEE_SIZE_DECREASED @"The employee size at %@ has decreased to %@ "
            return [NSString stringWithFormat:EMPLOYEE_SIZE_DECREASED_OLD, self.company.name, self.employNum];
        }
            break;
            
            
//////////////////////////////// person ///////////////////////////////
        case kGGHappeningPersonUpdateProfilePic:
        {
            //#define EVENT_MSG_CON_HAS_UPDATED_PROFILE_PICTURE_OLD @"%@ has an updated profile picture on LinkedIn"
            return [self _isOldData] ? [NSString stringWithFormat:EVENT_MSG_CON_HAS_UPDATED_PROFILE_PICTURE_OLD, self.person.name] :
            
//          //<Contact Name>, <Title> at <Company Name>, has an updated profile picture on <Source>
            [NSString stringWithFormat:EVENT_MSG_CON_HAS_UPDATED_PROFILE_PICTURE
                    , self.person.name
                    , self.title
                    , self.company.name
                    , [self sourceText]];
        }
            break;
            
        case kGGHappeningPersonJoinOtherCompany:
        {
            //#define EVENT_MSG_CON_JOIN_ANOTHER_COMPANY_OLD @"%@ has joined another company: %@"
            return [self _isOldData] ? [NSString stringWithFormat:EVENT_MSG_CON_JOIN_ANOTHER_COMPANY_OLD, self.person.name, self.company.name] :
            
            // (<Contact Name>, <Old Title> at <Old Company Name>, has joined <Company Name> as <Title>)
            [NSString stringWithFormat:EVENT_MSG_CON_JOIN_ANOTHER_COMPANY
                    , self.person.name
                    , self.oldJobTitle
                    , self.oldCompany.name
                    , self.company.name
                    , self.jobTitle];
        }
            break;
            
        case kGGHappeningPersonNewLocation:
        {
            //<contact name> has a new location:<location name>
//#define EVENT_MSG_CON_NEW_LOCATION_OLD @"%@ has a new location: %@"
            return [self _isOldData] ? [NSString stringWithFormat:EVENT_MSG_CON_NEW_LOCATION_OLD, self.person.name, self.address] :
            
            // Location Changes (<Contact Name>, <Title> at <Company Name>, has moved from <Old Address> to <Address>.)
            [NSString stringWithFormat:EVENT_MSG_CON_NEW_LOCATION
                    , self.person.name
                    , self.title
                    , self.company.name
                    , self.oldAddress
                    , self.address];
        }
            break;
            
        case kGGHappeningPersonNewJobTitle:
        {
            //<contact name> has a new job title:<job title>
//#define EVENT_MSG_CON_NEW_JOB_TITLE_OLD @"%@ has a new job title: %@"
            return [self _isOldData] ? [NSString stringWithFormat:EVENT_MSG_CON_NEW_JOB_TITLE_OLD, self.person.name, self.jobTitle] :
            
//d)  Job Title Changes (<Contact Name>, <Old Title>, is now <Title> at <Company Name>.)
            [NSString stringWithFormat:EVENT_MSG_CON_NEW_JOB_TITLE
                    , self.person.name
                    , self.oldJobTitle
                    , self.jobTitle
                    , self.company.name];
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

@end
