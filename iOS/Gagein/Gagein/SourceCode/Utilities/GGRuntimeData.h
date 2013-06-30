//
//  GGRuntimeData.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGHappeningCache.h"
#import "GGCompetitorCache.h"
#import "GGUpdateCache.h"

@class GGMember;

@interface GGRuntimeData : NSObject
AS_SINGLETON(GGRuntimeData)

@property (assign)  BOOL                                            runedBefore;  // has runed before
@property (strong)  GGMember                                        *currentUser;    // current user
@property (readonly, nonatomic)  NSMutableArray                     *recentSearches;

@property (strong) GGHappeningCache                                 *happeningCache;
@property (strong) GGCompetitorCache                                *competitorsCache;
@property (strong) GGUpdateCache                                    *updateDetailCache;

@property (readonly, nonatomic)   EGGCompanyUpdateRelevance           relevance;
@property (strong)     NSMutableArray                      *snTypes;
@property (assign, nonatomic)       BOOL                    isLandscapeNeedMenu;


-(void)setRelevance:(EGGCompanyUpdateRelevance)aRelevance;

-(BOOL)isLoggedIn;
-(BOOL)isFirstRun;
-(NSString *)accessToken;

-(void)saveRunedBefore;

-(void)saveCurrentUser;
-(void)loadCurrentUser;
-(void)resetCurrentUser;

//-(void)saveRecentSearches;
-(void)saveKeyword:(NSString *)aKeyword;



@end

#define GGSharedRuntimeData [GGRuntimeData sharedInstance]
