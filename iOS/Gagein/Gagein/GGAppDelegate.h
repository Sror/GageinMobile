//
//  GGAppDelegate.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGTabBarController.h"
@class GGSlideSettingView;

@interface GGAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GGTabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *naviController;
@property (strong, nonatomic) GGSlideSettingView *slideSettingView;

-(void)enterLoginIfNeeded;
-(void)popNaviToRoot;
-(void)showTabIndex:(NSUInteger)aIndex;
@end

#define GGSharedDelegate  ((GGAppDelegate*)[UIApplication sharedApplication].delegate)
