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
@end

#define GGSharedImagePool [GGImagePool sharedInstance]
