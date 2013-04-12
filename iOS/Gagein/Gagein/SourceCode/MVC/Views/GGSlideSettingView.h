//
//  GGSlideSettingView.h
//  Gagein
//
//  Created by dong yiming on 13-4-7.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSlideSettingView : UIView
@property (nonatomic, strong) UIView        *viewSlide;
@property (nonatomic, assign) BOOL          isShowing;
@property (nonatomic, strong) UITableView   *viewTable;
-(void)showSlide;
-(void)hideSlide;
@end
