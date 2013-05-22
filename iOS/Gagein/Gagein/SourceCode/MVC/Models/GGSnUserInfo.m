//
//  GGSnUserInfo.m
//  Gagein
//
//  Created by Dong Yiming on 5/21/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGSnUserInfo.h"

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
}

@end

/*"sn_token": "b68732d4-ebbd-4677-b3d4-12373d3be665",
 "sn_secret": "c632126c-cc31-4cb3-b4c8-9f4528d6bf1e",
 "sn_refresh_token": "",
 "sn_instance_url": "",
 "sn_first_name": "ä¸é¸£",
 "sn_last_name": "è£",
 "sn_email": "",
 "sn_account_id": "JW9P-IUQlw",
 "sn_account_name": "",
 "sn_profile_url": "http://www.linkedin.com/pub/%E4%B8%80%E9%B8%A3-%E8%91%A3/38/a13/852"*/
