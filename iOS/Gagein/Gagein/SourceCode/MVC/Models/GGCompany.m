//
//  GGCompany.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompany.h"

@implementation GGCompany

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"orgid"] longLongValue];
    self.name = [aData objectForKey:@"org_name"];
    self.website = [aData objectForKey:@"org_website"];
    self.logoPath = [aData objectForKey:@"org_logo_path"];
    self.type = [aData objectForKey:@"type"];
    self.followed = [[aData objectForKey:@"followed"] boolValue];
    
    self.employeeSize = [aData objectForKey:@"employee_size"];
    self.fortuneRank = [aData objectForKey:@"fortune_rank"];
    self.ownership = [aData objectForKey:@"ownership"];
    self.revenueSize = [aData objectForKey:@"revenue_size"];
    
    self.aliases = [aData objectForKey:@"org_aliases"];
    self.keywords = [aData objectForKey:@"org_keywords"];
    self.description = [aData objectForKey:@"org_description"];
    
    self.specialities = [aData objectForKey:@"specialties"];
    self.industries = [aData objectForKey:@"industries"];
    self.telephone = [aData objectForKey:@"telephone"];
    self.faxNumber = [aData objectForKey:@"fax_number"];
    self.profile = [aData objectForKey:@"profile"];
    self.fiscalYear = [aData objectForKey:@"fiscal_year"];
    self.founded = [aData objectForKey:@"founded"];
    
    self.country = [aData objectForKey:@"country"];
    self.state = [aData objectForKey:@"state"];
    self.city = [aData objectForKey:@"city"];
    self.zipcode = [aData objectForKey:@"zipcode"];
    self.address = [aData objectForKey:@"address"];
    self.googleMapUrl = [aData objectForKey:@"google_map_url"];
    self.latestDate = [aData objectForKey:@"latest_date"];
}

-(EGGCompanyType)getType
{
    if ([self.type isEqualToString:@"Public Company"])
    {
        return kGGCompanyTypePublic;
    }
    else if ([self.type isEqualToString:@"Private Company"])
    {
        return kGGCompanyTypePrivate;
    }

    return kGGCompanyTypeUnknown;
}

@end
