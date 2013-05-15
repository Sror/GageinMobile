//
//  GGCompanyUpdateCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-7.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyUpdateCell.h"


@implementation GGCompanyUpdateCell

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
    //_titleLbl.textColor = GGSharedColor.orangeGagein;
    
    _logoIV.layer.borderColor = GGSharedColor.silver.CGColor;
    _logoIV.layer.borderWidth = 1;
    
    _titleLbl.numberOfLines = 3;
}

+(float)HEIGHT
{
    return 120.f;
}

-(void)setHasBeenRead:(BOOL)hasRead
{
    if (hasRead)
    {
        _titleLbl.textColor = GGSharedColor.black;
    }
    else
    {
        _titleLbl.textColor = GGSharedColor.orangeGageinDark;
    }
}

-(void)adjustLayout
{
    float titleMaxY = CGRectGetMaxY(_titleLbl.frame);
    CGRect descRc = _descriptionLbl.frame;
    descRc.origin.y = titleMaxY - 5;
    descRc.size.height = self.contentView.frame.size.height - titleMaxY;
    _descriptionLbl.frame = descRc;
}

@end
