//
//  GGComOverviewContactCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGComOverviewContactCell.h"
#import "OTSCopiableLabel.h"

@implementation GGComOverviewContactCell

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
    
    self.lblEmail.text
    = self.lblTelephone.text
    = self.lblFax.text
    = self.lblAddress.text
    = @"";
}

-(float)height
{
    return self.frame.size.height;
}

@end
