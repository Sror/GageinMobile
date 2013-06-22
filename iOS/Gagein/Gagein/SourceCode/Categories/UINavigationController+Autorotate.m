//
//  UINavigationController+Autorotate.m
//  Gagein
//
//  Created by Dong Yiming on 6/21/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "UINavigationController+Autorotate.h"

@implementation UINavigationController (Autorotate)

- (NSUInteger)supportedInterfaceOrientations
{
    if (ISIPADDEVICE)
    {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

@end
