//
//  GGRelevanceBar.m
//  Gagein
//
//  Created by dong yiming on 13-4-27.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGRelevanceBar.h"
#import "GGSwitchButton.h"

@implementation GGRelevanceBar

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
    CGRect switchRc = self.btnSwitch.frame;
    [self.btnSwitch removeFromSuperview];
    self.btnSwitch = [GGSwitchButton viewFromNibWithOwner:self];
    [self.btnSwitch changeSkin:YES];
    self.btnSwitch.frame = switchRc;
    self.btnSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.btnSwitch];
}

+(float)HEIGHT
{
    return 40.f;
}

@end
