//
//  UIView+AddOn.m
//  Gagein
//
//  Created by Dong Yiming on 5/22/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "UIView+AddOn.h"

static MBProgressHUD * hud;

@implementation UIView (AddOn)


-(void)showLoadingHUD
{
    
    [hud hide:YES];
    hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    //hud.dimBackground = YES;
}

-(void)hideLoadingHUD
{
     [hud hide:YES];
}

-(void)removeAllGestureRecognizers
{
    for (UIGestureRecognizer *gest in self.gestureRecognizers)
    {
        [self removeGestureRecognizer:gest];
    }
}

-(void)goTop
{
    [self.superview bringSubviewToFront:self];
}

@end
