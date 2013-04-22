//
//  GGAppDelegate.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *naviController;

-(void)enterLoginIfNeeded;
-(void)popNaviToRoot;
-(void)showTabIndex:(NSUInteger)aIndex;
@end

#define GGSharedDelegate  ((GGAppDelegate*)[UIApplication sharedApplication].delegate)
