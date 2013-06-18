//
//  GGTabBarController.m
//  TestTabBar
//
//  Created by dong yiming on 13-4-23.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGTabBarController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreFoundation/CoreFoundation.h>
#import "GGAppDelegate.h"

#define ICON_WIDTH      76
#define ICON_HEIGHT     48

#define TABBAR_ANIM_DURATION    .4f

@interface GGTabBarController ()

@end

@implementation GGTabBarController
{
    NSMutableArray *_normalImages;
    NSMutableArray *_selectedImages;
    NSMutableArray *_tabIcons;
    
    NSInteger _currentIndex;
    NSArray *_viewControllers;
    
    //BOOL    _isTabbarHidden;
}

-(id)initWithViewControllers:(NSArray *)aViewControllers
{
    NSAssert(aViewControllers.count, @"view controllers is empty");
    
    _viewControllers = aViewControllers;
    NSUInteger vcCount = aViewControllers.count;
    
    _normalImages = [[NSMutableArray alloc] initWithCapacity:vcCount];
    _selectedImages = [[NSMutableArray alloc] initWithCapacity:vcCount];
    _tabIcons = [[NSMutableArray alloc] initWithCapacity:vcCount];
    
    [_normalImages addObject:[UIImage imageNamed:@"tab_company_normal"]];
    [_normalImages addObject:[UIImage imageNamed:@"tab_people_normal"]];
    [_normalImages addObject:[UIImage imageNamed:@"tab_saved_normal"]];
    [_normalImages addObject:[UIImage imageNamed:@"tab_settings_normal"]];
    
    [_selectedImages addObject:[UIImage imageNamed:@"tab_company_selected"]];
    [_selectedImages addObject:[UIImage imageNamed:@"tab_people_selected"]];
    [_selectedImages addObject:[UIImage imageNamed:@"tab_saved_selected"]];
    [_selectedImages addObject:[UIImage imageNamed:@"tab_settings_selected"]];
    
    _currentIndex = 0;
    
    self = [super init];
    if (self)
    {
        self.viewControllers = aViewControllers;
    }
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    _initialTabRect = self.tabBar.frame;

    [self _costomizeTab];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self _costomizeTab];
}

#pragma mark - overwrite
-(void)setSelectedViewController:(UIViewController *)selectedViewController
{
    [super setSelectedViewController:selectedViewController];
    [self _selectedAt:[self _indexForVC:selectedViewController]];
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    [self _selectedAt:selectedIndex];
}

#pragma mark - internal
-(void)_costomizeTab
{
    static BOOL isLoaded = NO;
    NSArray *subviews = self.tabBar.subviews;
    
    if (!isLoaded && subviews.count > 4)
    {
        isLoaded = YES;
        
        NSUInteger vcCount = _viewControllers.count;
        int startIndex = 1;
        
        for (int i = startIndex; i< vcCount + startIndex; i++)
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ICON_WIDTH, ICON_HEIGHT)];
            UIImage *theImage = _normalImages[i - startIndex];
            imgView.image = theImage;
            
            [subviews[i] addSubview:imgView];
            
            [_tabIcons addObject:imgView];
        }
        
        [_tabIcons[_currentIndex] setImage:_selectedImages[_currentIndex]];
        
        //make indicator image transparent
        self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"transparent.png"];
    }
}

-(int)_indexForVC:(UIViewController *)aViewController
{
    int index = 0;
    for (UIViewController *vc in self.viewControllers)
    {
        if (vc == aViewController)
        {
            return index;
        }
        index++;
    }
    
    return -1;
}

-(UIImageView*)_iconAt:(NSUInteger)aIndex
{
    return (UIImageView*)_tabIcons[aIndex];
}

-(void)_selectedAt:(NSInteger)index
{
    if (_currentIndex != index)
    {
        [[self _iconAt:_currentIndex] setImage:[_normalImages objectAtIndex:_currentIndex]];
        [[self _iconAt:index] setImage:[_selectedImages objectAtIndex:index]];
        
//        UIViewController *vc = self.viewControllers[index];
//        if ([vc isKindOfClass:[UINavigationController class]])
//        {
//            UIViewController *subVC = ((UINavigationController *)vc).viewControllers[0];
//            if ([subVC isKindOfClass:[GGBaseViewController class]])
//            {
//                [((GGBaseViewController *)subVC) layoutUIForIPadIfNeeded];
//            }
//        }
        
        _currentIndex = index;
    }
}

