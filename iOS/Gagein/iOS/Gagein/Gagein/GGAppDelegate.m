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



@implementation GGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    UIViewController *viewController1, *viewController2, *viewController3, *viewController4;
    UINavigationController *nc1, *nc2, *nc3, *nc4;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[GGCompaniesVC alloc] initWithNibName:@"GGCompaniesVC" bundle:nil];
        viewController2 = [[GGPeopleVC alloc] initWithNibName:@"GGPeopleVC" bundle:nil];
        viewController3 = [[GGSavedUpdatesVC alloc] initWithNibName:@"GGSavedUpdatesVC" bundle:nil];
        viewController4 = [[GGSettingVC alloc] initWithNibName:@"GGSettingVC" bundle:nil];
    } else {
        viewController1 = [[GGCompaniesVC alloc] initWithNibName:@"GGCompaniesVC_iPad" bundle:nil];
        viewController2 = [[GGPeopleVC alloc] initWithNibName:@"GGPeopleVC_iPad" bundle:nil];
        viewController3 = [[GGSavedUpdatesVC alloc] initWithNibName:@"GGSavedUpdatesVC_iPad" bundle:nil];
        viewController4 = [[GGSettingVC alloc] initWithNibName:@"GGSettingVC_iPad" bundle:nil];
    }
    
    nc1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
    nc2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
    nc3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
    nc4 = [[UINavigationController alloc] initWithRootViewController:viewController4];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[nc1, nc2, nc3, nc4];
    
    self.naviController = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
    self.naviController.navigationBarHidden = YES;
    
    self.window.rootViewController = self.naviController;
    [self.window makeKeyAndVisible];
    //self.window.clipsToBounds = NO;
    
//    [[GGApi sharedApi] getCompanyInfoWithID:1399794 includeSp:YES callback:^(id operation, id aResultObject, NSError *anError) {
//        DLog(@"%@", aResultObject);
//    }];
    
    [self enterLoginIfNeeded];
    
    //[self _alertEnv];
    [self performSelector:@selector(_alertEnv) withObject:nil afterDelay:0.0];
    
    return YES;
}

-(void)_alertEnv
{
    NSString *envAlertStr = nil;
    if (CURRENT_ENV == kGGServerProduction) {
        envAlertStr = [NSString stringWithFormat:@"Current Environment: {%@} \n Server: {%@}", @"Production", CURRENT_SERVER_URL];
    } else if (CURRENT_ENV == kGGServerDemo) {
        envAlertStr = [NSString stringWithFormat:@"Current Environment: {%@} \n Server: {%@}", @"Demo", CURRENT_SERVER_URL];
    } else if (CURRENT_ENV == kGGServerCN) {
        envAlertStr = [NSString stringWithFormat:@"Current Environment: {%@} \n Server: {%@}", @"CN", CURRENT_SERVER_URL];
    } else if (CURRENT_ENV == kGGServerStaging) {
        envAlertStr = [NSString stringWithFormat:@"Current Environment: {%@} \n Server: {%@}", @"Staging", CURRENT_SERVER_URL];
    }
    [GGAlert alert:envAlertStr];
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

@end
