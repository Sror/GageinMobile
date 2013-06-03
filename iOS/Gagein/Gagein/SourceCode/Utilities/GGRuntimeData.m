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
#define kDefaultKeyRunedBefore @"kDefaultKeyRunedBefore"

@implementation GGRuntimeData
DEF_SINGLETON(GGRuntimeData)

-(id)init
{
    self = [super init];
    if (self) {
        [self loadCurrentUser];
        [self _loadRunedBefore];
        [self _loadRecentSearches];
    }
    return self;
}

-(BOOL)isLoggedIn
{
    return self.accessToken.length;
}

-(BOOL)isFirstRun
{
    BOOL firstRun = !_runedBefore;
    if (firstRun) {
        _runedBefore = YES;
        [self saveRunedBefore];
    }
    return firstRun;
}

-(NSString *)accessToken
{
    return self.currentUser.accessToken;
}

-(void)_loadRunedBefore
{
    _runedBefore = [[NSUserDefaults standardUserDefaults] boolForKey:kDefaultKeyRunedBefore];
}

-(void)saveRunedBefore
{
    [[NSUserDefaults standardUserDefaults] setBool:_runedBefore forKey:kDefaultKeyRunedBefore];
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

-(void)resetCurrentUser
{
    [GGPath removePath:[GGPath pathCurrentUserData]];
    self.currentUser = nil;
}

#pragma mark - recent searches
-(void)_loadRecentSearches
{
    if (_recentSearches == nil)
    {
        _recentSearches = [NSMutableArray array];
        [_recentSearches addObjectsFromArray:[[NSArray alloc] initWithContentsOfFile:[GGPath pathRecentSearches]]];
    }
}

-(void)_saveRecentSearches
{
    [GGPath ensurePathExists:[GGPath savedDataPath]];
    [_recentSearches writeToFile:[GGPath pathRecentSearches] atomically:YES];
}

-(void)saveKeyword:(NSString *)aKeyword
{
    if (aKeyword.length)
    {
       // int keywordIndex = -1;
        int count = _recentSearches.count;
        for (int i = 0; i < count; i++)
        {
            NSString *recentSearch = _recentSearches[i];
            if ([recentSearch isEqualToString:aKeyword])
            {
                [_recentSearches removeObject:recentSearch];
                break;
            }
        }
        
//        if (keywordIndex >= 0)
//        {
//            id obj = _recentSearches[keywordIndex];
//            [_recentSearches removeObject:obj];
//        }
        
        [_recentSearches insertObject:aKeyword atIndex:0];
        
        
        // limit max recent searches count to 5
        while (_recentSearches.count > 5)
        {
            [_recentSearches removeLastObject];
        }
        
        [self _saveRecentSearches];
    }
}

@end
