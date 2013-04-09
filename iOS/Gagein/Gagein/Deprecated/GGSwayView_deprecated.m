//
//  GGSwayView.m
//  Gagein
//
//  Created by dong yiming on 13-4-7.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSwayView_deprecated.h"

@implementation GGSwayView_deprecated

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
    self.viewContent.clipsToBounds = YES;
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
    CGRect contentRc = self.viewContent.frame;
    contentRc.size.width = CGRectGetMaxX(aPage.frame);
    self.viewContent.frame = contentRc;
    
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
-(void)_hideAllPages
{
    for (UIView *view in self.viewContent.subviews) {
        view.hidden = YES;
    }
}

-(void)_animateToPageWithIndex:(NSUInteger)aIndex
{
    UIView *page = [self.viewContent.subviews objectAtIndex:aIndex];
    page.hidden = NO;
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect contentRc = self.viewContent.frame;
        contentRc.origin.x = - page.frame.origin.x;
        self.viewContent.frame = contentRc;
        
    } completion:^(BOOL finished) {
        [self _hideAllPages];
        page.hidden = NO;
    }];
}

@end
