//
//  GGGroupedCell.m
//  Gagein
//
//  Created by Dong Yiming on 5/15/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGGroupedCell.h"

@implementation GGGroupedCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    switch (style)
    {
        case kGGGroupCellFirst:
        {
            _ivBg.image = GGSharedImagePool.tableCellTopBg;
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
        }
            break;
            
        default:
            break;
    }
}

@end
