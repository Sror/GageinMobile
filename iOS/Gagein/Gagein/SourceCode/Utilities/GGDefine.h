//
//  GGDefine.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kGGServerProduction = 1
    , kGGServerDemo
    , kGGServerCN
    , kGGServerStaging
    , kGGServerRoshen
}EGGServerEnvironment;

typedef enum {
    kGGGroupCellFirst = 0
    , kGGGroupCellMiddle
    , kGGGroupCellLast
    , kGGGroupCellRound
}EGGGroupedCellStyle;

typedef enum {
    kGGHappeningSourceLindedIn = 2002
    , kGGHappeningSourceCrunchBase = 3001
    , kGGHappeningSourceYahoo = 3002
    , kGGHappeningSourceHoovers = 2006
    
    , kGGHappeningSourceFacebook = 10000
    , kGGHappeningSourceTwitter
    , kGGHappeningSourceYoutube
    , kGGHappeningSourceSlideShare
    
    , kGGHappeningSourceUnKnown = 99999
}EGGHappeningSource;

#define SOURCE_TEXT_LINKEDIN        @"Linkedin"
#define SOURCE_TEXT_FACEBOOK        @"Facebook"
#define SOURCE_TEXT_TWITTER         @"Twitter"
#define SOURCE_TEXT_YOUTUBE         @"Youtube"
#define SOURCE_TEXT_SLIDE_SHARE     @"Slideshare"
#define SOURCE_TEXT_HOOVERS         @"Hoovers"
#define SOURCE_TEXT_YAHOO           @"Yahoo"
#define SOURCE_TEXT_CRUNCHBASE      @"CrunchBase"



//
#define GGN_STR_PRODUCTION_SERVER_URL               @"https://www.gagein.com"
#define GGN_STR_DEMO_SERVER_URL                     @"http://gageindemo.dyndns.org"
#define GGN_STR_CN_SERVER_URL                       @"http://gageincn.dyndns.org:3031"
#define GGN_STR_STAGING_SERVER_URL                  @"http://gageinstaging.dyndns.org"
#define GGN_STR_ROSHEN_SERVER_URL                   @"http://192.168.137.1:8080"

#define CURRENT_ENV 1

#undef CURRENT_SERVER_URL
#if (CURRENT_ENV == 1)
#define CURRENT_SERVER_URL         GGN_STR_PRODUCTION_SERVER_URL
#elif (CURRENT_ENV == 2)
#define CURRENT_SERVER_URL         GGN_STR_DEMO_SERVER_URL
#elif (CURRENT_ENV == 3)
#define CURRENT_SERVER_URL         GGN_STR_CN_SERVER_URL
#elif (CURRENT_ENV == 4)
#define CURRENT_SERVER_URL         GGN_STR_STAGING_SERVER_URL
#elif (CURRENT_ENV == 5)
#define CURRENT_SERVER_URL         GGN_STR_ROSHEN_SERVER_URL
#endif
//

#define APP_CODE_VALUE      @"09ad5d624c0294d1"
#define APP_CODE_IPHONE     @"78cfc17502a1e05a"
#define APP_CODE_IPAD       @"c0d67d02e7c74d36"

#define SAMPLE_TEXT         @"This is a sample text for testing, this is a sample text for testing, this is a sample text for testing, this is a sample text for testing, this is a sample text for testing, this is a sample text for testing, this is a sample text for testing, this is a sample text for testing, this is a sample text for testing"

#define GAGEIN_SLOGAN       @"a sales intelligence company"

#define GGString(key) NSLocalizedString((key), @"")

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
//#ifdef NEVER_DEFINED
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
#define GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT 216.f
#define GG_KEY_BOARD_HEIGHT_IPHONE_LANDSCAPE 162.f

#define SLIDE_SETTING_VIEW_WIDTH    260

#define IPAD_CONTENT_WIDTH          650
#define IPAD_CONTENT_WIDTH_FULL     768

#define LEFT_DRAWER_WIDTH           260
#define LEFT_DRAWER_WIDTH_LONG      320


// ios version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)




//
@interface GGDefine : NSObject
@end
