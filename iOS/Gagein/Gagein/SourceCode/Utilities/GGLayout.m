//
//  GGLayout.m
//  Gagein
//
//  Created by Dong Yiming on 6/6/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGLayout.h"
#import "GGAppDelegate.h"
#import "GGTabBarController.h"

@implementation GGLayout

+(CGRect)appFrame
{
    return [UIScreen mainScreen].applicationFrame;
}

+(CGRect)screenFrame
{
    return [UIScreen mainScreen].bounds;
}

+(CGRect)statusFrame
{
    CGRect statusFrame = [UIApplication sharedApplication].statusBarFrame;
    return statusFrame;
}

+(float)statusHeight
{
    return 20.f;
}

+(CGRect)tabbarFrame
{
    return GGSharedDelegate.tabBarController.tabBar.frame;
}

+(CGRect)navibarFrame
{
    return GGSharedDelegate.naviController.navigationBar.frame;
}

+(UIInterfaceOrientation)currentOrient
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

#pragma mark - orientation
+(CGRect)frameWithOrientation:(UIInterfaceOrientation)anOrientation rect:(CGRect)aRect
{
    CGRect orientationFrame = aRect;
    float max = MAX(orientationFrame.size.width, orientationFrame.size.height);
    float min = MIN(orientationFrame.size.width, orientationFrame.size.height);
    
    if (anOrientation == UIInterfaceOrientationPortrait || anOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        orientationFrame.size.width = min;
        orientationFrame.size.height = max;
    }
    else
    {
        orientationFrame.size.width = max;
        orientationFrame.size.height = min;
    }
    
    return orientationFrame;
}


#pragma mark - for iPad layout
+(CGRect)contentRectWithOrient:(UIInterfaceOrientation)anOrient
{
    CGRect rect = [self frameWithOrientation:anOrient rect:[self screenFrame]];
    rect.size.height -= [self statusHeight];
   
    return rect;
}

@end
