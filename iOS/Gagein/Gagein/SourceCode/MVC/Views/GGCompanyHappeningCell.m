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
    
    [GGUtils applyLogoStyleToView:_ivLogo];
}

+(float)HEIGHT
{
    return 85;
}

-(void)setHasBeenRead:(BOOL)hasRead
{
    if (hasRead)
    {
        _lblDescription.textColor = GGSharedColor.gray;
    }
    else
    {
        _lblDescription.textColor = GGSharedColor.orangeGageinDark;
    }
}

@end
