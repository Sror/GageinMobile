//
//  GGUpdateInfoRelatedArticleCell.m
//  Gagein
//
//  Created by Dong Yiming on 7/1/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGUpdateInfoRelatedArticleCell.h"

@implementation GGUpdateInfoRelatedArticleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//-(void)setSelected:(BOOL)selected animated:(BOOL)animated
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    _viewBg.backgroundColor = highlighted ? GGSharedColor.silverLight : GGSharedColor.white;
}

-(void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(float)HEIGHT
{
    return 60.f;
}

@end
