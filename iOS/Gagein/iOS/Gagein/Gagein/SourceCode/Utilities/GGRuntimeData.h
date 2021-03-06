//
//  GGRuntimeData.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGMember;

@interface GGRuntimeData : NSObject
AS_SINGLETON(GGRuntimeData)

@property (assign)  BOOL        runedBefore;  // has runed before
@property (strong)  GGMember    *currentUser;    // current user

-(BOOL)isLoggedIn;
-(BOOL)isFirstRun;
-(NSString *)accessToken;

-(void)saveRunedBefore;

-(void)saveCurrentUser;
-(void)loadCurrentUser;
-(void)resetCurrentUser;
@end

#define GGSharedRuntimeData [GGRuntimeData sharedInstance]
