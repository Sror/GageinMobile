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
    
    _logoIV.layer.borderColor = GGSharedColor.silver.CGColor;
    _logoIV.layer.borderWidth = 1;
    
    _logoIV.layer.shadowColor = GGSharedColor.lightGray.CGColor;
    _logoIV.layer.shadowOpacity = .2f;
    _logoIV.layer.shadowOffset = CGSizeMake(-1, 1);
    _logoIV.layer.shadowRadius = 2;
    
    _logoIV.layer.cornerRadius = 3;
    
    
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
    float titleMaxY = CGRectGetMaxY(_titleLbl.frame);
    CGRect theRect = _descriptionLbl.frame;
    theRect.origin.y = titleMaxY - 30;
    _descriptionLbl.frame = theRect;
    
    theRect = self.frame;
    theRect.size.height = CGRectGetMaxY(_descriptionLbl.frame) - 20;
    //DLog(@"cell height:%f", theRect.size.height);
    self.frame = theRect;
    
    return theRect.size.height;
}

@end
