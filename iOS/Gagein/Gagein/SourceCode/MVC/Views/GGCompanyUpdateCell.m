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
    _titleLbl.text = @"";
    _intervalLbl.text = @"";
    
    [GGUtils applyLogoStyleToView:_logoIV];
    
    _titleLbl.numberOfLines = 3;
    _descriptionLbl.numberOfLines = 2;
}

//+(float)HEIGHT
//{
//    return 150.f;
//}

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

-(float)adjustLayout
{
    //_descriptionLbl.backgroundColor = GGSharedColor.darkGray;
    //NSString * text = _descriptionLbl.text;
    
    CGRect theRect = _titleLbl.frame;
    float titleMaxY = CGRectGetMaxY(theRect);
    theRect = _descriptionLbl.frame;
    theRect.origin.y = titleMaxY;
    _descriptionLbl.frame = theRect;
    
    theRect = self.viewCellBg.frame;
    theRect.size.height = CGRectGetMaxY(_descriptionLbl.frame);
    self.viewCellBg.frame = theRect;
    
    theRect = self.frame;
    theRect.size.height = CGRectGetMaxY(_viewCellBg.frame) + 5;
    self.frame = theRect;
    
    return theRect.size.height;
}

@end
