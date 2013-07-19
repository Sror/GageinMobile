//
//  GGSnUserInfo.m
//  Gagein
//
//  Created by Dong Yiming on 5/21/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGSnUserInfo.h"

@implementation GGAutoLoginInfo

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    _accessToken = [aData objectForKey:@"access_token"];
    _memberID = [[aData objectForKey:@"memid"] longLongValue];
    _memberEmail = [aData objectForKey:@"mem_email"];
    _memberFullName = [aData objectForKey:@"mem_full_name"];
    _memberTimeZone = [aData objectForKey:@"mem_timezone"];
    _signupProcessStatus = [[aData objectForKey:@"signup_process_status"] intValue];
}

@end

////////////////////////////////////////////////
@implementation GGSnUserInfo
-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.token = [aData objectForKey:@"sn_token"];
    self.secret = [aData objectForKey:@"sn_secret"];
    self.refreshToken = [aData objectForKey:@"sn_refresh_token"];
    self.instanceUrl = [aData objectForKey:@"sn_instance_url"];
    self.firstName = [aData objectForKey:@"sn_first_name"];
    self.lastName = [aData objectForKey:@"sn_last_name"];
    self.email = [aData objectForKey:@"sn_email"];
    self.accountID = [aData objectForKey:@"sn_account_id"];
    self.accountName = [aData objectForKey:@"sn_account_name"];
    self.profileURL = [aData objectForKey:@"sn_profile_url"];
    _emailExisted = [aData objectForKey:@"email_existed"];
    
    NSArray *autoLoginInfoArr = [aData objectForKey:@"auto_login_info"];
    _autoLoginInfos = (autoLoginInfoArr.count) ? [NSMutableArray array] : nil;
    for (id infoDic in autoLoginInfoArr)
    {
        GGAutoLoginInfo *info = [GGAutoLoginInfo model];
        [info parseWithData:infoDic];
        [_autoLoginInfos addObject:info];
    }
}

@end

/*
    "status": "1",
    "msg": "ok",
    "data": {
        "sn_token": "57eaba2c-9005-483c-84d9-77c32bb6ff03",
        "sn_secret": "c94a9503-3e59-44d7-8c59-21930cf95b9c",
        "sn_refresh_token": "",
        "sn_instance_url": "",
        "sn_first_name": "ä¸é¸£",
        "sn_last_name": "è£",
        "sn_email": "",
        "sn_account_id": "dqm-qSr-WU",
        "sn_account_name": "",
        "sn_profile_url": "http://www.linkedin.com/pub/%E4%B8%80%E9%B8%A3-%E8%91%A3/38/a13/852",
        "auto_login_info": [
                            {
                                "access_token": "d9bbcd680a94bc1d3a46e31151b7ecb4",
                                "memid": "20129",
                                "mem_email": "1@q.com",
                                "mem_full_name": "adjhasgdjahs hjagsdjhasdg",
                                "mem_timezone": "US/Eastern", 
                                "signup_process_status": "3"
                            }
                            ]
    }
*/
