//
//  GGComDetailEmployeeCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-19.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGComDetailEmployeeCell.h"

@implementation GGComDetailEmployeeCell

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
    _lblTitle.text = _lblSubTitle.text = _lblThirdLine.text = @"";
    //self.viewCellBg.backgroundColor = GGSharedColor.silver;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_ivPhoto applyEffectShadowAndBorder];
}

-(void)grayoutTitle:(BOOL)aGrayoutTitle
{
    _lblTitle.textColor = aGrayoutTitle ? GGSharedColor.lightGray : GGSharedColor.black;
}

+(float)HEIGHT
{
    return 75.f;
}

-(void)showMarkDiscolsure
{
    [self _showMarkWithImage:[UIImage imageNamed:@"discolsureArrowRight"]];
}

-(void)showMarkPlus
{
    [self _showMarkWithImage:[UIImage imageNamed:@"addGray"]];
}

-(void)showMarkCheck
{
    [self _showMarkWithImage:[UIImage imageNamed:@"checkGray"]];
}

-(void)_showMarkWithImage:(UIImage *)aImage
{
    _ivMark.image = aImage;
    _ivMark.frame = CGRectMake(_ivMark.frame.origin.x, (_viewContent.frame.size.height - aImage.size.height) / 2, aImage.size.width, aImage.size.height);
}

@end
