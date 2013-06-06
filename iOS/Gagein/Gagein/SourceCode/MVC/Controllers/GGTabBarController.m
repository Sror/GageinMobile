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

@interface GGTabBarController ()

@end

@implementation GGTabBarController
{
    NSMutableArray *_normalImages;
    NSMutableArray *_selectedImages;
    NSMutableArray *_tabIcons;
    
    NSInteger _currentIndex;
    NSArray *_viewControllers;
    
    BOOL    _isTabbarHidden;
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

-(void)adjustTabbarPosForIpadWithOrient:(UIInterfaceOrientation)toInterfaceOrientation
{
    float offsetX = UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? 0 : -100;
    self.tabBar.frame = CGRectMake(offsetX
                                   , self.tabBar.frame.origin.y
                                   , self.tabBar.frame.size.width
                                   , self.tabBar.frame.size.height);
}

-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [self adjustTabbarPosForIpadWithOrient:toInterfaceOrientation];
    
    CGRect coverRc = GGSharedDelegate.rootVC.viewCover.bounds;
    self.view.frame = coverRc;
    
    for (UIViewController *vc in self.viewControllers)
    {
        vc.view.frame = vc.view.superview.bounds;
    }
}

#pragma mark - show/hide tabbar
- (void)showTabBarAnimated:(BOOL)aAnimated
{
    if (ISIPADDEVICE)   return;
    
    if (_isTabbarHidden)
    {
        _isTabbarHidden = NO;
        self.tabBar.hidden = NO;
        
        //int (^getGlobalInt)(void) = ^{ return GlobalInt; };
        void(^moveTabbarUp)(void) = ^{
            for (UIView *view in self.view.subviews) {
                if ([view isKindOfClass:[UITabBar class]]) {
                    [view setFrame:CGRectMake(_initialTabRect.origin.x, _initialTabRect.origin.y - 20, _initialTabRect.size.width, _initialTabRect.size.height)];
                }
            }
        };
        
        //
        void(^adjustOtherViews)(void) = ^{
            
            for (UIView *view in self.view.subviews)
            {
                if (![view isKindOfClass:[UITabBar class]])
                {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height-49.f)];
                }
            }
        };
        
        if (aAnimated)
        {
            [UIView animateWithDuration:.5f animations:^{
                
                moveTabbarUp();
                
            } completion:^(BOOL finished) {
                
                adjustOtherViews();
                
            }];
        }
        else
        {
            moveTabbarUp();
            adjustOtherViews();
        }
        
    }
}


- (void)hideTabBarAnimated:(BOOL)aAnimated
{
    if (ISIPADDEVICE)   return;
    
    if (!_isTabbarHidden)
    {
        _isTabbarHidden = YES;
        
        void(^moveTabbarDown)(void) = ^{
        
            for (UIView *view in self.view.subviews) {
                if ([view isKindOfClass:[UITabBar class]]) {
                    [view setFrame:CGRectMake(_initialTabRect.origin.x, _initialTabRect.origin.y + 60.f, _initialTabRect.size.width, _initialTabRect.size.height)];
                }
            }
        };
        
        void(^adjustOtherViews)(void) = ^{
            
            for (UIView *view in self.view.subviews) {
                if (![view isKindOfClass:[UITabBar class]]) {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height+49.f)];
                }
            }
            
        };
        
        adjustOtherViews();
        
        if (aAnimated)
        {
            [UIView animateWithDuration:.5f animations:^{
                
                moveTabbarDown();
                
            } completion:^(BOOL finished) {
                
                self.tabBar.hidden = YES;
            }];
        }
        else
        {
            moveTabbarDown();
            self.tabBar.hidden = YES;
        }
        
    }

}

@end
