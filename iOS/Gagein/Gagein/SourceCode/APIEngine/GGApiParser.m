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

#pragma mark - signup
-(GGMember*)parseLogin
{
    GG_ASSERT_API_DATA_IS_DIC;
    GGMember *member = [GGMember model];
    member.ID = [[self.data objectForKey:@"memid"] longLongValue];
    member.accessToken = [self.data objectForKey:@"access_token"];
    member.fullName = [self.data objectForKey:@"mem_full_name"];
    member.timeZone = [[self.data objectForKey:@"mem_timezone"] intValue];
    
    GGCompany *company = [GGCompany model];
    company.name = [self.data objectForKey:@"mem_orgname"];
    member.company = company;
    
    return member;
}

@end
