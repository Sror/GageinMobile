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

#import "GGWelcomeVC.h"
#import "GGRuntimeData.h"



@implementation GGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    UIViewController *viewController1, *viewController2, *viewController3, *viewController4;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[GGCompaniesVC alloc] initWithNibName:@"GGCompaniesVC" bundle:nil];
        viewController2 = [[GGPeopleVC alloc] initWithNibName:@"GGPeopleVC" bundle:nil];
        viewController3 = [[GGProfileVC alloc] initWithNibName:@"GGProfileVC" bundle:nil];
        viewController4 = [[GGSettingVC alloc] initWithNibName:@"GGSettingVC" bundle:nil];
    } else {
        viewController1 = [[GGCompaniesVC alloc] initWithNibName:@"GGCompaniesVC_iPad" bundle:nil];
        viewController2 = [[GGPeopleVC alloc] initWithNibName:@"GGPeopleVC_iPad" bundle:nil];
        viewController3 = [[GGProfileVC alloc] initWithNibName:@"GGProfileVC_iPad" bundle:nil];
        viewController4 = [[GGSettingVC alloc] initWithNibName:@"GGSettingVC_iPad" bundle:nil];
    }
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2, viewController3, viewController4];
    
    self.naviController = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
    self.naviController.navigationBarHidden = YES;
    
    self.window.rootViewController = self.naviController;
    [self.window makeKeyAndVisible];
    
//    [[GGApi sharedApi] getCompanyInfoWithID:1399794 includeSp:YES callback:^(id operation, id aResultObject, NSError *anError) {
//        DLog(@"%@", aResultObject);
//    }];
    
    if (![GGRuntimeData sharedInstance].isLoggedIn)
    {
        GGSignupPortalVC *vc = [[GGSignupPortalVC alloc] init];
        [self.naviController pushViewController:vc animated:NO];
    }
    
    return YES;
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

@end
