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
    CGRect titleRc = _titleLbl.frame;
    UILabel * newTitleLbl = [GGCompanyUpdateCell labelForUpdateCellWithFrame:titleRc];
    _titleLbl = [GGUtils replaceView:_titleLbl inPlaceWithNewView:newTitleLbl];
    
    _intervalLbl.text = @"";
    
    [GGUtils applyLogoStyleToView:_logoIV];
    
    _titleLbl.numberOfLines = 3;
    _descriptionLbl.numberOfLines = 2;
}

+(UILabel*)labelForUpdateCellWithFrame:(CGRect)aRect
{
    UILabel *label = [[UILabel alloc] initWithFrame:aRect];
    label.backgroundColor = GGSharedColor.clear;
    label.font = [UIFont fontWithName:@"Optima-Bold" size:15.f];
    label.textColor = GGSharedColor.black;
    
    return label;
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

-(float)adjustLayout
{
    //_descriptionLbl.backgroundColor = GGSharedColor.darkGray;
    //NSString * text = _descriptionLbl.text;
    
    _titleLbl.text = [_titleLbl.text stringLimitedToLength:90];
    [_titleLbl calculateSize];
    //[_titleLbl sizeToFit];
    
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
