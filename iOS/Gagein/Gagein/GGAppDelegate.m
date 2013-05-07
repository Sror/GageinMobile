//
//  GGAppDelegate.m
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGAppDelegate.h"

#import "GGCompaniesVC.h"
#import "GGPeopleVC.h"
#import "GGProfileVC.h"
#import "GGSettingVC.h"
#import "GGSignupPortalVC.h"
#import "GGSavedUpdatesVC.h"

#import "GGWelcomeVC.h"
#import "GGRuntimeData.h"
#import "GGSlideSettingView.h"




@implementation GGAppDelegate

-(void)_initTabbar
{
    // Override point for customization after application launch.
    UIViewController *viewController1, *viewController2, *viewController3, *viewController4;
    UINavigationController *nc1, *nc2, *nc3, *nc4;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[GGCompaniesVC alloc] initWithNibName:@"GGCompaniesVC" bundle:nil];
        viewController2 = [[GGPeopleVC alloc] init];
        viewController3 = [[GGSavedUpdatesVC alloc] initWithNibName:@"GGSavedUpdatesVC" bundle:nil];
        viewController4 = [[GGSettingVC alloc] initWithNibName:@"GGSettingVC" bundle:nil];
    } else {
        viewController1 = [[GGCompaniesVC alloc] initWithNibName:@"GGCompaniesVC_iPad" bundle:nil];
        viewController2 = [[GGPeopleVC alloc] init];
        viewController3 = [[GGSavedUpdatesVC alloc] initWithNibName:@"GGSavedUpdatesVC_iPad" bundle:nil];
        viewController4 = [[GGSettingVC alloc] initWithNibName:@"GGSettingVC" bundle:nil];
    }
    
    nc1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
    nc2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
    nc3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
    nc4 = [[UINavigationController alloc] initWithRootViewController:viewController4];
    
//    nc1.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Companies" image:[UIImage imageNamed:@"tab_company_normal"]];
//    nc2.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"People" image:[UIImage imageNamed:@"tab_people_normal"]];
//    nc3.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Saved" image:[UIImage imageNamed:@"tab_saved_normal"]];
//    nc4.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Settings" image:[UIImage imageNamed:@"tab_settings_normal"]];
//    
//    nc1.ng_tabBarItem.selectedImageTintColor =
//    nc2.ng_tabBarItem.selectedImageTintColor =
//    nc3.ng_tabBarItem.selectedImageTintColor =
//    nc4.ng_tabBarItem.selectedImageTintColor = GGSharedColor.orangeGagein;
    
    //nc1.ng_tabBarItem.selectedTitleColor = [UIColor yellowColor];
    
    self.tabBarController = [[GGTabBarController alloc] initWithViewControllers:@[nc1, nc2, nc3, nc4]];
    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbarBg"]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self _initTabbar];
    
    self.naviController = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
    self.naviController.navigationBarHidden = YES;
    
    _rootVC = [[GGRootVC alloc] init];

    self.window.rootViewController = _rootVC;
    //self.window.rootViewController = self.naviController;
    
    UIImage *naviBgImg = [UIImage imageNamed:@"bgNaviBar"];//GGSharedImagePool.stretchShadowBgWite;
    CGSize navBgSize = naviBgImg.size;
    CGSize neededSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, navBgSize.height);
    UIImage *neededNaviBgImg = [GGUtils imageFor:naviBgImg size:neededSize];
    [[UINavigationBar appearance] setBackgroundImage:neededNaviBgImg forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    
    [self.window makeKeyAndVisible];
    
    //
    [self enterLoginIfNeeded];
    
    return YES;
}

-(GGSlideSettingView *)slideSettingView
{
    return _rootVC.viewSetting;
}

//-(void)installSlideSettingView
//{
//    if (_slideSettingView == nil) {
//        _slideSettingView = [[GGSlideSettingView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
//    }
//    
//    [_slideSettingView removeFromSuperview];
//    //UIView *theWindow = GGSharedDelegate.window;
//    [_rootVC.viewBack addSubview:_slideSettingView];
//    //[theWindow sendSubviewToBack:_slideSettingView];
//}

-(void)_alertEnv
{
    [GGAlert alert:[GGUtils envString]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    DLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DLog(@"applicationWillTerminate");
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

#pragma mark - handle notification
- (void)handleNotification:(NSNotification *)notification
{
}

#pragma mark - navigation & screen change
-(void)enterLoginIfNeeded
{
    if (![GGRuntimeData sharedInstance].isLoggedIn)
    {
        GGSignupPortalVC *vc = [[GGSignupPortalVC alloc] init];
        [self.naviController.view.layer addAnimation:[GGAnimation animationFade] forKey:nil];
        [self.naviController pushViewController:vc animated:NO];
    }
}

-(void)popNaviToRoot
{
    [self.naviController popToRootViewControllerAnimated:NO];
    self.naviController.navigationBarHidden = YES;
}

-(void)showTabIndex:(NSUInteger)aIndex
{
    self.tabBarController.selectedIndex = aIndex;
}

//////////////////////////////////////////////////////////////////////////
//#pragma mark - NGTabBarControllerDelegate
//////////////////////////////////////////////////////////////////////////
//
//- (CGSize)tabBarController:(NGTabBarController *)tabBarController
//sizeOfItemForViewController:(UIViewController *)viewController
//                   atIndex:(NSUInteger)index
//                  position:(NGTabBarPosition)position {
//    if (NGTabBarIsVertical(position)) {
//        return CGSizeMake(150.f, 60.f);
//    } else {
//        return CGSizeMake(76.f, 48.f);
//    }
//}

@end
