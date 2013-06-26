//
//  GGCompanyUpdateCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-7.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyUpdateCell.h"

#import "GGCompanyUpdate.h"

#define MINIMAL_HEIGHT      85

//#define TITLE_FONT          [UIFont fontWithName:GG_FONT_NAME_OPTIMA_BOLD size:15.f]
//#define TITLE_LINE_BREAK    UILineBreakModeTailTruncation
//#define TITLE_WIDTH_SHORT   230.f
//#define TITLE_WIDTH_LONG    305.f


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
    label.font = [UIFont fontWithName:GG_FONT_NAME_OPTIMA_BOLD size:15.f];
    label.textColor = GGSharedColor.black;
    
    return label;
}

-(void)setHasBeenRead:(BOOL)hasRead
{
    if (hasRead)
    {
        _titleLbl.textColor = GGSharedColor.gray;
    }
    else
    {
        _titleLbl.textColor = GGSharedColor.orangeGageinDark;
    }
}

-(void)showPicture:(BOOL)aShow
{
    _logoIV.hidden = !aShow;
    
    //_titleLbl.backgroundColor = GGSharedColor.darkGray;
    //_sourceLbl.backgroundColor = GGSharedColor.darkRed;
    if (aShow)
    {
        CGRect sourceRc = _sourceLbl.frame;
        sourceRc.origin.x = CGRectGetMaxX(_logoIV.frame) + 10;
        sourceRc.size.width = _intervalLbl.frame.origin.x - sourceRc.origin.x;
        _sourceLbl.frame = sourceRc;
        
        CGRect titleRc = _titleLbl.frame;
        titleRc.origin.x = _sourceLbl.frame.origin.x;
        titleRc.size.width = CGRectGetMaxX(_intervalLbl.frame) - titleRc.origin.x;
        _titleLbl.frame = titleRc;
    }
    else
    {
        CGRect sourceRc = _sourceLbl.frame;
        float offsetX = sourceRc.origin.x - _logoIV.frame.origin.x;
        sourceRc.origin.x = _logoIV.frame.origin.x;
        sourceRc.size.width += offsetX;
        _sourceLbl.frame = sourceRc;
        
        CGRect titleRc = _titleLbl.frame;
        offsetX = titleRc.origin.x - _logoIV.frame.origin.x;
        titleRc.origin.x = _logoIV.frame.origin.x;
        titleRc.size.width += offsetX;
        _titleLbl.frame = titleRc;
    }
}

-(float)adjustLayout
{
    //_descriptionLbl.backgroundColor = GGSharedColor.darkGray;
    //NSString * text = _descriptionLbl.text;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    //self.clipsToBounds = YES;
    
    _titleLbl.text = [_titleLbl.text stringLimitedToLength:90];
    
    [_titleLbl sizeToFitFixWidth];
    
//    CGRect theRect = _titleLbl.frame;
//    float titleMaxY = CGRectGetMaxY(theRect);
//    theRect = _descriptionLbl.frame;
//    theRect.origin.y = titleMaxY;
//    _descriptionLbl.frame = theRect;

    
    CGRect theRect = self.viewCellBg.frame;
    float height = CGRectGetMaxY(_titleLbl.frame) + 5;
    height = height > MINIMAL_HEIGHT ? height : MINIMAL_HEIGHT;
    theRect.size.height = height;
    self.viewCellBg.frame = theRect;
    //self.viewCellBg.backgroundColor = GGSharedColor.random;
    
    //self.ivCellBg.hidden = YES;
    self.ivCellBg.frame = _viewCellBg.bounds;
    
    theRect = self.contentView.frame;
    theRect.size.height = CGRectGetMaxY(_viewCellBg.frame) + 5;
    self.contentView.frame = theRect;
    
    
    theRect = self.frame;
    theRect.size.height = CGRectGetMaxY(self.contentView.frame);
    self.frame = theRect;
    
    //self.contentView.backgroundColor = GGSharedColor.random;
    
    return theRect.size.height;
}

@end
