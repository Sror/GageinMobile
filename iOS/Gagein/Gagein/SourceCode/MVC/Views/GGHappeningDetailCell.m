//
//  GGHappeningDetailCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-25.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGHappeningDetailCell.h"
#import "GGAutosizingLabel.h"

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
    self.ivChangeLeft.layer.masksToBounds = YES;
    
    self.ivChangeRight.layer.cornerRadius = 5;
    self.ivChangeRight.layer.borderColor = GGSharedColor.silver.CGColor;
    self.ivChangeRight.layer.borderWidth = 2;
    self.ivChangeRight.layer.masksToBounds = YES;
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

-(void)reset
{
    [_ivChangeLeft removeAllGestureRecognizers];
    [_ivChangeRight removeAllGestureRecognizers];
    [_ivChart removeAllGestureRecognizers];
    
    _ivChangeLeft.image = nil;
    _ivChangeRight.image = nil;
    
    _lblChangeLeftTitle.text = _lblChangeLeftSubTitle.text
    = _lblChangeRightTitle.text = _lblChangeRightSubTitle.text = @"";
}



-(void)adjustLayout
{
    CGRect headLineRc = _lblHeadline.frame;
    
    // chart
    CGRect chartRc = _viewChart.frame;
    chartRc.origin.y = CGRectGetMaxY(headLineRc) + 10;
    _viewChart.frame = chartRc;
    
    // change graph view
    CGRect changeRc = _viewChange.frame;
    changeRc.origin.y = chartRc.origin.y;
    _viewChange.frame = changeRc;
    
    // adjust bg height
    CGRect bgRc = _viewCellBg.frame;
    bgRc.origin.y = 5;
    if (!_viewChange.hidden)
    {
        bgRc.size.height = CGRectGetMaxY(changeRc) + 5;
    }
    else
    {
        bgRc.size.height = CGRectGetMaxY(chartRc) + 5;
    }
    _viewCellBg.frame = bgRc;
    
//    // bg image
//    CGRect bgImgRc = self.ivCellBg.frame;
//    bgImgRc.size.height = bgRc.size.height;
//    bgImgRc.size.width = bgRc.size.width;
//    _ivCellBg.frame = bgImgRc;
    
    //
    CGRect thisRc = self.frame;
    thisRc.size.height = CGRectGetMaxY(bgRc) + 5;
    self.frame = thisRc;
    
}

//-(float)height
//{
//    return self.frame.size.height;
//}

-(float)height
{
    CGRect headLineRc = _lblHeadline.frame;
    float height = CGRectGetMaxY(headLineRc) + 10;
    
    if (!_viewChange.hidden)
    {
        height += _viewChange.frame.size.height + 5;
    }
    else
    {
        height += _viewChart.frame.size.height + 5;
    }
    
    return height + 10;
}

@end
