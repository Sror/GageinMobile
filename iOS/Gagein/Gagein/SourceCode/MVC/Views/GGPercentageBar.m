//
//  GGPercentageBar.m
//  TestPercentBar
//
//  Created by Dong Yiming on 5/31/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGPercentageBar.h"

#define SPACING    3

@implementation GGPercentageBar


-(void)setPercentage:(float)percentage
{
    _percentage = percentage;
    
    CGRect barRc = _viewBar.frame;
    barRc.size.width = _percentage * _viewBarBg.frame.size.width;
    _viewBar.frame = barRc;
    
    _lblPercentage.text = [NSString stringWithFormat:@"%2d%%", ((int)(_percentage * 100))];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self _doInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _doInit];
    }
    return self;
}


-(void)_doInit
{
    self.backgroundColor = [UIColor clearColor];
    //_percentage = .5f;
    
    CGRect thisRc = self.bounds;
    CGRect contentRc = CGRectInset(thisRc, SPACING, SPACING);
    
    //
    CGRect barBgRc = contentRc;
    barBgRc.size.width = (contentRc.size.width * 3.f / 4.f);
    _viewBarBg = [[UIView alloc] initWithFrame:barBgRc];
    _viewBarBg.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:_viewBarBg];
    
    //
    CGRect barRc = _viewBarBg.frame;
    barRc.size.width = _percentage * _viewBarBg.frame.size.width;
    _viewBar = [[UIView alloc] initWithFrame:barRc];
    _viewBar.backgroundColor = [UIColor orangeColor];
    
    [self addSubview:_viewBar];
    
    //
    CGRect percentageRc = barBgRc;
    percentageRc.size.width = (contentRc.size.width / 4.f);
    percentageRc.origin.x = CGRectGetMaxX(_viewBarBg.frame);
    _lblPercentage = [[UILabel alloc] initWithFrame:percentageRc];
    _lblPercentage.textAlignment = NSTextAlignmentRight;
    _lblPercentage.backgroundColor = [UIColor clearColor];
    _lblPercentage.font = [UIFont systemFontOfSize:14.f];
    
    _lblPercentage.text = [NSString stringWithFormat:@"%2d%%", ((int)(_percentage * 100))];
    
    [self addSubview:_lblPercentage];
}


@end
