//
//  GGEnvSwicher.h
//  Gagein
//
//  Created by Dong Yiming on 7/2/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGEnvSwicher : NSObject
AS_SINGLETON(GGEnvSwicher)
@property (readonly) NSString               *currentPath;
@property (readonly) EGGServerEnvironment   currentEnv;
-(void)switchToEnvironment:(EGGServerEnvironment)aEnvironment;

@end

#define GGSharedEnvSwicher  ([GGEnvSwicher sharedInstance])