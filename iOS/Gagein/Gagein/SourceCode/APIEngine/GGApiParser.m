//
//  GGApiParser.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGApiParser.h"
#import "GGMember.h"
#import "GGCompany.h"
#import "GGDataPage.h"
#import "GGCompanyUpdate.h"

#define GG_ASSERT_API_DATA_IS_DIC   NSAssert([_apiData isKindOfClass:[NSDictionary class]], @"Api Data should be a NSDictionary");

@implementation GGApiParser

#pragma mark - init
+(id)parserWithApiData:(NSDictionary *)anApiData
{
    if (anApiData == nil || ![anApiData isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[self alloc] initWithApiData:anApiData];
}

-(id)initWithApiData:(NSDictionary *)anApiData
{
    self = [super init];
    if (self) {
        _apiData = anApiData;
    }
    
    return self;
}

#pragma mark - basic data
-(int)status
{
    GG_ASSERT_API_DATA_IS_DIC;
    return [[_apiData objectForKey:@"status"] intValue];
}

-(NSString *)message
{
    GG_ASSERT_API_DATA_IS_DIC;
    return [_apiData objectForKey:@"msg"];
}

-(id)data
{
    GG_ASSERT_API_DATA_IS_DIC;
    return [_apiData objectForKey:@"data"];
}

#pragma mark - data elements
-(BOOL)dataHasMore
{
    if ([self.data isKindOfClass:[NSDictionary class]]) {
        return [[self.data objectForKey:@"hasMore"] boolValue];
    }
    
    return NO;
}

-(long long)dataTimestamp
{
    if ([self.data isKindOfClass:[NSDictionary class]]) {
        return [[self.data objectForKey:@"timestamp"] longLongValue];
    }
    
    return 0;
}

-(NSArray *)dataInfos
{
    if ([self.data isKindOfClass:[NSDictionary class]]) {
        return [self.data objectForKey:@"info"];
    }
    
    return nil;
}

#pragma mark - signup
-(GGMember*)parseLogin
{
    GG_ASSERT_API_DATA_IS_DIC;
    GGMember *member = [GGMember model];
    member.ID = [[self.data objectForKey:@"memid"] longLongValue];
    member.accessToken = [self.data objectForKey:@"access_token"];
    member.fullName = [self.data objectForKey:@"mem_full_name"];
    member.timeZone = [[self.data objectForKey:@"mem_timezone"] intValue];
    member.company.name = [self.data objectForKey:@"mem_orgname"];
    
    return member;
}

#pragma mark - companies
-(GGDataPage *)parseGetCompanyUpdates
{
    GG_ASSERT_API_DATA_IS_DIC;
    GGDataPage *page = [GGDataPage model];
    page.hasMore = self.dataHasMore;
    page.timestamp = self.dataTimestamp;
    
    NSArray *dataInfos = self.dataInfos;
    if (dataInfos)
    {
        for (id info in dataInfos) {
            NSAssert([info isKindOfClass:[NSDictionary class]], @"data info should be a NSDictionary");
            
            GGCompanyUpdate *update = [GGCompanyUpdate model];
             
            update.date = [[info objectForKey:@"date"] longLongValue];
            update.fromSource = [info objectForKey:@"from_source"];
            update.content = [info objectForKey:@"news_content"];
            update.headline = [info objectForKey:@"news_headline"];
            update.url = [info objectForKey:@"news_url"];
            update.ID = [[info objectForKey:@"newsid"] longLongValue];
            update.saved = [[info objectForKey:@"newsid"] intValue];
            
            update.company.employeeSize = [info objectForKey:@"employee_size"];
            update.company.fortuneRank = [info objectForKey:@"fortune_rank"];
            update.company.logoPath = [info objectForKey:@"org_logo_path"];
            update.company.name = [info objectForKey:@"org_name"];
            update.company.website = [info objectForKey:@"org_website"];
            update.company.ID = [[info objectForKey:@"orgid"] longLongValue];
            update.company.ownership = [info objectForKey:@"ownership"];
            update.company.revenueSize = [info objectForKey:@"revenue_size"];
            update.company.type = [info objectForKey:@"type"];
            
            [page.items addObject:update];
        }
    }
    
    return page;
}

@end
