//
//  GGCompanyDetailOverviewCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-19.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyDetailOverviewCell.h"

@implementation GGCompanyDetailOverviewCell

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
    self.viewCellBg.backgroundColor = GGSharedColor.silver;
    self.ivBg.image = GGSharedImagePool.stretchShadowBgWite;
}

+(float)HEIGHT
{
    return 130.f;
}

-(void)doLayout
{
    CGSize contentSize = self.viewBg.frame.size;
    if (_lblDescription.text.length <= 0)
    {
        if (_lblIndustry.text.length && _lblAddress.text.length)
        {
            float posY = (contentSize.height - (_lblIndustry.frame.size.height + _lblAddress.frame.size.height)) / 2;
            [_lblIndustry setPosY:posY];
            [_lblAddress setPosY:CGRectGetMaxY(_lblIndustry.frame)];
        }
        else if (_lblIndustry.text.length)
        {
            float posY = (contentSize.height - _lblIndustry.frame.size.height) / 2;
            [_lblIndustry setPosY:posY];
        }
        else if (_lblAddress.text.length)
        {
            float posY = (contentSize.height - _lblAddress.frame.size.height) / 2;
            [_lblAddress setPosY:posY];
        }
        else
        {
            _lblDescription.text = @"Check out more...";
        }
    }
}

@end
