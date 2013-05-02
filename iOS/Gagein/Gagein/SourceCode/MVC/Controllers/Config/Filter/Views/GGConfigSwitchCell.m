//
//  GGConfigSwitchCell.m
//  Gagein
//
//  Created by dong yiming on 13-5-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGConfigSwitchCell.h"

@implementation GGConfigSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib
{
    CGRect rcSwitch = self.btnSwitch.frame;
    UIView *superView = self.btnSwitch.superview;
    [self.btnSwitch removeFromSuperview];
    self.btnSwitch = [GGSwitchButton viewFromNibWithOwner:self];
    self.btnSwitch.frame = rcSwitch;
    [superView addSubview:self.btnSwitch];
}

+(float)HEIGHT
{
    return 44.f;
}

@end
