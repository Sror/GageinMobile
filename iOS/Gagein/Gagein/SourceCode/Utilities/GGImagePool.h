//
//  GGImagePool.h
//  Gagein
//
//  Created by dong yiming on 13-4-18.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGImagePool : NSObject
AS_SINGLETON(GGImagePool)

@property (strong) UIImage *placeholder;

@end

#define GGSharedImagePool [GGImagePool sharedInstance]
