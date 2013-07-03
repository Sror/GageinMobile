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

#import "MMDrawerController.h"

@implementation GGSlideSettingView
{
    MBProgressHUD               *_hud;
    UITapGestureRecognizer      *_gestDimmedViewTapped;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = GGSharedColor.graySettingBg;
        
        //CGRect tableRc = self.bounds;
        //tableRc.size.width = SLIDE_SETTING_VIEW_WIDTH;
        
        _viewTable = [[UITableView alloc] initWithFrame:[self _tvMenuBarRect:NO] style:UITableViewStylePlain];
        _viewTable.showsVerticalScrollIndicator = NO;
        _viewTable.backgroundColor = GGSharedColor.clear;
        _viewTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_viewTable];
        
        _searchBar = [GGBlackSearchBar viewFromNibWithOwner:self];
        _viewTable.tableHeaderView = _searchBar;

        //
        _viewDimmed = [[UIView alloc] initWithFrame:CGRectZero];
        _viewDimmed.backgroundColor = GGSharedColor.black;
        _viewDimmed.alpha = .7f;
        
        _gestDimmedViewTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dimmedViewTapped:)];
        [_viewDimmed addGestureRecognizer:_gestDimmedViewTapped];
        
        //
        _tvSuggestedUpdates = [[UITableView alloc] initWithFrame:[self _tvSuggestedRect] style:UITableViewStylePlain];
        
        //
        [self _switchSearhBarMode:NO];
    }
    
    return self;
}

-(void)_dimmedViewTapped:(id)sender
{
    [self switchSearchMode:NO];
}

-(CGRect)_tvMenuBarRect:(BOOL)isLong
{
    return isLong ? CGRectMake(0, 0, LEFT_DRAWER_WIDTH_LONG, self.frame.size.height) : CGRectMake(0, 0, LEFT_DRAWER_WIDTH, self.frame.size.height);
}

-(CGRect)_searchBarRect:(BOOL)isLong
{
    return isLong ? CGRectMake(0, 0, LEFT_DRAWER_WIDTH_LONG, 40) : CGRectMake(0, 0, LEFT_DRAWER_WIDTH, 40);
}

-(CGRect)_tvSuggestedRect
{
    CGRect rc = [self _dimmedRect];
    rc.size.height = [UIScreen mainScreen].applicationFrame.size.height - _searchBar.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT;
    return rc;
}

-(CGRect)_dimmedRect
{
    float width = (ISIPADDEVICE ? LEFT_DRAWER_WIDTH_LONG : self.frame.size.width);
    return CGRectMake(0, (CGRectGetMaxY(_searchBar.frame)), width, self.frame.size.height);
}

-(void)switchSearchMode:(BOOL)aUsingSearchMode
{
    if (aUsingSearchMode)
    {
        GGSharedDelegate.drawerVC.maximumLeftDrawerWidth = LEFT_DRAWER_WIDTH_LONG;
        
        _viewDimmed.frame = [self _dimmedRect];
        [self addSubview:_viewDimmed];
        
        _tvSuggestedUpdates.frame = [self _tvSuggestedRect];
        [self addSubview:_tvSuggestedUpdates];
    }
    else
    {
        GGSharedDelegate.drawerVC.maximumLeftDrawerWidth = LEFT_DRAWER_WIDTH;
        
        [_viewDimmed removeFromSuperview];
        [_tvSuggestedUpdates removeFromSuperview];
        
        [_searchBar.tfSearch resignFirstResponder];
    }
    
    self.viewTable.frame = [self _tvMenuBarRect:aUsingSearchMode];
    
    //[self bringSubviewToFront:_searchBar];
    [self _switchSearhBarMode:aUsingSearchMode];
}

-(void)_switchSearhBarMode:(BOOL)aUsingSearchMode
{
    CGRect searchRc = [self _searchBarRect:aUsingSearchMode];
    _searchBar.frame = searchRc;
    [_searchBar showCancelButton:aUsingSearchMode animated:YES];
}


#pragma mark - rect


#pragma mark - actions
-(void)showSlide
{
    if (GGSharedDelegate.drawerVC.openSide == MMDrawerSideNone)
    {
        [GGSharedDelegate.drawerVC openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            //[_delegate slideview:self isShowed:YES];
        }];
    }
}

-(void)hideSlide
{
    [self hideSlideOnCompletion:nil];
}

-(void)hideSlideOnCompletion:(void(^)(void))completion
{
    if (GGSharedDelegate.drawerVC.openSide != MMDrawerSideNone)
    {
        [_searchBar.tfSearch resignFirstResponder];
        
        [GGSharedDelegate.drawerVC closeDrawerAnimated:YES completion:^(BOOL finished) {
            //[_delegate slideview:self isShowed:NO];
            
            if (completion)
            {
                completion();
            }
        }];
    }
}

-(void)changeDelegate:(id<UITableViewDelegate, UITableViewDataSource, GGStyledSearchBarDelegate>)aNewDelegate
{
    self.viewTable.dataSource = aNewDelegate;
    self.viewTable.delegate = aNewDelegate;
    self.searchBar.delegate = aNewDelegate;
    self.tvSuggestedUpdates.dataSource = aNewDelegate;
    self.tvSuggestedUpdates.delegate = aNewDelegate;
}

//-(void)showLoadingHUD
//{
//    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [_hud hide:YES];
//    _hud = [MBProgressHUD showHUDAddedTo:self.viewTable animated:YES];
//    _hud.mode = MBProgressHUDModeIndeterminate;
//    _hud.labelText = @"Loading";
//}
//
//-(void)hideLoadingHUD
//{
//    [_hud hide:YES];
//}

@end
