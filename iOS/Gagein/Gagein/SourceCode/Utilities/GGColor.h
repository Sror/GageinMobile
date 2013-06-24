//
//  OTSColor.h
//  OneStore
//
//  Created by Yim Daniel on 13-1-17.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGColor : NSObject
AS_SINGLETON(GGColor)

-(UIColor *)clear;
-(UIColor *)darkRed;
-(UIColor *)orange;
-(UIColor *)orangeGagein;
-(UIColor *)orangeGageinDark;
-(UIColor *)white;
-(UIColor *)black;
-(UIColor *)gray;
-(UIColor *)lightGray;
-(UIColor *)veryLightGray;
-(UIColor *)darkGray;
-(UIColor *)ironGray;
-(UIColor *)bgGray;
-(UIColor *)graySettingBg;
-(UIColor *)silver;

-(UIColor *)colorFromR:(int)aRed g:(int)aGreen b:(int)aBlue;
-(UIColor *)random;

@end

#define GGSharedColor [GGColor sharedInstance]
