//
//  GGOrientation.m
//  Gagein
//
//  Created by Dong Yiming on 7/4/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGOrientation.h"

@implementation GGOrientation


+(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (ISIPADDEVICE)
    {
        return YES;
    }
    
    return toInterfaceOrientation == UIInterfaceOrientationPortrait; // etc
}

+ (BOOL)shouldAutorotate
{
    
    if (ISIPADDEVICE)
    {
        return YES;
    }
    
    return NO;
}

+(NSUInteger)supportedInterfaceOrientations
{
    
    if (ISIPADDEVICE)
    {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskPortrait; // etc
}

@end
