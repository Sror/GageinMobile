//
//  GGScrollingView.h
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGScrollingView : UIView <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewPageControl;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *viewScroll;

-(void)addPage:(UIView *)aPage;
@end
