//
//  GGMember.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGMember.h"
#import "GGCompany.h"
#import "GGMemberPlan.h"

#define kMemberID           @"kMemberID"
#define kMemberFullName     @"kMemberFullName"
#define kMemberOrgName      @"kMemberOrgName"
#define kMemberTimezone     @"kMemberTimezone"
#define kMemberAccountEmail         @"kMemberAccountEmail"
#define kMemberAccountPassword      @"kMemberAccountPassword"

#define kAccessToken        @"kAccessToken"

@implementation GGMember

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt64:self.ID forKey:kMemberID];
    [aCoder encodeObject:self.fullName forKey:kMemberFullName];
    [aCoder encodeObject:self.company.name forKey:kMemberOrgName];
    [aCoder encodeInt:self.timeZone forKey:kMemberTimezone];
    [aCoder encodeObject:self.accessToken forKey:kAccessToken];
    [aCoder encodeObject:self.accountEmail forKey:kMemberAccountEmail];
    [aCoder encodeObject:self.accountPassword forKey:kMemberAccountPassword];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    GGMember *member = [GGMember model];
    member.ID = [aDecoder decodeInt64ForKey:kMemberID];
    member.fullName = [aDecoder decodeObjectForKey:kMemberFullName];
    member.timeZone = [aDecoder decodeIntForKey:kMemberTimezone];
    member.accessToken = [aDecoder decodeObjectForKey:kAccessToken];
    member.accountEmail = [aDecoder decodeObjectForKey:kMemberAccountEmail];
    member.accountPassword = [aDecoder decodeObjectForKey:kMemberAccountPassword];
    
    member.company = [GGCompany model];
    member.company.name = [aDecoder decodeObjectForKey:kMemberOrgName];
    
    return member;
}

- (id)init
{
    self = [super init];
    if (self) {
        _plan = [GGMemberPlan model];
    }
    return self;
}

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"memid"] longLongValue];
    self.accessToken = [aData objectForKey:@"access_token"];
    self.fullName = [aData objectForKey:@"mem_full_name"];
    self.timeZone = [[aData objectForKey:@"mem_timezone"] intValue];
    self.company.name = [aData objectForKey:@"mem_orgname"];
    self.signupProcessStatus = [[aData objectForKey:@"signup_process_status"] intValue];
}

-(BOOL)isSignupOK
{
    return self.signupProcessStatus == 3 || self.signupProcessStatus == 4;
}

@end
