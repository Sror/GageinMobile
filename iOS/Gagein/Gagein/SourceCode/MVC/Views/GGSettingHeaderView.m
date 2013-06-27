//
//  GGSettingHeaderView.m
//  Gagein
//
//  Created by dong yiming on 13-4-12.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSettingHeaderView.h"

@implementation GGSettingHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+(float)HEIGHT
{
    return 35.f;
}

-(void)awakeFromNib
{
    self.backgroundColor = GGSharedColor.graySettingBg;
}

-(void)setHightlighted:(BOOL)aHighlighted
{
    if (aHighlighted)
    {
        _lblTitle.textColor = GGSharedColor.orange;
    }
    else
    {
        _lblTitle.textColor = GGSharedColor.veryLightGray;
    }
}

-(void)usingFollowingStyle
{
    [_btnConfig setImage:[UIImage imageNamed:@"sandGlassBtn"] forState:UIControlStateNormal];
    
    if (_btnConfig.hidden)
    {
        _btnAdd.frame = _btnConfig.frame;
    }
}

@end
