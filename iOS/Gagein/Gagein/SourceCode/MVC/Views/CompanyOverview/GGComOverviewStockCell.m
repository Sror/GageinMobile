//
//  GGComOverviewStockCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGComOverviewStockCell.h"

@implementation GGComOverviewStockCell

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

#define CONTENT_MARGIN_X        10
#define CONTENT_MARGIN_Y        5
#define CONTENT_PADDING_Y       0
-(void)doLayoutIsPublic:(BOOL)aIsPublic
{
    _lblStockChange.hidden = _lblStockSymbol.hidden = _btnStock.hidden
    = _lblStockChangeCap.hidden = _lblStockSymbolCap.hidden = !aIsPublic;
    float contentHeight = [GGComOverviewStockCell heightIsPublic:aIsPublic] - CONTENT_MARGIN_Y * 2;
    [_viewContent setHeight:contentHeight];
}

+(float)heightIsPublic:(BOOL)aIsPublic
{
    return aIsPublic ? 100 : 50;
}

@end
