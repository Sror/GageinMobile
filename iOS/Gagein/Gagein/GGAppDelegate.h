//
//  GGAppDelegate.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGTabBarController.h"
#import "GGRootVC.h"
//#import "NGTabBarController.h"

@class GGSlideSettingView;

@interface GGAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GGTabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *naviController;
@property (readonly) GGSlideSettingView *slideSettingView;
@property (strong, nonatomic) GGRootVC *rootVC;

-(void)enterLoginIfNeeded;
-(void)popNaviToRoot;
-(void)showTabIndex:(NSUInteger)aIndex;

//-(void)installSlideSettingView;
@end

#define GGSharedDelegate  ((GGAppDelegate*)[UIApplication sharedApplication].delegate)
