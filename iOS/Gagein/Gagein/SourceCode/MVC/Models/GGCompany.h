//
//  GGCompany.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

@class GGSocialProfile;

@interface GGCompany : GGDataModel

@property (copy)    NSString *name;
@property (copy)    NSString *website;
@property (copy)    NSString *logoPath;
@property (copy)    NSString *employeeSize;
@property (copy)    NSString *fortuneRank;
@property (copy)    NSString *ownership;
@property (copy)    NSString *revenueSize;
@property (copy)    NSString *type;
@property (strong)  NSMutableArray *socialProfiles; // each profile is a GGSocialProfile
@property (copy)    NSString *address;
@property (copy)    NSString *faxNumber;
@property (copy)    NSString *fiscalYear;
@property (copy)    NSString *followed;
@property (assign)  int        founded;
@property (copy)    NSString *googleMapUrl;
@property (copy)    NSString *industries;
@property (copy)    NSString *description;
@property (copy)    NSString *nickName;
@property (copy)    NSString *shortName;
@property (copy)    NSString *profile;
@property (copy)    NSString *specialities;
@property (copy)    NSString *telephone;
@property (copy)    NSString *tickerSymbol;
@end
