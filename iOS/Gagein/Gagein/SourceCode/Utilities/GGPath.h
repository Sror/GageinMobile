//
//  GGPath.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGPath : NSObject
+(NSString*)docPath;
+(NSString *)savedDataPath;
+(NSString *)pathCurrentUserData;

+(NSString *)ensurePathExists:(NSString *)aPath;
@end
