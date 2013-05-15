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
@property (strong) UIImage  *stretchShadowBgWite;
@property (strong) UIImage  *bgNavibar;
@property (strong) UIImage  *logoDefaultCompany;
@property (strong) UIImage  *logoDefaultPerson;
@property (strong) UIImage  *bgBtnOrange;

@property (strong) UIImage  *tableCellBottomBg;
@property (strong) UIImage  *tableCellMiddleBg;
@property (strong) UIImage  *tableCellRoundBg;
@property (strong) UIImage  *tableCellTopBg;
@property (strong) UIImage  *tableSelectedDot;
@property (strong) UIImage  *tableUnselectedDot;
@end

#define GGSharedImagePool [GGImagePool sharedInstance]
