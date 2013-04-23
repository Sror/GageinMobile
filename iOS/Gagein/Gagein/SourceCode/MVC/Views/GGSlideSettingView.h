//
//  GGSlideSettingView.h
//  Gagein
//
//  Created by dong yiming on 13-4-7.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGSlideSettingView;

@protocol GGSlideSettingViewDelegate

-(void)slideview:(GGSlideSettingView *)aSlideView isShowed:(BOOL)aIsShowed;

@end

@interface GGSlideSettingView : UIView
@property (nonatomic, assign) BOOL          isShowing;
@property (nonatomic, strong) UITableView   *viewTable;
@property (weak) id<GGSlideSettingViewDelegate> delegate;
-(void)showSlide;
-(void)hideSlide;
@end
