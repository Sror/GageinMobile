//
//  GGCompanyDetailUpdateCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-19.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyDetailUpdateCell.h"

@implementation GGCompanyDetailUpdateCell

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
    self.viewCellBg.backgroundColor = GGSharedColor.silver;
}

+(float)HEIGHT
{
    return 65.f;
}

@end
