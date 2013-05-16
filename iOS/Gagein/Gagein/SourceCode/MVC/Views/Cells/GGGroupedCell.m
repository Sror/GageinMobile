//
//  GGGroupedCell.m
//  Gagein
//
//  Created by Dong Yiming on 5/15/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGGroupedCell.h"

@implementation GGGroupedCell
{
    UIView  *_seperator;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(float)HEIGHT
{
    return 45.f;
}

-(void)awakeFromNib
{
    _lblTitle.text = @"";
    _lblSubTitle.text = @"";
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 290, 1)];
    _seperator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    _seperator.backgroundColor = GGSharedColor.silver;
    [_viewContent addSubview:_seperator];
}

-(void)setChecked:(BOOL)checked
{
    if (checked)
    {
        _ivDot.image = GGSharedImagePool.tableSelectedDot;
    }
    else
    {
        _ivDot.image = GGSharedImagePool.tableUnselectedDot;
    }
}

-(void)setStyle:(EGGGroupedCellStyle)style
{
    _seperator.hidden = NO;
    
    switch (style)
    {
        case kGGGroupCellFirst:
        {
            _ivBg.image = GGSharedImagePool.tableCellTopBg;
            _seperator.hidden = YES;
        }
            break;
            
        case kGGGroupCellMiddle:
        {
            _ivBg.image = GGSharedImagePool.tableCellMiddleBg;
        }
            break;
            
        case kGGGroupCellLast:
        {
            _ivBg.image = GGSharedImagePool.tableCellBottomBg;
        }
            break;
            
        case kGGGroupCellRound:
        {
            _ivBg.image = GGSharedImagePool.tableCellRoundBg;
            _seperator.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

-(void)showDisclosure
{
    _ivDisclosure.hidden = NO;
    _ivDot.hidden = YES;
}

-(void)showSubTitle:(BOOL)aShow
{
    _lblSubTitle.hidden = !aShow;
    CGRect titleRc = _lblTitle.frame;
    
    if (aShow)
    {
        titleRc.origin.y = _lblSubTitle.frame.origin.y - titleRc.size.height + 5;
    }
    else
    {
        titleRc.origin.y = (self.frame.size.height - _lblTitle.frame.size.height) / 2;
    }
    
    _lblTitle.frame = titleRc;
}

@end
