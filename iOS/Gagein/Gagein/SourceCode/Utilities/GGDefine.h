//
//  GGDefine.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

//
#define GGN_STR_PRODUCTION_SERVER_URL               @"https://www.gagein.com"
#define GGN_STR_DEMO_SERVER_URL                     @"http://gageindemo.dyndns.org"
#define GGN_STR_CN_SERVER_URL                       @"http://gageincn.dyndns.org:3031"


#define CURRENT_SERVER_URL         GGN_STR_DEMO_SERVER_URL

//

#define APP_CODE_VALUE      @"09ad5d624c0294d1"
//#define ACCESS_TOKEN_VALUE  @"4d861dfe219170e3c58c7031578028a5"

//
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

// 判断是否为IPAD
#define ISIPADDEVICE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// 单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

//LOG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#ifdef DEBUG
#define DALog(fmt, ...)  { UIAlertView *alert = [[OTSAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#define DALog(...)
#endif

//
@interface GGDefine : NSObject
@end
