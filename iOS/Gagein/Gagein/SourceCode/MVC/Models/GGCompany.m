//
//  GGCompany.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompany.h"
#import "GGTicker.h"
#import "GGSocialProfile.h"

@implementation GGCompanyBrief

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"orgid"] longLongValue];
    self.name = [aData objectForKey:@"org_name"];
    self.enabled = [[aData objectForKey:@"enabled"] boolValue];
}

@end

/////////////////////////////////////////////
//
@implementation GGCompanyDigest

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"id"] longLongValue];
    self.orgID = [[aData objectForKey:@"orgid"] longLongValue];
    
    self.name = [aData objectForKey:@"name"];           // name from message, may be a old name
    self.orgName = [aData objectForKey:@"org_name"];    // current name
    
    self.profile = [aData objectForKey:@"profile"];
    
    self.website = [aData objectForKey:@"org_website"];
    self.logoPath = [aData objectForKey:@"org_logo_path"];
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
    
    _orgEmail = [aData objectForKey:@"org_email"];
    _linkedInSearchUrl = [aData objectForKey:@"linkedin_search_url"];
    
    GGApiParser *parser = [GGApiParser parserWithApiData:[aData objectForKey:@"competitors"]];
    _competitors = [parser parsePageforClass:[GGCompany class]];
}

-(NSString *)addressCityStateCountry
{
    return [NSString stringWithFormat:@"%@,%@,%@", _city, _state, _country];
}

@end

//////////////////////////////////////////////
@implementation GGCompany

- (id)init
{
    self = [super init];
    if (self) {
        _socialProfiles = [NSMutableArray array];
        _tickerSymbols = [NSMutableArray array];
        _divisions = [NSMutableArray array];
        _subsidiaries = [NSMutableArray array];
    }
    return self;
}

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
    self.revenuesChartUrl = [aData objectForKey:@"revenues_chart_url"];
    
    [_socialProfiles removeAllObjects];
    NSArray *snProfiles = [aData objectForKey:@"social_profiles"];
    if (snProfiles.count)
    {
        for (id item in snProfiles)
        {
            NSAssert([item isKindOfClass:[NSDictionary class]], @"sn profile data should be a Dic");
            
            GGSocialProfile *profile = [GGSocialProfile model];
            [profile parseWithData:item];
            [_socialProfiles addObject:profile];
        }
    }
    
    [_tickerSymbols removeAllObjects];
    NSArray *symbols = [aData objectForKey:@"ticker_symbol"];
    if (symbols.count)
    {
        for (id item in symbols)
        {
            NSAssert([item isKindOfClass:[NSDictionary class]], @"sn profile data should be a Dic");
            
            GGTicker *symbol = [GGTicker model];
            [symbol parseWithData:item];
            [_tickerSymbols addObject:symbol];
        }
    }
    
    [_divisions removeAllObjects];
    NSArray *divisions = [aData objectForKey:@"divisions"];
    if (divisions.count)
    {
        for (id item in divisions)
        {
            NSAssert([item isKindOfClass:[NSDictionary class]], @"sn profile data should be a Dic");
            
            GGCompanyBrief *comBrief = [GGCompanyBrief model];
            [comBrief parseWithData:item];
            [_divisions addObject:comBrief];
        }
    }
    
    [_subsidiaries removeAllObjects];
    NSArray *subsidiaries = [aData objectForKey:@"subsidiaries"];
    if (subsidiaries.count)
    {
        for (id item in subsidiaries)
        {
            NSAssert([item isKindOfClass:[NSDictionary class]], @"sn profile data should be a Dic");
            
            GGCompanyBrief *comBrief = [GGCompanyBrief model];
            [comBrief parseWithData:item];
            [_subsidiaries addObject:comBrief];
        }
    }
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
