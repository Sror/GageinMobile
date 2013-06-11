//
//  GGScrollToHideVC.m
//  Gagein
//
//  Created by Dong Yiming on 6/11/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGScrollToHideVC.h"

@interface GGScrollToHideVC ()

@end

@implementation GGScrollToHideVC
{
    CGPoint                 _offsetWhenStartDragging;
    NSMutableSet            *_scrolls;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrolls = [NSMutableSet set];
}

-(void)addScrollToHide:(UIScrollView *)aScrollView
{
    if ([aScrollView isKindOfClass:[UIScrollView class]])
    {
        aScrollView.delegate = self;
        [_scrolls addObject:aScrollView];
    }
}

-(void)removeScrollToHide:(UIScrollView *)aScrollView
{
    [_scrolls removeObject:aScrollView];
}

-(BOOL)_hasTheScrollView:(UIScrollView *)aScrollView
{
    for (id obj in _scrolls)
    {
        if (obj == aScrollView)
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if ([self _hasTheScrollView:scrollView])
    {
        _offsetWhenStartDragging = scrollView.contentOffset;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (!ISIPADDEVICE && scrollView.contentSize.height > scrollView.frame.size.height)
    {
        if (_offsetWhenStartDragging.y < scrollView.contentOffset.y)
        {
            //DLog(@"moved up");
            
            [GGUtils hideTabBar];
        }
        else
        {
            //DLog(@"moved down");
            
            [GGUtils showTabBar];
        }
    }
}

@end
