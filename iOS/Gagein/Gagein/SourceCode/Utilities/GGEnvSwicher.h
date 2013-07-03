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



@end

#define GGSharedEnvSwicher  ([GGEnvSwicher sharedInstance])