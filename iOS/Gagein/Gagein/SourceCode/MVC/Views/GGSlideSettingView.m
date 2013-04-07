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
        self.backgroundColor = [UIColor colorWithRed:.5f green:.5f blue:.5f alpha:.2f];
        
        _viewSlide = [[UIView alloc] initWithFrame:CGRectZero];
        _viewSlide.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self addSubview:_viewSlide];
        [self _tuneLayout];
        
        self.hidden = YES;
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self _tuneLayout];
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
            
#if 0
            CGPoint pt = _viewSlide.layer.position;
            pt.x += _viewSlide.frame.size.width;
            _viewSlide.layer.position = pt;
#else
            CGRect slideRc = CGRectMake(0
                                        , 0
                                        , self.frame.size.width - FORBIDDEN_AREA_WIDTH
                                        , self.frame.size.height);
            _viewSlide.frame = slideRc;
#endif
            
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
