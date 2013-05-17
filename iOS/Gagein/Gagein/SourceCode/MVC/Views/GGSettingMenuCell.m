//
//  GGSettingMenuCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-12.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSettingMenuCell.h"

@implementation GGSettingMenuCell

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

+(float)HEIGHT
{
    return 45.f;
}

-(void)awakeFromNib
{
    _lblName.textColor = GGSharedColor.silver;
}

-(void)setHightlighted:(BOOL)aHighlighted
{
    if (aHighlighted)
    {
        _lblName.textColor = GGSharedColor.orange;
    }
    else
    {
        _lblName.textColor = GGSharedColor.silver;
    }
}

@end
