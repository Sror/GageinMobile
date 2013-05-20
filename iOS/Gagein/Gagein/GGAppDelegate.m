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
#import "GGFacebookOAuth.h"



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
    
    self.tabBarController = [[GGTabBarController alloc] initWithViewControllers:@[nc1, nc2, nc3, nc4]];
    self.tabBarController.delegate = self;
    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbarBg"]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self _initTabbar];
    
    //UIViewController *viewController1 = [[GGCompaniesVC alloc] initWithNibName:@"GGCompaniesVC" bundle:nil];
    
    
    _rootVC = [[GGRootVC alloc] init];
    self.window.rootViewController = _rootVC;
    
    //
    _signPortalVC = [[GGSignupPortalVC alloc] init];
    self.naviController = [[GGRootNaviVC alloc] initWithRootViewController:_signPortalVC];
    self.naviController.navigationBarHidden = YES;
    //[self.window addSubview:_naviController.view];
    //[self.window sendSubviewToBack:_naviController.view];
    
    [self makeNaviBarCustomed:YES];
    
    [self.window makeKeyAndVisible];
    
    //
    [self enterLoginIfNeeded];
    
    return YES;
}

-(void)makeNaviBarCustomed:(BOOL)aCustomed
{
    UIImage *neededNaviBgImg = nil;
    if (aCustomed)
    {
        UIImage *naviBgImg = [UIImage imageNamed:@"bgNavibar"];
        CGSize navBgSize = naviBgImg.size;
        CGSize neededSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, navBgSize.height);
        neededNaviBgImg = [GGUtils imageFor:naviBgImg size:neededSize];
    }
    
    [[UINavigationBar appearance] setBackgroundImage:neededNaviBgImg forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
}

-(GGSlideSettingView *)slideSettingView
{
    return _rootVC.viewSetting;
}


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
    [[GGFacebookOAuth sharedInstance].session close];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [[GGFacebookOAuth sharedInstance] handleOpenURL:url sourceApplication:sourceApplication];
}


// Optional UITabBarControllerDelegate method.
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //CGRect rc = tabBarController.view.frame;
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //CGRect rc = tabBarController.view.frame;
    DLog(@"");
}



#pragma mark - handle notification
- (void)handleNotification:(NSNotification *)notification
{
}

#pragma mark - navigation & screen change
-(void)enterLoginIfNeeded
{
    if (![GGRuntimeData sharedInstance].isLoggedIn)
    {
        [self.naviController.view.layer addAnimation:[GGAnimation animationFade] forKey:nil];
        [_rootVC presentViewController:_naviController animated:NO completion:nil];
    }
}

-(void)popNaviToRoot
{
    [self.naviController.view.layer addAnimation:[GGAnimation animationFade] forKey:nil];
    //[_rootVC dismissModalViewControllerAnimated:NO];
    [_rootVC dismissViewControllerAnimated:NO completion:nil];
}

-(void)showTabIndex:(NSUInteger)aIndex
{
    self.tabBarController.selectedIndex = aIndex;
}

@end
