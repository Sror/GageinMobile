//
//  GGSwitchButton.m
//  TestCostomSwitch
//
//  Created by dong yiming on 13-4-23.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSwitchButton.h"

#define KNOB_RADIUS     12

@interface GGSwitchButton ()
@end

@implementation GGSwitchButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isOn = YES;
    }
    return self;
}

-(void)awakeFromNib
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, KNOB_RADIUS, 0, KNOB_RADIUS);
    _ivBgOn.image = [[UIImage imageNamed:@"switch_bg_orange"] resizableImageWithCapInsets:edgeInsets];
    _ivBgOff.image = [[UIImage imageNamed:@"switch_bg_gray"] resizableImageWithCapInsets:edgeInsets];
    [_btnSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
    _viewOff.hidden = _isOn;
}

-(void)switchAction
{
    _isOn = !_isOn;
    _viewOff.hidden = _isOn;
    [_delegate switchButton:self isOn:_isOn];
}

+(float)HEIGHT
{
    return KNOB_RADIUS + KNOB_RADIUS;
}

@end
