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
        [self _installSubviews];
    }
    return self;
    
    
}

#warning IMPROVEMENT: for now, use digit value, need optimise in future
#define TITLE_Y         (23)
#define TITLE_WIDTH     (230)
#define CELL_HEIGHT     (130)
#define OUTER_MARGIN_Y  (3)
-(void)_installSubviews
{
    //
    _viewCellBg = [[UIView alloc] initWithFrame:CGRectMake(5, OUTER_MARGIN_Y, 310, CELL_HEIGHT - OUTER_MARGIN_Y * 2)];
    _viewCellBg.autoresizingMask = UIViewAutoresizingFixLeftTop;
    [self.contentView addSubview:_viewCellBg];
    
    // cell bg image
    _ivCellBg = [[UIImageView alloc] initWithFrame:_viewCellBg.bounds];
    _ivCellBg.autoresizingMask = UIViewAutoresizingFixLeftTop;
    _ivCellBg.image = GGSharedImagePool.stretchShadowBgWite;
    [_viewCellBg addSubview:_ivCellBg];
    
    // interval label
    _intervalLbl = [[UILabel alloc] initWithFrame:CGRectMake(246, 5, 55, 20)];
    _intervalLbl.font = [UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE_LIGHT size:11.f];
    _intervalLbl.textColor = GGSharedColor.grayTopText;
    _intervalLbl.backgroundColor = GGSharedColor.clear;
    _intervalLbl.textAlignment = NSTextAlignmentRight;
    [_viewCellBg addSubview:_intervalLbl];
    
    // source label
    _sourceLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 180, 20)];
    _sourceLbl.font = [UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE_LIGHT size:11.f];
    _sourceLbl.textColor = GGSharedColor.grayTopText;
    _sourceLbl.backgroundColor = GGSharedColor.clear;
    //_sourceLbl.lineBreakMode = UILineBreakModeTailTruncation;
    [_viewCellBg addSubview:_sourceLbl];
    
    // title label
    _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, TITLE_Y, TITLE_WIDTH, 49)];
    _titleLbl.font = [UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE_MEDIUM size:14.f];
    _titleLbl.textColor = GGSharedColor.grayTopText;
    _titleLbl.backgroundColor = GGSharedColor.clear;
    _titleLbl.lineBreakMode = UILineBreakModeWordWrap;
    _titleLbl.numberOfLines = 3;
    [_viewCellBg addSubview:_titleLbl];
    
    // 8 11 65 65
    _logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 11, 65, 65)];
    _logoIV.autoresizingMask = UIViewAutoresizingFixLeftTop;
    _logoIV.contentMode = UIViewContentModeScaleAspectFill;
    _logoIV.clipsToBounds = YES;
    [_logoIV applyEffectShadowAndBorder];
    [_viewCellBg addSubview:_logoIV];
}

//calculatedSize
+(float)heightForUpdate:(GGCompanyUpdate *)anUpdate
{
    if (anUpdate)
    {
        CGSize constraint = CGSizeMake(TITLE_WIDTH, FLT_MAX);
        
        float titleMaxY = [anUpdate.headlineTruncated sizeWithFont:[UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE_MEDIUM size:14.f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap].height + TITLE_Y;
        titleMaxY = MAX(MINIMAL_HEIGHT, titleMaxY);
        
        return titleMaxY + 5 + OUTER_MARGIN_Y * 2;
    }
    
    return MINIMAL_HEIGHT;
}

-(void)setHasBeenRead:(BOOL)hasRead
{
    if (hasRead)
    {
        _titleLbl.textColor = GGSharedColor.gray;
    }
    else
    {
        _titleLbl.textColor = GGSharedColor.black;
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
    self.contentView.autoresizingMask = UIViewAutoresizingFixLeftTop;
    
    _titleLbl.text = [_titleLbl.text stringLimitedToLength:90];
    
    [_titleLbl sizeToFitFixWidth];

    
    CGRect theRect = self.viewCellBg.frame;
    float height = CGRectGetMaxY(_titleLbl.frame) + 5;
    height = height > MINIMAL_HEIGHT ? height : MINIMAL_HEIGHT;
    theRect.size.height = height;
    self.viewCellBg.frame = theRect;

    self.ivCellBg.frame = _viewCellBg.bounds;
    
    theRect = self.contentView.frame;
    theRect.size.height = CGRectGetMaxY(_viewCellBg.frame) + 5;
    self.contentView.frame = theRect;
    
    
    theRect = self.frame;
    theRect.size.height = CGRectGetMaxY(self.contentView.frame);
    self.frame = theRect;
    
    return theRect.size.height;
}

@end
