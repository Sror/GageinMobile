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

-(UIColor *)darkRed;
-(UIColor *)white;
-(UIColor *)black;
-(UIColor *)gray;
-(UIColor *)lightGray;
-(UIColor *)veryLightGray;
-(UIColor *)darkGray;
-(UIColor *)clear;
@end

#define SharedColor [GGColor sharedInstance]
