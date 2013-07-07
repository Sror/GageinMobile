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

#import "MMDrawerVisualState.h"

#import "MMDrawerController.h"
#import "GGLeftDrawerVC.h"
//#import "GGDummyDrawerVC.h"


#define TAG_UPGRADE_ALERT   1000


@implementation GGAppDelegate
{
    GGUpgradeInfo *_upgradeInfo;
}

//-(void)_initTabbar
//{
//    // Override point for customization after application launch.
//    UIViewController *viewController1, *viewController2, *viewController3, *viewController4;
//    UINavigationController *nc1, *nc2, *nc3, *nc4;
//    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        viewController1 = [[GGCompaniesVC alloc] initWithNibName:@"GGCompaniesVC" bundle:nil];
//        viewController2 = [[GGPeopleVC alloc] init];
//        viewController3 = [[GGSavedUpdatesVC alloc] initWithNibName:@"GGSavedUpdatesVC" bundle:nil];
//        viewController4 = [[GGSettingVC alloc] initWithNibName:@"GGSettingVC" bundle:nil];
//    } else {
//        viewController1 = [[GGCompaniesVC alloc] initWithNibName:@"GGCompaniesVC_iPad" bundle:nil];
//        viewController2 = [[GGPeopleVC alloc] init];
//        viewController3 = [[GGSavedUpdatesVC alloc] initWithNibName:@"GGSavedUpdatesVC_iPad" bundle:nil];
//        viewController4 = [[GGSettingVC alloc] initWithNibName:@"GGSettingVC" bundle:nil];
//    }
//    
//    nc1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
//    nc2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
//    nc3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
//    nc4 = [[UINavigationController alloc] initWithRootViewController:viewController4];
//    
//    _tabBarController = [[RDVTabBarController alloc] initWithViewControllers:@[nc1, nc2, nc3, nc4]];
//    _tabBarController.delegate = self;
//    [_tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbarBg"]];
//    //_tabbarVC.viewControllers = @[nc1, nc2, nc3, nc4];
//    
//}


- (void)_initTabbar {
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
    
    nc1 = [[GGNavigationController alloc] initWithRootViewController:viewController1];
    nc2 = [[GGNavigationController alloc] initWithRootViewController:viewController2];
    nc3 = [[GGNavigationController alloc] initWithRootViewController:viewController3];
    nc4 = [[GGNavigationController alloc] initWithRootViewController:viewController4];
    
    _tabBarController = [[RDVTabBarController alloc] init];
    [_tabBarController setViewControllers:@[nc1, nc2, nc3, nc4]];
    //self.viewController = tabBarController;
    
    [self customizeTabBarForController:_tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    //UIImage *finishedImage = [[UIImage imageNamed:@"tabbarBg"]
    //resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
    //UIImage *unfinishedImage = [[UIImage imageNamed:@"tabbarBg"]
    //resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
    
    RDVTabBar *tabBar = [tabBarController tabBar];
    //tabBar.opaque = NO;
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

-(GGBaseViewController *)topMostVC
{
    UINavigationController *selectedNC = (UINavigationController *)_tabBarController.selectedViewController;
    return (GGBaseViewController *)selectedNC.topViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self getSnTypes];
    
    //
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.window.backgroundColor = GGSharedColor.darkRed;
    
    [self _initTabbar];
    
    GGLeftDrawerVC *leftDrawerVC = [GGLeftDrawerVC new];
    //GGDummyDrawerVC *leftDrawerVC = [GGDummyDrawerVC new];
    
    _drawerVC = [[MMDrawerController alloc] initWithCenterViewController:_tabBarController leftDrawerViewController:leftDrawerVC];
    
    [_drawerVC setMaximumLeftDrawerWidth:LEFT_DRAWER_WIDTH];
    [_drawerVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_drawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    _drawerVC.shouldStretchDrawer = NO;
    
    [_drawerVC
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         //block = [MMDrawerVisualState slideVisualStateBlock];
         block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.f];
         //block = [MMDrawerVisualState swingingDoorVisualStateBlock];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    self.window.rootViewController = _drawerVC;
    
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

-(void)getSnTypes
{
    [GGSharedAPI snGetList:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            NSArray *snTypes = [parser parseSnGetList];
            [GGSharedRuntimeData.snTypes removeAllObjects];
            [GGSharedRuntimeData.snTypes addObjectsFromArray:snTypes];
        }
    }];
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
    }
    
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:5.f forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBackgroundImage:neededNaviBgImg forBarMetrics:UIBarMetricsDefault];
    
    
    
    
    // common apperance
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    
    [titleBarAttributes setValue:[UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE_LIGHT size:16] forKey:UITextAttributeFont];
    [titleBarAttributes setValue:GGSharedColor.white forKey:UITextAttributeTextColor];
    //[titleBarAttributes setValue:GGSharedColor.lightGray forKey:UITextAttributeTextShadowColor];
    //[titleBarAttributes setValue:[NSValue valueWithUIOffset:UIOffsetMake(0, -1)] forKey:UITextAttributeTextShadowOffset];
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
}

//-(GGSlideSettingView *)slideSettingView
//{
//    return _rootVC.viewSetting;
//}

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

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (ISIPADDEVICE)
    {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
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
        [_drawerVC presentViewController:_naviController animated:NO completion:nil];
        //[self.window addSubview:self.naviController.view];
    }
}

-(void)popNaviToRoot
{
    [self.naviController.view.layer addAnimation:[GGAnimation animationFade] forKey:nil];
    //[self.naviController.view removeFromSuperview];
    [_drawerVC dismissViewControllerAnimated:NO completion:nil];
}

-(void)showTabIndex:(NSUInteger)aIndex
{
    self.tabBarController.selectedIndex = aIndex;
}

-(GGLeftDrawerVC *)leftDrawer
{
    return (GGLeftDrawerVC *)(_drawerVC.leftDrawerViewController);
}

@end
