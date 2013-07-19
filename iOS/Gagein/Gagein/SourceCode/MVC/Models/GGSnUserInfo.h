//
//  GGSnUserInfo.h
//  Gagein
//
//  Created by Dong Yiming on 5/21/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"


@interface GGAutoLoginInfo : GGDataModel
@property (copy)    NSString    *accessToken;
@property (assign)  long long   memberID;
@property (copy)    NSString    *memberEmail;
@property (copy)    NSString    *memberFullName;
@property (copy)    NSString    *memberTimeZone;
@property (assign)  int         signupProcessStatus;
@end

//////////////////////////////////////////////////////////////
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
@property (assign)  BOOL        emailExisted;

@property (strong) NSMutableArray   *autoLoginInfos;

@property (assign)  EGGSnType   snType;

@end

