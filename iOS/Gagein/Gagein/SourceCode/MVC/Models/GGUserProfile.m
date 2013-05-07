//
//  GGUserProfile.m
//  Gagein
//
//  Created by dong yiming on 13-5-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGUserProfile.h"

@implementation GGUserProfile

//"memid": "1433",
//"mem_fullname": "Lei zhenjun",
//"mem_org_title": "GM",
//"orgid": "1231037",
//"org_name": "GageIn",
//"org_website": "www.gagein.com",
//"org_address": "",

//"mem_photo_path": "http://localhost:8080/profilepic/mem/20110926/16/1433/1433_60X60.jpg",
//"mem_org_dept": "",
//"mem_division": "",
//"mem_description": "1",
//"mem_specialties": "1",
//"mem_email": "zlei@gagein.com",
//"mem_mobilephone": "",

//"mem_job_func": "Engineering & Research",
//"mem_job_level": "Staff",
//"mem_add_address": "Wuhan, HUBEI, CN"

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"memid"] longLongValue];
    self.fullName = [aData objectForKey:@"mem_fullname"];
    self.orgTitle = [aData objectForKey:@"mem_org_title"];
    self.orgID = [aData objectForKey:@"orgid"];
    self.orgName = [aData objectForKey:@"org_name"];
    self.orgWebsite = [aData objectForKey:@"org_website"];
    self.orgAddress = [aData objectForKey:@"org_address"];
    
    self.photoPath = [aData objectForKey:@"mem_photo_path"];
    self.orgDept = [aData objectForKey:@"mem_org_dept"];
    self.division = [aData objectForKey:@"mem_division"];
    self.description = [aData objectForKey:@"mem_description"];
    self.specialties = [aData objectForKey:@"mem_specialties"];
    self.email = [aData objectForKey:@"mem_email"];
    self.mobilephone = [aData objectForKey:@"mem_mobilephone"];
    
    self.jobFunc = [aData objectForKey:@"mem_job_func"];
    self.jobLevel = [aData objectForKey:@"mem_job_level"];
    self.addAddress = [aData objectForKey:@"mem_add_address"];
    self.timezone = [aData objectForKey:@"mem_timezone"];
}

@end
