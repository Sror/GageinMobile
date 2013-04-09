//
//  GGScrollingView.h
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGScrollingView;

@protocol GGScrollingViewDelegate

-(void)scrollingView:(GGScrollingView *)aScrollingView didScrollToIndex:(NSUInteger)aPageIndex;

@end

@interface GGScrollingView : UIView <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewPageControl;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *viewScroll;

@property (weak, nonatomic) id<GGScrollingViewDelegate> delegate;

-(void)addPage:(UIView *)aPage;
@end
