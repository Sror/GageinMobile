//
//  GGComOverviewProfileCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGComOverviewProfileCell.h"

@implementation GGComOverviewProfileCell

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
}

-(float)height
{
    return self.frame.size.height;
}

-(void)layMeOut
{
    [_lblIndustry calculateSizeConstaintToHeight:40];
    [_lblSpeciality calculateSizeConstaintToHeight:40];
}

@end
