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
        self.backgroundColor = GGSharedColor.clear;
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor colorWithRed:.5f green:.5f blue:.5f alpha:.5f];
        [self addSubview:bgView];
        
        _viewSlide = [[UIView alloc] initWithFrame:[self _slideHideRect]];
        _viewSlide.backgroundColor = GGSharedColor.darkGray;
        [self addSubview:_viewSlide];
        
        _viewTable = [[UITableView alloc] initWithFrame:_viewSlide.bounds style:UITableViewStylePlain];
        _viewTable.showsVerticalScrollIndicator = NO;
        [_viewSlide addSubview:_viewTable];
        
        self.hidden = YES;
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _viewSlide.frame = [self _slideHideRect];
}

#pragma mark - rect
-(CGRect)_slideHideRect
{
    return CGRectMake(FORBIDDEN_AREA_WIDTH - self.frame.size.width
                      , 0
                      , self.frame.size.width - FORBIDDEN_AREA_WIDTH
                      , self.frame.size.height);
}

-(CGRect)_slideShowRect
{
    return CGRectMake(0
                      , 0
                      , self.frame.size.width - FORBIDDEN_AREA_WIDTH
                      , self.frame.size.height);
}

#pragma mark - actions
-(void)showSlide
{
    if (!_isShowing)
    {
        _isShowing = YES;
        self.hidden = NO;
        
        [UIView animateWithDuration:.3f animations:^{

            _viewSlide.frame = [self _slideShowRect];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)hideSlide
{
    if (_isShowing)
    {
        _isShowing = NO;
        
        [UIView animateWithDuration:.3f animations:^{
            
            _viewSlide.frame = [self _slideHideRect];
            
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

@end
