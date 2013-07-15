//
//  GGImagePool.m
//  Gagein
//
//  Created by dong yiming on 13-4-18.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGImagePool.h"

@implementation GGImagePool
DEF_SINGLETON(GGImagePool)

- (id)init
{
    self = [super init];
    if (self)
    {
        [self _doInit];
    }
    return self;
}


-(void)_doInit
{
    _placeholder = [UIImage imageNamed:@"placeholder.png"];
    
    _stretchShadowBgWite = [[UIImage imageNamed:@"shadowedBgWhite"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    _bgNavibar = [[UIImage imageNamed:@"bgNavibar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    _logoDefaultCompany = [UIImage imageNamed:@"logoCompanyDefaultV2"];//[UIImage imageNamed:@"logoDefaultCompany"];
    
    _logoDefaultPerson = [UIImage imageNamed:@"logoPersonDefaultV2"]; //[UIImage imageNamed:@"logoDefaultPerson"];
    
    _logoDefaultNews = [UIImage imageNamed:@"logoNewsDefaultV2"];//[UIImage imageNamed:@"logoNewsDefault"];
    
    _bgBtnOrange = [[UIImage imageNamed:@"orangeBtnBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 30, 10)];
    
    _bgBtnOrangeDarkEdge = [[UIImage imageNamed:@"btnYellowBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 30, 10)];
    
    _tableCellBottomBg = [[UIImage imageNamed:@"tableCellBottomBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    _tableCellMiddleBg = [[UIImage imageNamed:@"tableCellMiddleBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    _tableCellRoundBg = [[UIImage imageNamed:@"tableCellRoundBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    _tableCellTopBg = [[UIImage imageNamed:@"tableCellTopBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    _tableSelectedDot = [[UIImage imageNamed:@"tableSelectedDot"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    _tableUnselectedDot = [[UIImage imageNamed:@"tableUnselectedDot"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    _x = [UIImage imageNamed:@"x"];
}

@end
