//
//  GGConfigSwitchView.m
//  Gagein
//
//  Created by Dong Yiming on 5/14/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGConfigSwitchView.h"

@implementation GGConfigSwitchView

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
    _btnSwitch = [GGUtils replaceFromNibForView:_btnSwitch];
    [_btnSwitch changeSkin:YES];
//    CGRect rcSwitch = self.btnSwitch.frame;
//    UIView *superView = self.btnSwitch.superview;
//    [self.btnSwitch removeFromSuperview];
//    self.btnSwitch = [GGSwitchButton viewFromNibWithOwner:self];
//    self.btnSwitch.frame = rcSwitch;
//    [superView addSubview:self.btnSwitch];
}

+(float)HEIGHT
{
    return 44.f;
}

@end
