//
//  UIView+AddOn.h
//  Gagein
//
//  Created by Dong Yiming on 5/22/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (AddOn)

-(void)showLoadingHUD;
-(void)showLoadingHUDWithOffsetY:(float)aOffsetY;
-(void)showLoadingHUDWithOffset:(CGSize)aOffset;

-(void)hideLoadingHUD;

-(void)removeAllGestureRecognizers;

-(void)goTop;

-(UIView *)ancestorView;

-(void)printViewsTree;

-(void)centerMeHorizontally;

-(void)centerMeHorizontallyChangeMyWidth:(CGFloat)aWidth;

-(void)resignAllResponders;

@end
