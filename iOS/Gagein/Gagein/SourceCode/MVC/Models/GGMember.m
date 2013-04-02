//
//  GGMember.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGMember.h"
#import "GGCompany.h"

#define kMemberID           @"kMemberID"
#define kMemberFullName     @"kMemberFullName"
#define kMemberOrgName      @"kMemberOrgName"
#define kMemberTimezone     @"kMemberTimezone"
#define kAccessToken        @"kAccessToken"

@implementation GGMember

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt64:self.ID forKey:kMemberID];
    [aCoder encodeObject:self.fullName forKey:kMemberFullName];
    [aCoder encodeObject:self.company.name forKey:kMemberOrgName];
    [aCoder encodeInt:self.timeZone forKey:kMemberTimezone];
    [aCoder encodeObject:self.accessToken forKey:kAccessToken];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    GGMember *member = [GGMember model];
    member.ID = [aDecoder decodeInt64ForKey:kMemberID];
    member.fullName = [aDecoder decodeObjectForKey:kMemberFullName];
    member.timeZone = [aDecoder decodeIntForKey:kMemberTimezone];
    member.accessToken = [aDecoder decodeObjectForKey:kAccessToken];
    member.company = [GGCompany model];
    member.company.name = [aDecoder decodeObjectForKey:kMemberOrgName];
    
    return member;
}

@end
