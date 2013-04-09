//
//  GGScrollingView.m
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGScrollingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GGScrollingView
{
    NSMutableArray *_pages;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _extraInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _extraInit];
    }
    return self;
}

-(void)_extraInit
{
    _pages = [NSMutableArray array];
}

-(void)awakeFromNib
{
    _viewPageControl.layer.opacity = .7f;
    [self.pageControl addTarget:self action:@selector(pageSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
-(void)addPage:(UIView *)aPage
{
    NSAssert(aPage, @"page must not nil");
    
    UIView *prevPage = _pages.lastObject;
    if (prevPage) {
        int x = CGRectGetMaxX(prevPage.frame);
        CGRect pageRc = aPage.frame;
        pageRc.origin.x = x;
        aPage.frame = pageRc;
    }
    
    [_pages addObject:aPage];
    [self.viewScroll addSubview:aPage];
    
    CGSize contentSize = CGSizeMake(CGRectGetMaxX(aPage.frame), aPage.frame.size.height);
    self.viewScroll.contentSize = contentSize;
    
    self.pageControl.numberOfPages = _pages.count;
}

#pragma mark -
-(void)pageSelectedAction:(id)sender
{
    self.viewScroll.contentOffset = CGPointMake(self.viewScroll.frame.size.width * self.pageControl.currentPage, 0);
}

#pragma mark - scroll view delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = self.viewScroll.contentOffset.x / self.viewScroll.frame.size.width;
    self.pageControl.currentPage = currentPage;
}

@end
