//
//  GGAppDelegate.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGTabBarController.h"
//#import "GGRootVC.h"
//#import "GGRootNaviVC.h"

@class GGSlideSettingView;
@class GGSignupPortalVC;
@class GGLeftDrawerVC;
@class MMDrawerController;

@interface GGAppDelegate : UIResponder
<UIApplicationDelegate
, UITabBarControllerDelegate
, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GGTabBarController *tabBarController;
@property (strong, nonatomic) GGNavigationController *naviController;
//@property (readonly) GGSlideSettingView *slideSettingView;
//@property (strong, nonatomic) GGRootVC *rootVC;
@property (strong, nonatomic)   GGSignupPortalVC *signPortalVC;

@property (strong, nonatomic)   MMDrawerController *drawerVC;

-(GGLeftDrawerVC *)leftDrawer;
-(GGBaseViewController *)topMostVC;

-(void)enterLoginIfNeeded;
-(void)popNaviToRoot;
-(void)showTabIndex:(NSUInteger)aIndex;

-(void)makeNaviBarCustomed:(BOOL)aCustomed;

-(void)checkForUpgrade;

-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end

#define GGSharedDelegate  ((GGAppDelegate*)[UIApplication sharedApplication].delegate)
