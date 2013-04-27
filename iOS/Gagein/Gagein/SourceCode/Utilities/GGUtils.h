//
//  GGUtils.h
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGUtils : NSObject
+(CGRect)setX:(float)aX rect:(CGRect)aRect;
+(CGRect)setY:(float)aY rect:(CGRect)aRect;
+(CGRect)setW:(float)aW rect:(CGRect)aRect;
+(CGRect)setH:(float)aH rect:(CGRect)aRect;

+(NSArray *)arrayWithArray:(NSArray *)anArray maxCount:(NSUInteger)aIndex;
@end
