//
//  GGUserProfile.m
//  Gagein
//
//  Created by dong yiming on 13-5-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGUserProfile.h"

@implementation GGUserProfile

//mem_first_name
//mem_last_name
//mem_email
//mem_org_title
//mem_add_timezone
//orgid
//org_name
//org_website
//org_logo_path
//plan_id":"99","plan_name":"Unlimited"

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    //self.ID = [[aData objectForKey:@"memid"] longLongValue];
    self.firstName = [aData objectForKey:@"mem_first_name"];
    self.lastName = [aData objectForKey:@"mem_last_name"];
    self.email = [aData objectForKey:@"mem_email"];
    self.timezone = [aData objectForKey:@"mem_add_timezone"];
    self.orgTitle = [aData objectForKey:@"mem_org_title"];
    self.orgID = [aData objectForKey:@"orgid"];
    self.orgName = [aData objectForKey:@"org_name"];
    self.orgWebsite = [aData objectForKey:@"org_website"];
    self.orgLogoPath = [aData objectForKey:@"org_logo_path"];
    _planID = [[aData objectForKey:@"plan_id"] longLongValue];
    _planName = [aData objectForKey:@"plan_name"];
    
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
