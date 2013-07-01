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

@end
