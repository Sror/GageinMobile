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
@property (copy) NSString *fullName;
@property (copy) NSString *orgTitle;
@property (copy) NSString *orgID;
@property (copy) NSString *orgName;
@property (copy) NSString *orgWebsite;
@property (copy) NSString *orgAddress;

@property (copy) NSString *photoPath;
@property (copy) NSString *orgDept;
@property (copy) NSString *division;
@property (copy) NSString *description;
@property (copy) NSString *specialties;
@property (copy) NSString *email;
@property (copy) NSString *mobilephone;

@property (copy) NSString *jobFunc;
@property (copy) NSString *jobLevel;
@property (copy) NSString *addAddress;
@property (copy) NSString *timezone;
@end
