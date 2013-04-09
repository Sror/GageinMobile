//
//  GGSwayView.h
//  Gagein
//
//  Created by dong yiming on 13-4-7.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSwayView_deprecated : UIView
@property (weak, nonatomic) IBOutlet UIView *viewPageControl;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipe;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwip;
@property (weak, nonatomic) IBOutlet UIView *viewContent;

-(void)addPage:(UIView *)aPage;
@end
