//
//  GGUtils.h
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface GGUtils : NSObject
+(CGRect)setX:(float)aX rect:(CGRect)aRect;
+(CGRect)setY:(float)aY rect:(CGRect)aRect;
+(CGRect)setW:(float)aW rect:(CGRect)aRect;
+(CGRect)setH:(float)aH rect:(CGRect)aRect;

+(NSArray *)arrayWithArray:(NSArray *)anArray maxCount:(NSUInteger)aIndex;

+(UIImage *)imageFor:(UIImage *)anImage size:(CGSize)aNewSize;
+(NSString *)envString;
+(UIButton *)darkGrayButtonWithTitle:(NSString *)aTitle frame:(CGRect)aFrame;
+(UIBarButtonItem *)naviButtonItemWithTitle:(NSString *)aTitle target:(id)aTarget selector:(SEL)aSelector;

+(void)sendSmsTo:(NSArray *)aRecipients
            body:(NSString *)aBody
      vcDelegate:(UIViewController<MFMessageComposeViewControllerDelegate> *)aVcDelegate;




+(void)applyTableStyle1ToView:(UIView *)aView;
+(void)applyLogoStyleToView:(UIView *)aView;

+(EGGGroupedCellStyle)styleForArrayCount:(NSUInteger)aArrayCount atIndex:(NSUInteger)anIndex;

+(NSData *)dataFromBundleForFileName:(NSString *)aFileName type:(NSString *)aType;

+(NSArray *)timezones;

+(NSString*)stringByTrimmingLeadingWhitespaceOfString:(NSString *)aStr;

+(NSString *)stringForSnType:(EGGSnType)aSnType;


+(id)replaceFromNibForView:(UIView *)aView;
+(id)replaceView:(UIView *)aView inPlaceWithNewView:(UIView *)aNewView;

+(NSString *)stringWithChartUrl:(NSString *)aChartUrl width:(int)aWidth height:(int)aHeight;
+(NSString *)stringWithMapUrl:(NSString *)aMapUrl width:(int)aWidth height:(int)aHeight;

+(NSString *)appcodeString;


#pragma mark - version & build
+ (NSString *) appVersion;
+ (NSString *) appBuild;
+ (NSString *) appVersionBuild;

//+(CGRect)frameWithOrientation:(UIInterfaceOrientation)anOrientation rect:(CGRect)aRect;
+(CAAnimation *)animationTransactionPushed:(BOOL)aPushed;

+ (void)showTabBar; // animated by default
+ (void)showTabBarAnimated:(BOOL)aAnimated;
+ (void)hideTabBar; // animated by default
+ (void)hideTabBarAnimated:(BOOL)aAnimated;

+(NSString *)textForSourceType:(EGGHappeningSource)aSourceType;
+(EGGHappeningSource)sourceTypeForText:(NSString *)aText;

+(NSString *)testImageURL;

@end