#pragma mark - unused method
-(UINavigationController*)navControllerWithRootByClassName:(NSString*)aClassName
{
    NSAssert(aClassName.length
             && NSClassFromString(aClassName)
             && [NSClassFromString(aClassName) isSubclassOfClass:[UIViewController class]]
             , @"bad class name");
    
    Class theClass = NSClassFromString(aClassName);
    
    UIViewController* rootVC = [[theClass alloc] initWithNibName:aClassName bundle:nil];
    return [[UINavigationController alloc] initWithRootViewController:rootVC];
}

-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect coverRc = GGSharedDelegate.rootVC.viewCover.bounds;
    self.view.frame = coverRc;
    
    //[self.view printViewsTree];
    
    for (UIViewController *vc in self.viewControllers)
    {
        CGRect superRc = vc.view.superview.bounds;
        vc.view.frame = superRc;
    }
}

#pragma mark - show/hide tabbar
- (void)showTabBarAnimated:(BOOL)aAnimated
{
    if (ISIPADDEVICE)   return;
    //[self.view.layer removeAllAnimations];
    
    _isTabbarHidden = NO;
    //self.tabBar.hidden = NO;
    
    void(^moveTabbarUp)(void) = ^{
        self.tabBar.frame = CGRectMake(_initialTabRect.origin.x, _initialTabRect.origin.y - 20.f, _initialTabRect.size.width, _initialTabRect.size.height);
    };
    
    if (aAnimated)
    {
        [UIView animateWithDuration:TABBAR_ANIM_DURATION animations:^{
            
            moveTabbarUp();
            
            
        } completion:^(BOOL finished){
            DLog(@"show tabbar finished:%d", finished);
            
        }];
        
        
        
        [UIView animateWithDuration:TABBAR_ANIM_DURATION * 2 animations:^{
            [self _adjustOtherViewsHideBar:NO];
        }];
    }
    else
    {
        moveTabbarUp();
        [self _adjustOtherViewsHideBar:NO];
    }
}


- (void)hideTabBarAnimated:(BOOL)aAnimated
{
    if (ISIPADDEVICE)   return;
    //[self.view.layer removeAllAnimations];
    
    _isTabbarHidden = YES;
    //self.tabBar.hidden = YES;
    
    void(^moveTabbarDown)(void) = ^{
        
        self.tabBar.frame = CGRectMake(_initialTabRect.origin.x, _initialTabRect.origin.y + 60.f, _initialTabRect.size.width, _initialTabRect.size.height);
    };
    
    [self _adjustOtherViewsHideBar:YES];
    
    if (aAnimated)
    {
        [UIView animateWithDuration:TABBAR_ANIM_DURATION animations:^{
            
           moveTabbarDown();
            
        } completion:^(BOOL finished) {
            DLog(@"hide tabbar finished:%d", finished);
            
            
        }];
    }
    else
    {
        moveTabbarDown();
        self.tabBar.hidden = YES;
    }
}

-(void)_adjustBarHide:(BOOL)aHide
{
    float offsetY = aHide ? _initialTabRect.origin.y - 20 : _initialTabRect.origin.y + 60.f;
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(_initialTabRect.origin.x, offsetY, _initialTabRect.size.width, _initialTabRect.size.height)];
        }
    }
}

-(void)_adjustOtherViewsHideBar:(BOOL)aHide
{
    for (UIView *view in self.view.subviews)
    {
        if (![view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [self _heightForSubView:view hideBar:aHide])];
        }
    }
}

-(float)_heightForSubView:(UIView *)aView hideBar:(BOOL)aHide
{
    float bottomLine = aHide ? self.view.frame.size.height : self.view.frame.size.height - 49.f;
    return bottomLine - aView.frame.origin.y;
}

@end
