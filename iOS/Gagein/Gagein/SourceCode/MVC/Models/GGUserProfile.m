//
//  GGUserProfile.m
//  Gagein
//
//  Created by dong yiming on 13-5-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGUserProfile.h"
#import "GGCompany.h"

@implementation GGUserProfile

//3.contact/overview api
//add columns : school，prev companies
//schools:[{"name":"xxxxx"},{"name","yyyyy"}]
//prev_companies:[{"orgid":"1111","org_name":"gagein","enabled":1},{"orgid":"222","org_name":"gagein222","enabled":1},{"orgid":"xxxx","org_name":"gagein333","enabled":0}]

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    //self.ID = [[aData objectForKey:@"memid"] longLongValue];
    self.firstName = [aData objectForKey:@"mem_first_name"];
    self.lastName = [aData objectForKey:@"mem_last_name"];
    self.email = [aData objectForKey:@"mem_email"];
    self.timezone = [aData objectForKey:@"mem_add_timezone"];
    self.orgTitle = [aData objectForKey:@"mem_org_title"];
    self.orgID = [[aData objectForKey:@"orgid"] longLongValue];
    self.orgName = [aData objectForKey:@"org_name"];
    self.orgWebsite = [aData objectForKey:@"org_website"];
    self.orgLogoPath = [aData objectForKey:@"org_logo_path"];
    _planID = [[aData objectForKey:@"plan_id"] longLongValue];
    _planName = [aData objectForKey:@"plan_name"];
    _timezoneGMT = [aData objectForKey:@"timezone_gmtnum"];
    _timezoneName = [aData objectForKey:@"timezone_name"];
    
    // education - schools
    NSMutableArray *schools = [aData objectForKey:@"schools"];
    if (schools.count)
    {
        _schools = [NSMutableArray array];
        for (NSDictionary *schoolDic in schools)
        {
            [_schools addObjectIfNotNil:[schoolDic objectForKey:@"name"]];
        }
    }
    else
    {
        _schools = nil;
    }
    
    // previous companies
    NSMutableArray *prevCompanies = [aData objectForKey:@"prev_companies"];
    if (prevCompanies.count)
    {
        _prevCompanies = [NSMutableArray array];
        for (NSDictionary *comDic in prevCompanies)
        {
            GGCompanyBrief *company = [GGCompanyBrief model];
            [company parseWithData:comDic];
            [_prevCompanies addObjectIfNotNil:company];
        }
    }
    else
    {
        _prevCompanies = nil;
    }
    
//    self.orgAddress = [aData objectForKey:@"org_address"];
//    self.photoPath = [aData objectForKey:@"mem_photo_path"];
//    self.orgDept = [aData objectForKey:@"mem_org_dept"];
//    self.division = [aData objectForKey:@"mem_division"];
//    self.description = [aData objectForKey:@"mem_description"];
//    self.specialties = [aData objectForKey:@"mem_specialties"];
//    self.mobilephone = [aData objectForKey:@"mem_mobilephone"];
//    self.jobFunc = [aData objectForKey:@"mem_job_func"];
//    self.jobLevel = [aData objectForKey:@"mem_job_level"];
//    self.addAddress = [aData objectForKey:@"mem_add_address"];
    
}

@end
