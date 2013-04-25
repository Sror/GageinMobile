//
//  GGHappeningDetailCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-25.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGHappeningDetailCell.h"

@implementation GGHappeningDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    self.ivCellBg.image = GGSharedImagePool.stretchShadowBgWite;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.ivChangeLeft.layer.cornerRadius = 5;
    self.ivChangeLeft.layer.borderColor = GGSharedColor.silver.CGColor;
    self.ivChangeLeft.layer.borderWidth = 2;
    
    self.ivChangeRight.layer.cornerRadius = 5;
    self.ivChangeRight.layer.borderColor = GGSharedColor.silver.CGColor;
    self.ivChangeRight.layer.borderWidth = 2;
}

-(float)height
{
    return self.frame.size.height;
}

-(void)showChangeLeftImage:(BOOL)aShow
{
    _ivChangeLeft.hidden = !aShow;
    _viewChangeLeft.hidden = YES;
}

-(void)showChangeRightImage:(BOOL)aShow
{
    _ivChangeRight.hidden = !aShow;
    _viewChangeRight.hidden = YES;
}

-(void)showChangeLeftText:(BOOL)aShow
{
    _viewChangeLeft.hidden = !aShow;
    _ivChangeLeft.hidden = YES;
}

-(void)showChangeRightText:(BOOL)aShow
{
    _viewChangeRight.hidden = !aShow;
    _ivChangeRight.hidden = YES;
}

-(void)showChart:(BOOL)aShow
{
    _ivChart.hidden = !aShow;
    _viewChange.hidden = YES;
}

-(void)showChangeView:(BOOL)aShow
{
    _viewChange.hidden = !aShow;
    _ivChart.hidden = YES;
}

@end
