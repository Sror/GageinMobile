//
//  GGRuntimeData.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGRuntimeData : NSObject
AS_SINGLETON(GGRuntimeData)

@property (copy)    NSString*   accessToken;  // access token for Gagein
@property (assign)  BOOL        runedBefore;  // has runed before

-(BOOL)isLoggedIn;
-(BOOL)isFirstRun;
@end
