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
    self.view.backgroundColor = GGSharedColor.silver;
    
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
    
    DLog(@"start drag");
    if ([self _hasTheScrollView:scrollView])
    {
        _offsetWhenStartDragging = scrollView.contentOffset;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (!ISIPADDEVICE /*&& scrollView.contentSize.height > scrollView.frame.size.height*/)
    {
        if (_offsetWhenStartDragging.y < scrollView.contentOffset.y)
        {
            DLog(@"moved up");
            
            [GGUtils hideTabBar];
        }
        else
        {
            DLog(@"moved down");
            
            [GGUtils showTabBar];
        }
        
        [self adjustScrollViewFrames];
    }
}

-(void)adjustScrollViewFrames
{
    for (UIScrollView *scrollView in _scrolls)
    {
        CGRect updateRc = scrollView.frame;
        updateRc.size.width = scrollView.superview.bounds.size.width;
        updateRc.size.height = scrollView.superview.bounds.size.height - updateRc.origin.y;
        scrollView.frame = updateRc;
    }
}

@end
