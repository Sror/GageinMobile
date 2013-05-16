//
//  GGUserProfile.h
//  Gagein
//
//  Created by dong yiming on 13-5-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"



@interface GGUserProfile : GGDataModel

@property (copy) NSString *firstName;
@property (copy) NSString *lastName;
@property (copy) NSString *email;
@property (copy) NSString *orgTitle;
@property (copy) NSString *timezone;
@property (copy) NSString *orgID;
@property (copy) NSString *orgName;
@property (copy) NSString *orgWebsite;
@property (copy) NSString *orgLogoPath;
@property (assign) long long planID;
@property (copy) NSString *planName;

//@property (copy) NSString *fullName;
//@property (copy) NSString *orgAddress;
//@property (copy) NSString *photoPath;
//@property (copy) NSString *orgDept;
//@property (copy) NSString *division;
//@property (copy) NSString *description;
//@property (copy) NSString *specialties;
//@property (copy) NSString *mobilephone;
//@property (copy) NSString *jobFunc;
//@property (copy) NSString *jobLevel;
//@property (copy) NSString *addAddress;

@end
