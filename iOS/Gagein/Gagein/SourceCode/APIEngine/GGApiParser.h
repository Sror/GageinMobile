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
@class GGHappening;
@class GGPerson;
@class GGUserProfile;
@class GGSnUserInfo;
@class GGUpgradeInfo;

typedef enum
{
    kGGApiStatusSuccess = 1
    , kGGApiStatusWrongParam
    , kGGApiStatusVerificationFailed
    , kGGApiStatusInternalSystemError
    , kGGApiStatusUserOperationError
}EGGApiStatus;

@interface GGApiParser : NSObject
@property (strong)  NSDictionary    *apiData;

#pragma mark - init
+(id)parserWithApiData:(NSDictionary *)anApiData;
-(id)initWithApiData:(NSDictionary *)anApiData;

-(BOOL)isOK;

#pragma mark - basic data
-(int)status;
-(NSString *)message;
-(long long)messageCode;
-(NSString *)messageExtraInfo;
-(id)data;

#pragma mark - data elements
-(BOOL)dataHasMore;
-(long long)dataTimestamp;
-(NSArray *)dataInfos;
-(BOOL)dataCharEnabled;

#pragma mark - signup
-(GGMember*)parseLogin;

-(GGDataPage *)parsePageforClass:(Class)aClass;

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
-(GGDataPage *)parseImportCompanies;
-(GGDataPage *)parseGetRecommendedCompanies;
-(GGCompanyUpdate *)parseGetCompanyUpdateDetail;
-(GGHappening *)parseCompanyEventDetail;
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
-(GGDataPage *)parseGetFollowedPeople;
-(GGDataPage *)parseGetSeggestedPeople;
-(GGDataPage *)parseGetRecommendedPeople;

#pragma mark - sn
-(NSArray *)parseSnGetList;
-(GGSnUserInfo *)parseSnGetUserInfo;

#pragma mark - upgrade version check
-(GGUpgradeInfo *)parseGetVersion;


@end
