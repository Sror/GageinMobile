//
//  GGCompanyHappening.h
//  Gagein
//
//  Created by dong yiming on 13-4-17.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

typedef enum {
    kGGHappeningCompanyPersonJion = 2001
    , kGGHappeningCompanyPersonJionDetail = 2002
    , kGGHappeningCompanyRevenueChange = 2003
    , kGGHappeningCompanyNewFunding = 2004
    , kGGHappeningCompanyNewLocation = 2005
    , kGGHappeningCompanyEmloyeeSizeIncrease = 2006
    , kGGHappeningCompanyEmloyeeSizeDecrease = 2007
    
    , kGGHappeningPersonUpdateProfilePic = 1001
    , kGGHappeningPersonJoinOtherCompany = 1002
    , kGGHappeningPersonNewLocation = 1003
    , kGGHappeningPersonNewJobTitle = 1004
    
}EGGHappeningType;


typedef enum {
    kGGHappeningSourceLindedIn = 2002
    , kGGHappeningSourceCrunchBase = 3001
    , kGGHappeningSourceYahoo = 3002
    , kGGHappeningSourceHoovers = 2006
}EGGHappeningSource;


@interface GGCompanyHappeningPerson : GGDataModel
@property (copy) NSString       *name;
@property (copy) NSString       *profile;
@end

@interface GGCompanyHappeningCompany : GGDataModel
@property (copy) NSString       *name;
@property (copy) NSString       *profile;
@end

@interface GGCompanyHappening : GGDataModel
@property (assign) long long                    timestamp;
@property (copy) NSString                       *jobTitle;
@property (strong) GGCompanyHappeningPerson      *person;
@property (strong) GGCompanyHappeningPerson      *company;
@property (copy) NSString                       *change;        // e.g. LEAVE
@property (assign) EGGHappeningType             type;
@property (assign) EGGHappeningSource           source;
@property (copy) NSString                       *orgID;
@property (copy) NSString                       *orgName;
@property (copy) NSString                       *orgLogoPath;

-(NSString *)sourceText;
-(NSString *)headLineText;
@end
