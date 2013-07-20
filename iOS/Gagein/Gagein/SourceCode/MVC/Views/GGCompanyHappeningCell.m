//
//  GGCompanyHappeningCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-17.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyHappeningCell.h"
#import "GGHappening.h"

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
    
    //[_ivLogo applyEffectShadowAndBorder];
    
    _lblInterval.textColor = GGSharedColor.grayTopText;
    _lblName.textColor = GGSharedColor.grayTopText;
}

//+(float)HEIGHT
//{
//    return 105.f;
//}

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

#define DESC_BOTTOM_MARGIN      (5)
#define CONTENT_BOTTOM_MARGIN       (5)
-(void)doLayout
{
    [_lblDescription sizeToFitFixWidth];
    
    [_viewContent setHeight:CGRectGetMaxY(_lblDescription.frame) + DESC_BOTTOM_MARGIN];
    
    [self.contentView setHeight:CGRectGetMaxY(_viewContent.frame) + CONTENT_BOTTOM_MARGIN];
}


#define DESC_WIDTH_RECT     (CGRectMake(75, 23, 225, 64))
+(float)heightWithHappening:(GGHappening *)aHappening
{    
    if (aHappening)
    {
        NSString *descStr = aHappening.headLineText;
        UIFont *font = [UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE_MEDIUM size:13.f];
        CGSize constrainSize = CGSizeMake(DESC_WIDTH_RECT.size.width, FLT_MAX);
        float descHeight = [descStr sizeWithFont:font constrainedToSize:constrainSize lineBreakMode:NSLineBreakByTruncatingTail].height;
        
        float height = DESC_WIDTH_RECT.origin.y + descHeight + DESC_BOTTOM_MARGIN + CONTENT_BOTTOM_MARGIN;
        return height;
    }
    
    return 0.f;
}

@end
