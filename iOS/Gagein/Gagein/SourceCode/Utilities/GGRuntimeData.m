//
//  GGRuntimeData.m
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGRuntimeData.h"
#import "GGMember.h"
#import "GGPath.h"

#define kDataKeyCurrentUser @"kDataKeyCurrentUser"

@implementation GGRuntimeData
DEF_SINGLETON(GGRuntimeData)

-(id)init
{
    self = [super init];
    if (self) {
        [self loadCurrentUser];
    }
    return self;
}

-(BOOL)isLoggedIn
{
    return self.accessToken.length;
}

-(BOOL)isFirstRun
{
    return !self.runedBefore;
}

-(NSString *)accessToken
{
    return self.currentUser.accessToken;
}

-(void)saveCurrentUser
{
    [GGPath ensurePathExists:[GGPath savedDataPath]];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.currentUser forKey:kDataKeyCurrentUser];
    [archiver finishEncoding];
    [data writeToFile:[GGPath pathCurrentUserData] atomically:YES];
}

-(void)loadCurrentUser
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:[GGPath pathCurrentUserData]];
    if (data) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.currentUser = [unarchiver decodeObjectForKey:kDataKeyCurrentUser];
    }
}
@end
