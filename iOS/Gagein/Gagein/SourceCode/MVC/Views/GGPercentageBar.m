//
//  GGPercentageBar.m
//  TestPercentBar
//
//  Created by Dong Yiming on 5/31/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGPercentageBar.h"

#define SPACING    3
#define DENOMINATOR     6.f

@implementation GGPercentageBar


-(void)setPercentage:(float)percentage
{
    [self setPercentage:percentage animated:NO];
}

-(void)setPercentage:(float)percentage animated:(BOOL)aAnimated
{
    _percentage = percentage;
    
    if (aAnimated)
    {
        [UIView animateWithDuration:.5f animations:^{
            
            [self _updatePercentage];
            
        }];
    }
    else
    {
        [self _updatePercentage];
    }
}

-(void)_updatePercentage
{
    CGRect barRc = _viewBar.bounds;
    barRc.size.width = _percentage * _viewBarBg.frame.size.width;
    _viewBar.frame = barRc;
    
    _viewBar.backgroundColor = (_percentage > .4f) ? [self colorBarHighPercentage] : [self colorBarLowPercentage];
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
    
    CGRect thisRc = self.bounds;
    //CGRect contentRc = CGRectInset(thisRc, SPACING, SPACING);
    
    // bar background ocuppies 100% width of the bar
    CGRect barBgRc = thisRc;
    barBgRc.size.width = (thisRc.size.width * (DENOMINATOR - 1) / DENOMINATOR);
    barBgRc.origin.x = thisRc.size.width / DENOMINATOR;
    _viewBarBg = [[UIView alloc] initWithFrame:barBgRc];
    _viewBarBg.backgroundColor = [self colorBarBg];
    
    [self addSubview:_viewBarBg];
    
    // actual bar to indicate the percentage
    CGRect barRc = _viewBarBg.bounds;
    barRc.size.width = _percentage * _viewBarBg.frame.size.width;
    _viewBar = [[UIView alloc] initWithFrame:barRc];
    _viewBar.backgroundColor = [self colorBarLowPercentage];
    
    [_viewBarBg addSubview:_viewBar];
    
    // percentage number
    CGRect percentageRc = barBgRc;
    percentageRc.size.width = (thisRc.size.width / DENOMINATOR);
    percentageRc.origin.x = 0;//CGRectGetMaxX(_viewBarBg.frame);
    _lblPercentage = [[UILabel alloc] initWithFrame:percentageRc];
    _lblPercentage.textAlignment = NSTextAlignmentLeft;
    _lblPercentage.backgroundColor = [UIColor clearColor];
    _lblPercentage.font = [UIFont systemFontOfSize:14.f];
    _lblPercentage.textColor = [self colorTitle];
    
    _lblPercentage.text = [NSString stringWithFormat:@"%2d%%", ((int)(_percentage * 100))];
    
    [self addSubview:_lblPercentage];
}


-(UIColor *)colorBarBg
{
    return [GGSharedColor colorFromR:229 g:229 b:229];
}

-(UIColor *)colorTitle
{
    return [GGSharedColor colorFromR:200 g:200 b:200];
}

-(UIColor *)colorBarLowPercentage
{
    return [GGSharedColor colorFromR:132 g:132 b:132];
}

-(UIColor *)colorBarHighPercentage
{
    return [GGSharedColor colorFromR:220 g:91 b:31];
}

@end
