//
//  GGTriggerChartCell.m
//  Gagein
//
//  Created by Dong Yiming on 6/12/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGTriggerChartCell.h"
#import "GGPercentageBar.h"

@implementation GGTriggerChartCell
{
    UIView  *_seperator;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)awakeFromNib
{
    _lblTitle.text = @"";
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 290, 1)];
    _seperator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _seperator.backgroundColor = GGSharedColor.silver;
    [_viewContent addSubview:_seperator];
}


-(void)setPercentage:(float)aPercentage
{
    _viewPercentBar.percentage = aPercentage;
}

-(void)setChecked:(BOOL)aChecked
{
    _ivCheck.image = aChecked ? [UIImage imageNamed:@"tableSelectedDot"] : [UIImage imageNamed:@"tableUnselectedDot"];
}

+(float)HEIGHT
{
    return 60.f;
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

@end
