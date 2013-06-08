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

-(UIView *)ancestorView
{
    UIView *ancestor = self.superview;
    UIView *realAncestor = ancestor;
    while (ancestor)
    {
        realAncestor = ancestor;
        ancestor = realAncestor.superview;
    }
    
    return realAncestor;
}

-(void)printViewsTree
{
    [self _doPrintViewsTreeWithLevel:0];
}

-(void)_doPrintViewsTreeWithLevel:(NSUInteger)aLevel
{
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < aLevel; i++)
    {
        [str appendString:@"  "];
    }
    [str appendString:@"|--"];
    
    DLog(@"%@%@", str, [self class]);
    
    for (UIView *sub in self.subviews)
    {
        [sub _doPrintViewsTreeWithLevel:aLevel + 1];
    }
}

@end
