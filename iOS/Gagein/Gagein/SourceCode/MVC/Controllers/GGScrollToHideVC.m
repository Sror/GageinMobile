//
//  GGScrollToHideVC.m
//  Gagein
//
//  Created by Dong Yiming on 6/11/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGScrollToHideVC.h"
#import "GGAppDelegate.h"

@interface GGScrollToHideVC ()

@end

@implementation GGScrollToHideVC
{
    //CGPoint                 _offsetWhenStartDragging;
    NSMutableSet            *_scrolls;
    //NSMutableArray            *_excludeScrolls;
    
//    NSDate                  *_lastScrollTime;
//    float                   _lastScrollY;
    
    CGPoint lastOffset;
    NSTimeInterval lastOffsetCapture;
    
    BOOL    _isDragging;
    //BOOL isScrollingFast;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GGSharedColor.silver;
    
    _scrolls = [NSMutableSet set];
    //_excludeScrolls = [NSMutableArray array];
    
    [GGSharedDelegate.tabBarController adjustOtherViewsHideBar:YES];
}

-(BOOL)canAutoHideTabbar
{
    return YES;
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
    
    //DLog(@"start drag");
    _isDragging = YES;
//    if ([self _hasTheScrollView:scrollView])
//    {
//        _offsetWhenStartDragging = scrollView.contentOffset;
//    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //DLog(@"end drag");
    _isDragging = NO;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
//    int index = [_excludeScrolls indexOfObject:scrollView];
//    if (!ISIPADDEVICE && index == NSNotFound /*&& scrollView.contentSize.height > scrollView.frame.size.height*/)
//    {
//        if (_offsetWhenStartDragging.y < scrollView.contentOffset.y)
//        {
//            [GGUtils hideTabBar];
//        }
//        else
//        {
//            [GGUtils showTabBar];
//        }
//        
//        [self adjustScrollViewFrames];
//    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    //int index = [_excludeScrolls indexOfObject:scrollView];
    if (!ISIPADDEVICE && [_scrolls containsObject:scrollView] && scrollView.isDragging)
    {
        CGPoint currentOffset = scrollView.contentOffset;
        NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
        
        NSTimeInterval timeDiff = currentTime - lastOffsetCapture;
        if(timeDiff > 0.1) {
            CGFloat distance = currentOffset.y - lastOffset.y;
            //The multiply by 10, / 1000 isn't really necessary.......
            CGFloat scrollSpeedNotAbs = (distance * 10) / 1000; //in pixels per millisecond
            
            CGFloat scrollSpeed = fabsf(scrollSpeedNotAbs);
            
            if (scrollSpeed > 0.1) // speed reaches min limit
            {
                //DLog(@"isDragging:%d", scrollView.isDragging);
                if (scrollSpeedNotAbs > 0)
                {
                    [GGUtils hideTabBar];
                }
                else
                {
                    [GGUtils showTabBar];
                }
            }
            
            lastOffset = currentOffset;
            lastOffsetCapture = currentTime;
        }
    }
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSDate *now = [NSDate date];
//    float currentOffsetY = scrollView.contentOffset.y;
//    
//    int interval = [now timeIntervalSinceDate:_lastScrollTime];
//    float changeY = currentOffsetY - _lastScrollY;
//    
//    DLog(@"interval:%d, changeY:%f", interval, changeY);
//    _lastScrollTime = now;
//    _lastScrollY = currentOffsetY;
//}

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
