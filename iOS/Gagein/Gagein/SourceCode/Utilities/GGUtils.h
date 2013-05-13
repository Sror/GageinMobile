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

@end
