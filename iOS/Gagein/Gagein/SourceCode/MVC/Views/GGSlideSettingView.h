//
//  GGSlideSettingView.h
//  Gagein
//
//  Created by dong yiming on 13-4-7.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGStyledSearchBar.h"

@class GGSlideSettingView;
//@class GGSearchBar;

@protocol GGSlideSettingViewDelegate

-(void)slideview:(GGSlideSettingView *)aSlideView isShowed:(BOOL)aIsShowed;

@end

@interface GGSlideSettingView : UIView
//@property (nonatomic, assign) BOOL              isShowing;
@property (nonatomic, strong) UITableView           *viewTable;
@property (nonatomic, strong) UITableView           *tvSuggestedUpdates;
@property (nonatomic, strong) GGBlackSearchBar      *searchBar;
@property (nonatomic, strong) UIView                *viewDimmed;

@property (weak) id<GGSlideSettingViewDelegate>     delegate;
-(void)showSlide;
-(void)hideSlide;
-(void)hideSlideOnCompletion:(void(^)(void))completion;

-(void)changeDelegate:(id<UITableViewDelegate, UITableViewDataSource, GGStyledSearchBarDelegate>)aNewDelegate;

-(void)showLoadingHUD;
-(void)hideLoadingHUD;

-(void)switchSearchMode:(BOOL)aUsingSearchMode;
@end

#define SLIDE_SETTING_VIEW_WIDTH    260
