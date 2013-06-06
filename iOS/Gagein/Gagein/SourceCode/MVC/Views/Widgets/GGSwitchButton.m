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
    [_btnSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
    [self changeSkin:NO];
    _viewOff.hidden = _isOn;
}

-(void)changeSkin:(BOOL)aIsLight
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, KNOB_RADIUS, 0, KNOB_RADIUS);
    if (aIsLight)
    {
        _ivBgOn.image = [[UIImage imageNamed:@"switch_on_light"] resizableImageWithCapInsets:edgeInsets];
        _ivBgOff.image = [[UIImage imageNamed:@"switch_off_light"] resizableImageWithCapInsets:edgeInsets];
        _ivKnobOff.image = _ivKnobOn.image = [UIImage imageNamed:@"switch_knob_light"];
    }
    else
    {
        _ivBgOn.image = [[UIImage imageNamed:@"switch_bg_orange"] resizableImageWithCapInsets:edgeInsets];
        _ivBgOff.image = [[UIImage imageNamed:@"switch_bg_gray"] resizableImageWithCapInsets:edgeInsets];
        _ivKnobOff.image = _ivKnobOn.image = [UIImage imageNamed:@"switch_knob_gray"];
    }
}

-(void)switchAction
{
    [self switchOn:!_isOn];
}

-(void)switchOn:(BOOL)aIsOn
{
    if (_isOn != aIsOn)
    {
        _isOn = aIsOn;
        _viewOff.hidden = _isOn;
        _viewOn.hidden = !_viewOff.hidden;
        [_delegate switchButton:self isOn:_isOn];
    }
}

-(void)setIsOn:(BOOL)aIsOn
{
    if (_isOn != aIsOn)
    {
        _isOn = aIsOn;
        _viewOff.hidden = _isOn;
    }
}

+(float)HEIGHT
{
    return KNOB_RADIUS + KNOB_RADIUS;
}

@end
