//
//  GGSlideSettingView.m
//  Gagein
//
//  Created by dong yiming on 13-4-7.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSlideSettingView.h"
#import <QuartzCore/QuartzCore.h>

#define FORBIDDEN_AREA_WIDTH    80

@implementation GGSlideSettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.2f];
        [self _assembleSubViews];
        self.hidden = YES;
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self _tuneLayout];
}

-(void)_assembleSubViews
{
    _viewSlide = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.9f];
    [self addSubview:_viewSlide];
}

-(void)_tuneLayout
{
    CGRect slideRc = CGRectMake(FORBIDDEN_AREA_WIDTH - self.frame.size.width
                                , 0
                                , self.frame.size.width - FORBIDDEN_AREA_WIDTH
                                , self.frame.size.height);
    _viewSlide.frame = slideRc;
}

-(void)showSlide
{
    if (!_isShowing)
    {
        _isShowing = YES;
        self.hidden = NO;
        
        [UIView animateWithDuration:.5f animations:^{
            
            CGPoint pt = _viewSlide.layer.position;
            pt.x += _viewSlide.frame.size.width;
            _viewSlide.layer.position = pt;
            
//            CGRect slideRc = CGRectMake(0
//                                        , 0
//                                        , self.frame.size.width - FORBIDDEN_AREA_WIDTH
//                                        , self.frame.size.height);
//            _viewSlide.frame = slideRc;
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)hideSlide
{
    if (_isShowing)
    {
        _isShowing = NO;
        
        [UIView animateWithDuration:.5f animations:^{
            [self _tuneLayout];
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

@end
