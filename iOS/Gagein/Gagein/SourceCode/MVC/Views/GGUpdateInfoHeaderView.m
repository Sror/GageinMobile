//
//  GGUpdateInfoHeaderView.m
//  Gagein
//
//  Created by Dong Yiming on 7/1/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGUpdateInfoHeaderView.h"

@implementation GGUpdateInfoHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    _ivCellBg.image = GGSharedImagePool.stretchShadowBgWite;
}

-(void)doLayout
{
    float thisWidth = self.frame.size.width;
    [_viewCellBg setWidth:(thisWidth - 10)];
    [_ivCellBg setWidth:_viewCellBg.frame.size.width];
    [_lblSource setWidth:_viewCellBg.frame.size.width - 20];
    [_lblSource setWidth:_viewCellBg.frame.size.width - 20 - _lblInterval.frame.size.width];
    
    [_lblTitle sizeToFitFixWidth];
    _lblTitle.backgroundColor = GGSharedColor.random;
    
    [_viewCellBg setHeight:(CGRectGetMaxY(_lblTitle.frame) + 5)];
    [_ivCellBg setHeight:_viewCellBg.frame.size.height];
    [self setHeight:_viewCellBg.frame.size.height + 10];
}

@end
