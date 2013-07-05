//
//  GGCompanyHappening.h
//  Gagein
//
//  Created by dong yiming on 13-4-17.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"
#import "GGCompany.h"

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
@property (copy) NSString       *oldPhotoPath;          // from oldProfilePic
@property (strong) NSMutableArray   *socialProfiles;
@property (copy) NSString           *actionType;

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
@property (copy) NSString                       *oldAddressMap;

@property (copy) NSString                       *photoPath;
@property (copy) NSString                       *profilePic;
@property (copy) NSString                       *oldProfilePic;

@property (strong) GGHappeningPerson            *person;

@property (strong) GGCompanyDigest           *company;
@property (strong) GGCompanyDigest           *oldCompany;
@property (strong) GGCompanyDigest           *contactCurrentCompany;

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
-(BOOL)isPersonEvent;
+(BOOL)isPersonEvent:(EGGHappeningType)aType;

-(NSString *)chartUrlWithSize:(CGSize)aSize;

-(NSString *)fundingText;
-(NSString *)roundText;

-(NSString *)currentTitle;
@end
