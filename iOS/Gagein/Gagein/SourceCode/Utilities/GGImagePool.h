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

@property (strong, nonatomic) UIImage *placeholder;
@property (strong, nonatomic) UIImage  *stretchShadowBgWite;
@property (strong, nonatomic) UIImage  *bgNavibar;

@property (strong, nonatomic) UIImage  *logoDefaultCompany;
@property (strong, nonatomic) UIImage  *logoDefaultPerson;
@property (strong, nonatomic) UIImage  *logoDefaultNews;

@property (strong, nonatomic) UIImage  *bgBtnOrange;
@property (strong, nonatomic) UIImage  *bgBtnOrangeDarkEdge;

@property (strong, nonatomic) UIImage  *tableCellBottomBg;
@property (strong, nonatomic) UIImage  *tableCellMiddleBg;
@property (strong, nonatomic) UIImage  *tableCellRoundBg;
@property (strong, nonatomic) UIImage  *tableCellTopBg;
@property (strong, nonatomic) UIImage  *tableSelectedDot;
@property (strong, nonatomic) UIImage  *tableUnselectedDot;

@property (strong, nonatomic) UIImage   *x;
@property (strong, nonatomic) UIImage   *logoGageinWithName;

//@property (strong, nonatomic) UIImage  *tableCellRoundBg;
@end

#define GGSharedImagePool [GGImagePool sharedInstance]
