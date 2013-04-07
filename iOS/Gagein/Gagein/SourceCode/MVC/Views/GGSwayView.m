//
//  GGSwayView.m
//  Gagein
//
//  Created by dong yiming on 13-4-7.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSwayView.h"

@implementation GGSwayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib
{
    self.backgroundColor = SharedColor.darkRed;
    self.viewPageControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
    [self.pageControl addTarget:self action:@selector(pageSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
-(void)addPage:(UIView *)aPage
{
    NSAssert(aPage, @"page must not nil");
    
    UIView *prevPage = [self.viewContent.subviews lastObject];
    if (prevPage) {
        int x = CGRectGetMaxX(prevPage.frame);
        CGRect pageRc = aPage.frame;
        pageRc.origin.x = x;
        aPage.frame = pageRc;
    }
    
    [self.viewContent addSubview:aPage];
    self.pageControl.numberOfPages = self.viewContent.subviews.count;
    //self.viewContent.frame = CGRectOffset(self.viewContent.frame, -aPage.frame.origin.x, 0);
}

#pragma mark - actions

-(IBAction)leftSwipeAction:(id)sender
{
    //DLog(@"swipe left");
    self.pageControl.currentPage = 1;
    [self pageSelectedAction:self.pageControl];
}

-(IBAction)rightSwipeAction:(id)sender
{
    //DLog(@"swipe right");
    self.pageControl.currentPage = 0;
    [self pageSelectedAction:self.pageControl];
}

-(void)pageSelectedAction:(id)sender
{
    DLog(@"page index:%d", self.pageControl.currentPage);
    [self _animateToPageWithIndex:self.pageControl.currentPage];
}

#pragma mark - internal
-(void)_animateToPageWithIndex:(NSUInteger)aIndex
{
    UIView *page = [self.viewContent.subviews objectAtIndex:aIndex];
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect contentRc = self.viewContent.frame;
        contentRc.origin.x = - page.frame.origin.x;
        self.viewContent.frame = contentRc;
        
    } completion:^(BOOL finished) {
        //
    }];
}

@end
