//
//  GGNavigationController.m
//  Gagein
//
//  Created by Dong Yiming on 6/11/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGNavigationController.h"
#import "SINavigationMenuView.h"
#import "GGAppDelegate.h"

@interface GGNavigationController ()<SINavigationMenuDelegate>

@end

@implementation GGNavigationController
{
    BOOL    _hasInitialized;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self _doInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _doInit];
    }
    return self;
}

#define MENU_BUTTON_WIDTH       (200.f)
-(void)_doInit
{
    if (!_hasInitialized)
    {
        _hasInitialized = YES;
        
        if (!ISIPADDEVICE)
        {
            CGSize barSz = self.navigationBar.frame.size;
            CGRect frame = CGRectMake((barSz.width - MENU_BUTTON_WIDTH) / 2
                                      , 0.0
                                      , MENU_BUTTON_WIDTH
                                      , barSz.height);
            _dropMenu = [[SINavigationMenuView alloc] initWithFrame:frame title:@""];
            
            _dropMenu.items = @[@"Companies", @"People", @"Saved", @"Settings"];
            _dropMenu.images = @[@"dropDownCompany", @"dropDownPeople", @"dropDownSaved", @"dropDownSettings"];
            _dropMenu.delegate = self;
            _dropMenu.hidden = YES;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_dropMenu displayMenuInView:self.view];
    [self.navigationBar addSubview:_dropMenu];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

#pragma mark -
- (void)didSelectItemAtIndex:(NSUInteger)index
{
    GGSharedDelegate.tabBarController.selectedIndex = index;
    DLog(@"did selected item at index %d", index);
}

#pragma mark -
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self _animated:animated isPush:YES];
    
    [super pushViewController:viewController animated:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self _animated:animated isPush:NO];
    return [super popViewControllerAnimated:NO];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self _animated:animated isPush:NO];
    return [super popToViewController:viewController animated:NO];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    [self _animated:animated isPush:NO];
    return [self popToRootViewControllerAnimated:NO];
}

-(void)_animated:(BOOL)aAnimated isPush:(BOOL)aIsPush
{
    if (aAnimated)
    {
        CAAnimation *animation = aIsPush ? [GGAnimation animationMoveInFromRight] : [GGAnimation animationRevealFromLeft];
        
//        if (ISIPADDEVICE)
//        {
//            animation = [GGAnimation animationFade];
//        }
        
        [UIView animateWithDuration:.5f animations:^{
            [self.view.layer addAnimation:animation forKey:nil];
        }];
    }
}

@end
