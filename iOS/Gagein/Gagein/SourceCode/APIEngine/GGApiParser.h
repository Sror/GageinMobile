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
-(GGCompany *)parseGetCompanyOverview;

#pragma mark - config
-(GGDataPage *)parseGetAgents;
-(GGDataPage *)parseGetFunctionalAreas;
@end
