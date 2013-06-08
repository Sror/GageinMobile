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
    
    , kGGHappeningPersonUpdateProfilePic = 1001         // person change picture
    , kGGHappeningPersonJoinOtherCompany = 1002         // person change job
    , kGGHappeningPersonNewLocation = 1003              // person change location
    , kGGHappeningPersonNewJobTitle = 1004              // person change job title
    
}EGGHappeningType;


typedef enum {
    kGGHappeningSourceLindedIn = 2002
    , kGGHappeningSourceCrunchBase = 3001
    , kGGHappeningSourceYahoo = 3002
    , kGGHappeningSourceHoovers = 2006
}EGGHappeningSource;


//
@interface GGHappeningPerson : GGDataModel
@property (copy) NSString       *name;
@property (copy) NSString       *profile;
@property (assign) long long    contactID;
@property (copy) NSString       *contactName;

@property (assign) long long    orgID;
@property (copy) NSString       *orgName;
@property (copy) NSString       *orgTitle;
@property (assign) long long    jobLevel;

@property (copy) NSString       *address;
@property (copy) NSString       *linkedInID;
@property (copy) NSString       *photoPath;
@property (strong) NSMutableArray   *socialProfiles;
@property (copy) NSString           *actionType;

@end



//
@interface GGHappeningCompany : GGDataModel
@property (copy) NSString       *name;
@property (copy) NSString       *profile;

@property (assign) long long    orgID;
@property (copy) NSString       *orgName;
@property (copy) NSString       *orgWebSite;
@property (copy) NSString       *orgLogoPath;

@property (copy) NSString       *type;
@property (copy) NSString       *ownership;
@property (copy) NSString       *fortuneRank;
@property (copy) NSString       *revenueSize;
@property (copy) NSString       *employeeSize;

@property (copy) NSString       *country;
@property (copy) NSString       *state;
@property (copy) NSString       *city;
@property (copy) NSString       *zipcode;
@property (copy) NSString       *address;

-(NSString *)addressCityStateCountry;
@end

//
@interface GGHappeningRevenuePlot : GGDataModel
@property (assign) long long                period;
@property (assign) float                    revenue;
@end



//
@interface GGHappening : GGDataModel
@property (assign) long long                    timestamp;
@property (assign) long long                    newTimestamp;
@property (assign) long long                    oldTimestamp;
@property (assign) long long                    fundingTimestamp;

@property (assign) long long                    protocol;
@property (copy)    NSString                    *dateStr;

@property (assign) long long                    contactID;
@property (copy) NSString                       *name;

@property (copy) NSString                       *title;
@property (copy) NSString                       *jobTitle;
@property (copy) NSString                       *oldJobTitle;
@property (copy) NSString                       *theNewJobTitle;     // newJobTile, but cocoa used 'new-x' prefix

@property (copy) NSString                       *oldRevenue;
@property (copy) NSString                       *theNewRevenue;
@property (copy) NSString                       *percentage;
@property (copy) NSString                       *period;
@property (copy) NSString                       *revenueChart;
@property (copy) NSMutableArray                 *revenues;          // each one is a GGHappeningRevenuePlot

@property (copy) NSString                       *funding;
@property (copy) NSString                       *round;

@property (copy) NSString                       *oldEmployNum;
@property (copy) NSString                       *employNum;
@property (copy) NSString                       *direction;

@property (copy) NSString                       *address;
@property (copy) NSString                       *addressCompany;
@property (copy) NSString                       *addressCompanyOld;
@property (copy) NSString                       *addressPerson;
@property (copy) NSString                       *addressPersonOld;

@property (copy) NSString                       *addressMap;
//@property (copy) NSString                       *oldAddress;

@property (copy) NSString                       *photoPath;
@property (copy) NSString                       *profilePic;
@property (copy) NSString                       *oldProfilePic;

@property (strong) GGHappeningPerson            *person;

@property (strong) GGHappeningCompany           *company;
@property (strong) GGHappeningCompany           *oldCompany;

@property (copy) NSString                       *change;        // e.g. LEAVE
@property (assign) EGGHappeningType             type;
@property (assign) EGGHappeningSource           source;
@property (copy) NSString                       *sourceName;
@property (copy) NSString                       *messageStr; // only if param 'msg_format=text or html', this data is provided

@property (copy) NSString                       *orgID;
@property (copy) NSString                       *orgName;
@property (copy) NSString                       *orgLogoPath;

@property (assign)  BOOL                        hasBeenRead;

-(NSString *)sourceText;
-(NSString *)headLineText;

-(BOOL)isJoin;
@end
