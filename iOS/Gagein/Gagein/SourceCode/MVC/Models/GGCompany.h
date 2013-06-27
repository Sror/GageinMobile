//
//  GGCompany.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

typedef enum {
    kGGCompanyTypePublic = 0
    , kGGCompanyTypePrivate
    , kGGCompanyTypeUnknown
}EGGCompanyType;

@class GGSocialProfile;
@class GGTicker;

@interface GGCompanyBrief : GGDataModel
@property (copy)    NSString *name;
@property (assign)  BOOL    enabled;
@end

///////////////////////////////////////////
@interface GGCompanyDigest : GGCompanyBrief
@property (copy) NSString       *name;
@property (copy) NSString       *profile;

@property (assign) long long    orgID;
@property (copy) NSString       *orgName;
@property (copy) NSString       *website;
@property (copy) NSString       *logoPath;

@property (copy) NSString       *type;              // eg. "Private Company"
@property (copy) NSString       *ownership;
@property (copy) NSString       *fortuneRank;
@property (copy) NSString       *revenueSize;
@property (copy) NSString       *employeeSize;

@property (copy) NSString       *country;
@property (copy) NSString       *state;
@property (copy) NSString       *city;
@property (copy) NSString       *zipcode;
@property (copy) NSString       *address;

@property (copy) NSString       *orgEmail;
@property (copy) NSString       *linkedInSearchUrl;


@property (strong) GGDataPage   *competitors;

-(NSString *)addressCityStateCountry;
//+(GGCompanyDigest *)instanceFromCompany:(GGCompany *)aCompany;
@end


/////////////////////////////////////
@interface GGCompany : GGCompanyDigest               

@property (strong)  NSMutableArray *socialProfiles; // each profile is a GGSocialProfile
@property (strong)  NSMutableArray *tickerSymbols; // each profile is a GGTicker
@property (strong)  NSMutableArray *divisions; // each profile is a GGCompanyBrief
@property (strong)  NSMutableArray *subsidiaries; // each profile is a GGCompanyBrief

@property (copy)    NSString *faxNumber;
@property (copy)    NSString *fiscalYear;
@property (assign)  BOOL      followed;
@property (copy)    NSString *founded;
@property (copy)    NSString *googleMapUrl;
@property (copy)    NSString *industries;
@property (copy)    NSString *description;
@property (copy)    NSString *nickName;
@property (copy)    NSString *shortName;
@property (copy)    NSString *profile;
@property (copy)    NSString *specialities;
@property (copy)    NSString *telephone;
@property (copy)    NSString *aliases;
@property (copy)    NSString *keywords;
@property (copy)    NSString *latestDate;
@property (copy)    NSString *revenuesChartUrl;

-(EGGCompanyType)getType;
@end
