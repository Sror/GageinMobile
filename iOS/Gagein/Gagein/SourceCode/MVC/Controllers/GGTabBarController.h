//
//  GGTabBarController.h
//  TestTabBar
//
//  Created by dong yiming on 13-4-23.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGTabBarController : UITabBarController
@property (assign, nonatomic)      CGRect      initialTabRect;
@property (readonly, nonatomic)     BOOL    isTabbarHidden;

-(id)initWithViewControllers:(NSArray *)aViewControllers;

//-(void)adjustTabbarPosForIpadWithOrient:(UIInterfaceOrientation)toInterfaceOrientation;
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

- (void)showTabBarAnimated:(BOOL)aAnimated;
- (void)hideTabBarAnimated:(BOOL)aAnimated;
@end
