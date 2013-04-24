//
//  GGSlideSettingView.m
//  Gagein
//
//  Created by dong yiming on 13-4-7.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSlideSettingView.h"
#import "GGAppDelegate.h"
#import "GGSearchBar.h"
#import <QuartzCore/QuartzCore.h>

#define SELF_WIDTH    240

@implementation GGSlideSettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = GGSharedColor.darkGray;
        
        self.frame = [self _slideHideRect];
        
        _viewTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _viewTable.showsVerticalScrollIndicator = NO;
        _viewTable.backgroundColor = GGSharedColor.clear;
        _viewTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_viewTable];
        
        _searchBar = [[GGSearchBar alloc] initWithFrame:CGRectMake(0, 0, SELF_WIDTH, 40)];
        _viewTable.tableHeaderView = _searchBar;

        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideSlide)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwipe];
    }
    return self;
}


#pragma mark - rect
-(CGRect)_slideHideRect
{
    return CGRectMake(-SELF_WIDTH
                      , self.frame.origin.y
                      , SELF_WIDTH
                      , self.frame.size.height);
}

-(CGRect)_slideShowRect
{
    return CGRectMake(0
                      , self.frame.origin.y
                      , SELF_WIDTH
                      , self.frame.size.height);
}

#pragma mark - actions
-(void)showSlide
{
    if (!_isShowing)
    {
        _isShowing = YES;
        
        [UIView animateWithDuration:.3f animations:^{
            
            self.frame = [GGUtils setX:0 rect:self.frame];
            GGSharedDelegate.naviController.view.frame = [GGUtils setX:SELF_WIDTH rect:GGSharedDelegate.naviController.view.frame];
            
        } completion:^(BOOL finished) {
            
            [self.superview bringSubviewToFront:self];
            [_delegate slideview:self isShowed:YES];
        }];
    }
}

-(void)hideSlide
{
    [self hideSlideOnCompletion:nil];
}

-(void)hideSlideOnCompletion:(void(^)(void))completion
{
    if (_isShowing)
    {
        _isShowing = NO;
        
        [_searchBar resignFirstResponder];
        
        [UIView animateWithDuration:.3f animations:^{
            
            self.frame = [GGUtils setX:-SELF_WIDTH rect:self.frame];
            GGSharedDelegate.naviController.view.frame = [GGUtils setX:0 rect:GGSharedDelegate.naviController.view.frame];
            
        } completion:^(BOOL finished) {
            
            [self.superview sendSubviewToBack:self];
            [_delegate slideview:self isShowed:NO];
            
            _searchBar.text = @"";
            
            if (completion)
            {
                completion();
            }
        }];
    }
}

@end
