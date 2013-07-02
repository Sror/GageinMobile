//
//  GGCompanyHappeningCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-17.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyHappeningCell.h"

@implementation GGCompanyHappeningCell

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
    
    _ivLogo.layer.borderColor = GGSharedColor.silver.CGColor;
    _ivLogo.layer.borderWidth = 1;
    
    [_ivLogo applyEffectShadowAndBorder];
    
    _lblInterval.textColor = GGSharedColor.grayTopText;
    _lblName.textColor = GGSharedColor.grayTopText;
}

+(float)HEIGHT
{
    return 95.f;
}

-(void)applyCircleLogo
{
    [_ivLogo applyEffectCircleSilverBorder];
}

-(void)setHasBeenRead:(BOOL)hasRead
{
    if (hasRead)
    {
        _lblDescription.textColor = GGSharedColor.gray;
    }
    else
    {
        _lblDescription.textColor = GGSharedColor.black;
    }
}

@end
