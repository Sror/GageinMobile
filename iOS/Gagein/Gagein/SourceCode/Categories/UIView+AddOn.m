//
//  UIView+AddOn.m
//  Gagein
//
//  Created by Dong Yiming on 5/22/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "UIView+AddOn.h"
#include <objc/runtime.h>

static char kGGAssociateKeyTagNumber;
static char kGGAssociateKeyData;

static MBProgressHUD * hud;

@implementation UIView (AddOn)

@dynamic tagNumber;
@dynamic data;

-(void)setData:(id)data
{
    objc_setAssociatedObject(self, &kGGAssociateKeyData, data, OBJC_ASSOCIATION_COPY);
}

-(id)data
{
    return objc_getAssociatedObject(self, &kGGAssociateKeyData);
}

- (void)setTagNumber:(NSNumber *)tagNumber
{
    objc_setAssociatedObject(self, &kGGAssociateKeyTagNumber, tagNumber, OBJC_ASSOCIATION_COPY);

}

-(NSNumber *)tagNumber
{
    return objc_getAssociatedObject(self, &kGGAssociateKeyTagNumber);
}



-(void)showLoadingHUD
{
    
    [self showLoadingHUDWithOffsetY:0];
}

-(void)showLoadingHUDWithOffsetY:(float)aOffsetY
{
    [self showLoadingHUDWithOffset:CGSizeMake(0, aOffsetY)];
}

-(void)showLoadingHUDWithOffset:(CGSize)aOffset
{
    [hud hide:YES];
    hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.xOffset = aOffset.width;
    hud.yOffset = aOffset.height;
    hud.labelText = @"Loading";
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

-(void)centerMeHorizontally
{
    [self centerMeHorizontallyChangeMyWidth:self.frame.size.width];
}

-(void)centerMeHorizontallyChangeMyWidth:(CGFloat)aWidth
{
    CGRect myRc = self.frame;
    myRc.size.width = aWidth;
    myRc.origin.x = (self.superview.frame.size.width - aWidth) / 2;
    self.frame = myRc;
}

-(void)resignAllResponders
{
    [self resignFirstResponder];
    
    for (UIView *subView in self.subviews)
    {
        [subView resignAllResponders];
    }
}

-(float)maxHeightForContent
{
    float maxHeight = 0.f;
    for (UIView *subView in self.subviews)
    {
        float subMaxH = CGRectGetMaxY(subView.frame);
        maxHeight = MAX(maxHeight, subMaxH);
    }
    
    return maxHeight;
}

-(void)adjustHeightToFitContent
{
    CGRect thisRc = self.frame;
    thisRc.size.height = [self maxHeightForContent];
    self.frame = thisRc;
}

-(void)setPos:(CGPoint)aNewPos
{
    CGRect thisRc = self.frame;
    thisRc.origin = aNewPos;
    self.frame = thisRc;
}

-(void)setHeight:(float)aNewHeight
{
    CGRect thisRc = self.frame;
    thisRc.size.height = aNewHeight;
    self.frame = thisRc;
}

-(UIImage *)myPicture
{
    UIGraphicsBeginImageContext(self.bounds.size);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
}

@end
