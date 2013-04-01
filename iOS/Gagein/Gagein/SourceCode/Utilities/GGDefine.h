//
//  GGDefine.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GGN_STR_API_BASE_URL    @"https://www.gagein.com/svc/"


#undef	__INT
#define __INT( __x )			[NSNumber numberWithInt:(NSInteger)(__x)]

#undef	__UINT
#define __UINT( __x )			[NSNumber numberWithUnsignedInt:(NSUInteger)(__x)]

#undef	__LONG
#define __LONG( __x )			[NSNumber numberWithLong:(long)(__x)]

#undef	__LONGLONG
#define __LONGLONG( __x )			[NSNumber numberWithLongLong:(long long)(__x)]

#undef	__FLOAT
#define	__FLOAT( __x )			[NSNumber numberWithFloat:(float)(__x)]

#undef	__DOUBLE
#define	__DOUBLE( __x )			[NSNumber numberWithDouble:(double)(__x)]

#undef	__BOOL
#define	__BOOL( __x )			[NSNumber numberWithBool:(BOOL)(__x)]

@interface GGDefine : NSObject
@end
