//
//  GGCompanySearchCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-10.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSearchSuggestionCell.h"

@implementation GGSearchSuggestionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(float)HEIGHT
{
    return 65.f;
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
    _ivMark.hidden = NO;
    _ivMark.image = aImage;
    _ivMark.frame = CGRectMake(_ivMark.frame.origin.x, (self.contentView.frame.size.height - aImage.size.height) / 2, aImage.size.width, aImage.size.height);
}

@end
