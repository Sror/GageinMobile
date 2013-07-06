//
//  GGAppDelegate.m
//  TestCustomTabbar
//
//  Created by Dong Yiming on 7/5/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGAppDelegate.h"

#import "GGViewController.h"
#import "RDVFirstViewController.h"
#import "RDVSecondViewController.h"
#import "RDVThirdViewController.h"
#import "RDVTabBarController.h"

@implementation GGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.viewController = [[GGViewController alloc] initWithNibName:@"GGViewController" bundle:nil];
    [self setupViewControllers];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)setupViewControllers {
    UIViewController *firstViewController = [[RDVFirstViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[RDVSecondViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[RDVThirdViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *thirdNavigationController = [[UINavigationController alloc] initWithRootViewController:thirdViewController];
    
    UIViewController *fourthVC = [[GGViewController alloc] init];
    UIViewController *fourthNC = [[UINavigationController alloc] initWithRootViewController:fourthVC];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController, thirdNavigationController, fourthVC]];
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    //UIImage *finishedImage = [[UIImage imageNamed:@"tabbarBg"]
                              //resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
    //UIImage *unfinishedImage = [[UIImage imageNamed:@"tabbarBg"]
                                //resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
    
    RDVTabBar *tabBar = [tabBarController tabBar];
    [tabBar setBackgroundImage:[UIImage imageNamed:@"tabbarBg"]];
    
    [tabBar setFrame:CGRectMake(CGRectGetMinX(tabBar.frame), CGRectGetMinY(tabBar.frame), CGRectGetWidth(tabBar.frame), 63)];
    
    NSAssert((tabBar.items.count == 4), @"tabbar count should be 4");
    
    RDVTabBarItem *item1 = tabBar.items[0];
    [item1 setFinishedSelectedImage:[UIImage imageNamed:@"tab_company_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_company_normal"]];
    
    RDVTabBarItem *item2 = tabBar.items[1];
    [item2 setFinishedSelectedImage:[UIImage imageNamed:@"tab_people_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_people_normal"]];
    
    RDVTabBarItem *item3 = tabBar.items[2];
    [item3 setFinishedSelectedImage:[UIImage imageNamed:@"tab_saved_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_saved_normal"]];
    
    RDVTabBarItem *item4 = tabBar.items[3];
    [item4 setFinishedSelectedImage:[UIImage imageNamed:@"tab_settings_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_settings_normal"]];
    
//    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
//        //[item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
//        UIImage *image = [UIImage imageNamed:@"tab_company_normal"];
//        [item setFinishedSelectedImage:[UIImage imageNamed:@"tab_company_selected"] withFinishedUnselectedImage:image];
//    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
