//
//  GGTabBarController.h
//  TestTabBar
//
//  Created by dong yiming on 13-4-23.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGTabBarController : UITabBarController
@property (assign)      CGRect      initialTabRect;

-(id)initWithViewControllers:(NSArray *)aViewControllers;

-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end
