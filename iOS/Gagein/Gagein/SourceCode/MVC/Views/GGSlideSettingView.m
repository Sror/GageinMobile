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
#import "GGRootVC.h"
#import <QuartzCore/QuartzCore.h>



@implementation GGSlideSettingView
{
    MBProgressHUD *_hud;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = GGSharedColor.graySettingBg;
        
        CGRect tableRc = self.bounds;
        tableRc.size.width = SLIDE_SETTING_VIEW_WIDTH;
        
        _viewTable = [[UITableView alloc] initWithFrame:tableRc style:UITableViewStylePlain];
        _viewTable.showsVerticalScrollIndicator = NO;
        _viewTable.backgroundColor = GGSharedColor.clear;
        _viewTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_viewTable];
        
        _searchBar = [[GGSearchBar alloc] initWithFrame:CGRectMake(0, 0, SLIDE_SETTING_VIEW_WIDTH, 40)];
        _viewTable.tableHeaderView = _searchBar;

//        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideSlide)];
//        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
//        [self addGestureRecognizer:leftSwipe];
    }
    return self;
}


#pragma mark - rect
//-(CGRect)_slideHideRect
//{
//    return CGRectMake(-SELF_WIDTH
//                      , self.frame.origin.y
//                      , SELF_WIDTH
//                      , self.frame.size.height);
//}
//
//-(CGRect)_slideShowRect
//{
//    return CGRectMake(0
//                      , self.frame.origin.y
//                      , SELF_WIDTH
//                      , self.frame.size.height);
//}

#pragma mark - actions
-(void)showSlide
{
    if (!GGSharedDelegate.rootVC.isRevealed)
    {
        [GGSharedDelegate.rootVC reveal:^{
            [_delegate slideview:self isShowed:YES];
        }];
        
//        [UIView animateWithDuration:.3f animations:^{
//            
//            self.frame = [GGUtils setX:0 rect:self.frame];
//            GGSharedDelegate.naviController.view.frame = [GGUtils setX:SELF_WIDTH rect:GGSharedDelegate.naviController.view.frame];
//            
//        } completion:^(BOOL finished) {
//            
//            [self.superview bringSubviewToFront:self];
//            [_delegate slideview:self isShowed:YES];
//        }];
    }
}

-(void)hideSlide
{
    [self hideSlideOnCompletion:nil];
}

-(void)hideSlideOnCompletion:(void(^)(void))completion
{
    if (GGSharedDelegate.rootVC.isRevealed)
    {
        [_searchBar resignFirstResponder];
        
        [GGSharedDelegate.rootVC cover:^{
            [_delegate slideview:self isShowed:NO];
            
            if (completion)
            {
                completion();
            }
        }];
        
//        [UIView animateWithDuration:.3f animations:^{
//            
//            self.frame = [GGUtils setX:-SELF_WIDTH rect:self.frame];
//            GGSharedDelegate.naviController.view.frame = [GGUtils setX:0 rect:GGSharedDelegate.naviController.view.frame];
//            
//        } completion:^(BOOL finished) {
//            
//            [self.superview sendSubviewToBack:self];
//            [_delegate slideview:self isShowed:NO];
//            
//            if (completion)
//            {
//                completion();
//            }
//        }];
    }
}

-(void)changeDelegate:(id<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>)aNewDelegate
{
    self.viewTable.dataSource = aNewDelegate;
    self.viewTable.delegate = aNewDelegate;
    self.searchBar.delegate = aNewDelegate;
}

-(void)showLoadingHUD
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud hide:YES];
    _hud = [MBProgressHUD showHUDAddedTo:self.viewTable animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"Loading";
}

-(void)hideLoadingHUD
{
    [_hud hide:YES];
}

@end
