//
//  GGApiParser.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGMember;
@class GGDataPage;
@class GGCompany;
@class GGCompanyUpdate;
@class GGCompanyHappening;
@class GGPerson;
@class GGUserProfile;

@interface GGApiParser : NSObject
@property (strong)  NSDictionary    *apiData;

#pragma mark - init
+(id)parserWithApiData:(NSDictionary *)anApiData;
-(id)initWithApiData:(NSDictionary *)anApiData;

-(BOOL)isOK;

#pragma mark - basic data
-(int)status;
-(NSString *)message;
-(id)data;

#pragma mark - data elements
-(BOOL)dataHasMore;
-(long long)dataTimestamp;
-(NSArray *)dataInfos;

#pragma mark - signup
-(GGMember*)parseLogin;

#pragma mark - companies
-(GGDataPage *)parseGetCompanyUpdates;
-(GGDataPage *)parseGetSavedUpdates;
-(GGDataPage *)parseGetCompanyHappenings;
-(GGDataPage *)parseGetCompanyPeople;
-(GGDataPage *)parseGetSimilarCompanies;
-(GGCompany *)parseGetCompanyOverview;
-(GGPerson *)parseGetPersonOverview;
-(GGDataPage *)parseSearchCompany;
-(GGDataPage *)parseFollowedCompanies;
-(GGCompanyUpdate *)parseGetCompanyUpdateDetail;
-(GGCompanyHappening *)parseCompanyEventDetail;
-(NSArray *)parseGetMenu:(BOOL)aIsCompanyMenu;
-(GGUserProfile *)parseGetMyOverview;

#pragma mark - config
-(GGDataPage *)parseGetMediaFiltersList;
-(GGDataPage *)parseGetCategoryFiltersList;
-(GGDataPage *)parseGetAgentFiltersList;
-(GGDataPage *)parseGetAgents;
-(GGDataPage *)parseGetFunctionalAreas;
//-(NSMutableArray *)parseGetConfigFilterOptions;

#pragma mark - people
-(GGDataPage *)parseSearchForPeople;
@end
