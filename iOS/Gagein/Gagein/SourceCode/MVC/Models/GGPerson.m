//
//  GGPerson.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGPerson.h"
#import "GGCompany.h"
#import "GGSocialProfile.h"

@implementation GGPerson

- (id)init
{
    self = [super init];
    if (self) {
        _company = [GGCompany model];
    }
    return self;
}

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"contactid"] longLongValue];
    self.name = [aData objectForKey:@"name"];
    self.orgTitle = [aData objectForKey:@"org_title"];
    self.jobLevel = [aData objectForKey:@"job_level"];
    self.linkedInID = [aData objectForKey:@"linkedin_id"];
    self.photoPath = [aData objectForKey:@"photo_path"];
    self.actionType = [aData objectForKey:@"action_type"];
    self.address = [aData objectForKey:@"address"];
    
    self.company.ID = [[aData objectForKey:@"orgid"] longLongValue];
    self.company.name = [aData objectForKey:@"org_name"];
    
    //
    NSArray *socialProfiles = [aData objectForKey:@"social_profiles"];
    if (socialProfiles.count)
    {
        self.socialProfiles = [NSMutableArray array];
        for (id profile in socialProfiles)
        {
            GGSocialProfile * sp = [GGSocialProfile model];
            [sp parseWithData:profile];
            
            [self.socialProfiles addObjectIfNotNil:sp];
        }
    }
    
    
    //
    NSArray *schools = [aData objectForKey:@"schools"];
    _schools = [NSMutableArray arrayWithArray:schools];
    
    
    //
    NSArray *prevCompanies = [aData objectForKey:@"prev_companies"];
    if (prevCompanies.count)
    {
        _prevCompanies = [NSMutableArray array];
        for (id companyData in prevCompanies)
        {
            GGCompany *company = [GGCompany model];
            [company parseWithData:companyData];
            
            [_prevCompanies addObjectIfNotNil:company];
        }
    }
    
}

@end
