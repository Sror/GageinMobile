//
//  GGProfileFooterView.m
//  Gagein
//
//  Created by dong yiming on 13-4-27.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGProfileFooterView.h"

@implementation GGProfileFooterView

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
    [_btnUpgrade setBackgroundImage:GGSharedImagePool.bgBtnOrange forState:UIControlStateNormal];
}

+(float)HEIGHT
{
    return 100.f;
}

@end
