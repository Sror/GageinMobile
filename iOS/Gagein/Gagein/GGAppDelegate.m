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
#import "GGUpgradeInfo.h"


#define TAG_UPGRADE_ALERT   1000


@implementation GGAppDelegate
{
    GGUpgradeInfo *_upgradeInfo;
}

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
    
    _rootVC = [[GGRootVC alloc] init];
    self.window.rootViewController = _rootVC;
    
    //
    _signPortalVC = [[GGSignupPortalVC alloc] init];
    self.naviController = [[GGRootNaviVC alloc] initWithRootViewController:_signPortalVC];
    self.naviController.navigationBarHidden = YES;
    
    [self makeNaviBarCustomed:YES];
    
    [self checkForUpgrade];
    
    [self.window makeKeyAndVisible];
    
    //
    [self enterLoginIfNeeded];
    
    return YES;
}

-(void)checkForUpgrade
{
//    [GGSharedAPI getVersion:^(id operation, id aResultObject, NSError *anError) {
//        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//        
//        _upgradeInfo = [parser parseGetVersion];
//        if ([_upgradeInfo needUpgrade])
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_upgradeInfo.upgradeTitle
//                                                            message:_upgradeInfo.upgradeMessage
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Later"
//                                                  otherButtonTitles:@"Okay", nil];
//            
//            alert.tag = TAG_UPGRADE_ALERT;
//            alert.delegate = self;
//            [alert show];
//        }
//    }];
}


static BOOL s_isCustomed = NO;
-(void)makeNaviBarCustomed:(BOOL)aCustomed
{
    s_isCustomed = aCustomed;
    UIImage *neededNaviBgImg = nil;
    if (aCustomed)
    {
        UIImage *naviBgImg = [UIImage imageNamed:@"bgNavibar"];
        CGSize navBgSize = naviBgImg.size;
        CGSize neededSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, navBgSize.height);
        neededNaviBgImg = [GGUtils imageFor:naviBgImg size:neededSize];
        
        [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:5.f forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:5.f forBarMetrics:UIBarMetricsDefault];
    }
    
    [[UINavigationBar appearance] setBackgroundImage:neededNaviBgImg forBarMetrics:UIBarMetricsDefault];
    
    
    // common apperance
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:GG_FONT_NAME_OPTIMA_BOLD size:16] forKey:UITextAttributeFont];
    [titleBarAttributes setValue:GGSharedColor.white forKey:UITextAttributeTextColor];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    
}

-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (s_isCustomed)
    {
        UIImage *neededNaviBgImg = nil;
        UIImage *naviBgImg = [UIImage imageNamed:@"bgNavibar"];
        CGSize navBgSize = naviBgImg.size;
        CGRect orientRc = [GGLayout frameWithOrientation:toInterfaceOrientation rect:[UIScreen mainScreen].bounds];
        CGSize neededSize = CGSizeMake(orientRc.size.width, navBgSize.height);
        neededNaviBgImg = [GGUtils imageFor:naviBgImg size:neededSize];
        [[UINavigationBar appearance] setBackgroundImage:neededNaviBgImg forBarMetrics:UIBarMetricsDefault];
    }
    
    [_rootVC doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    //[_tabBarController doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
}

-(GGSlideSettingView *)slideSettingView
{
    return _rootVC.viewSetting;
}

-(void)_alertEnv
{
    [GGAlert alertWithMessage:[GGUtils envString]];
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
    //return [[GGFacebookOAuth sharedInstance] handleOpenURL:url sourceApplication:sourceApplication];
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[FBSession activeSession]];
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

#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TAG_UPGRADE_ALERT)
    {
        if (buttonIndex == 1) // affirmative
        {
            NSURL * iTunesUrl = [NSURL URLWithString:_upgradeInfo.url]; // @"http://itunes.apple.com/cn/app/id427457043?mt=8&ls=1"
            [[UIApplication	sharedApplication] openURL:iTunesUrl];
        }
    }
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
        //[self.window addSubview:self.naviController.view];
    }
}

-(void)popNaviToRoot
{
    [self.naviController.view.layer addAnimation:[GGAnimation animationFade] forKey:nil];
    //[self.naviController.view removeFromSuperview];
    [_rootVC dismissViewControllerAnimated:NO completion:nil];
}

-(void)showTabIndex:(NSUInteger)aIndex
{
    self.tabBarController.selectedIndex = aIndex;
}

@end
