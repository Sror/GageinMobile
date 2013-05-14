//
//  GGGroupedCell.m
//  Gagein
//
//  Created by Dong Yiming on 5/14/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGEditStyleCell.h"

@implementation GGEditStyleCell

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

@end
