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
#import "GGAgent.h"
#import "GGFunctionalArea.h"
#import "GGMenuData.h"

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

-(BOOL)isOK
{
    return self.status == 1;
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

#pragma mark - internal
-(GGDataPage *)_parsePageforClass:(Class)aClass
{
    GG_ASSERT_API_DATA_IS_DIC;
    
    id obj = [aClass alloc];
    NSAssert([obj isKindOfClass:[GGDataModel class]], @"class should be a GGDataModel class");
    
    GGDataPage *page = [GGDataPage model];
    page.hasMore = self.dataHasMore;
    page.timestamp = self.dataTimestamp;
    
    NSArray *dataInfos = self.dataInfos;
    if (dataInfos)
    {
        for (id info in dataInfos) {
            NSAssert([info isKindOfClass:[NSDictionary class]], @"data info should be a NSDictionary");
            
            id dataObj = [aClass model];
            [dataObj parseWithData:info];
            
            [page.items addObject:dataObj];
        }
    }
    
    return page;
}

#pragma mark - signup
-(GGMember*)parseLogin
{
    GG_ASSERT_API_DATA_IS_DIC;
    GGMember *member = [GGMember model];
    [member parseWithData:self.data];
    
    return member;
}

#pragma mark - companies
-(GGDataPage *)parseGetCompanyUpdates
{
    return [self _parsePageforClass:[GGCompanyUpdate class]];
}

-(GGCompany *)parseGetCompanyOverview
{
    GG_ASSERT_API_DATA_IS_DIC;
    GGCompany *company = [GGCompany model];
    [company parseWithData:self.data];
    
    return company;
}

-(GGDataPage *)parseSearchCompany
{
    return [self _parsePageforClass:[GGCompany class]];
}

-(GGDataPage *)parseFollowedCompanies
{
    return [self _parsePageforClass:[GGCompany class]];
}

-(GGCompanyUpdate *)parseGetCompanyUpdateDetail
{
    GGCompanyUpdate * update = [GGCompanyUpdate model];
    [update parseWithData:self.data];
    
    return update;
}

-(NSArray *)parseGetMenu
{
    NSAssert([self.data isKindOfClass:[NSArray class]], @"data shuld be an array");
    NSMutableArray *results = [NSMutableArray array];
    
    NSArray *data = self.data;
#warning type data must be given by API, currently by client
    int type = 0;
    for (NSDictionary *dic in data)
    {
        NSAssert([dic isKindOfClass:[NSDictionary class]], @"data shuld be an array");
        GGDataPage *page = [GGDataPage model];
        page.hasMore = [[dic objectForKey:@"hasMore"] boolValue];
        page.timestamp = [[dic objectForKey:@"timestamp"] longLongValue];
        
        NSArray *dataInfos = [dic objectForKey:@"info"];;
        if (dataInfos)
        {
            for (id info in dataInfos) {
                NSAssert([info isKindOfClass:[NSDictionary class]], @"data info should be a NSDictionary");
                
                GGMenuData *menuData = [GGMenuData model];
                [menuData parseWithData:info];
                menuData.type = type;
                
                [page.items addObject:menuData];
            }
        }
        
        [results addObject:page];
        
        type++;
    }
    
    return results;
}

#pragma mark - config
-(GGDataPage *)parseGetAgents
{
    return [self _parsePageforClass:[GGAgent class]];
}

-(GGDataPage *)parseGetFunctionalAreas
{
    return [self _parsePageforClass:[GGFunctionalArea class]];
}

@end
