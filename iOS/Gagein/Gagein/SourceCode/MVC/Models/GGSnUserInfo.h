//
//  GGSnUserInfo.h
//  Gagein
//
//  Created by Dong Yiming on 5/21/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

@interface GGSnUserInfo : GGDataModel
@property (copy)    NSString    *token;
@property (copy)    NSString    *secret;
@property (copy)    NSString    *refreshToken;
@property (copy)    NSString    *instanceUrl;
@property (copy)    NSString    *firstName;
@property (copy)    NSString    *lastName;
@property (copy)    NSString    *email;
@property (copy)    NSString    *accountID;
@property (copy)    NSString    *accountName;
@property (copy)    NSString    *profileURL;

@property (assign)  EGGSnType   snType;

@end

