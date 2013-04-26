//
//  GGPerson.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

@class GGCompany;

@interface GGPerson : GGDataModel

@property (copy)    NSString *name;
@property (copy)    NSString *fullName;
@property (copy)    NSString *orgTitle;
@property (copy)    NSString *jobLevel;
@property (copy)    NSString *photoPath;
@property (copy)    NSString *linkedInID;
@property (copy)    NSString *actionType;
@property (copy)    NSString *address;

@property (strong)  GGCompany *company;
@property (strong)  NSMutableArray  *socialProfiles;    // each element is a GGSocialProfile

@property (assign) BOOL     followed;
@end
