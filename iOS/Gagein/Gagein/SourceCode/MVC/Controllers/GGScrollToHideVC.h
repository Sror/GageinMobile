//
//  GGScrollToHideVC.h
//  Gagein
//
//  Created by Dong Yiming on 6/11/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGScrollToHideVC : GGBaseViewController <UIScrollViewDelegate>
@property (readonly, nonatomic) CGPoint    offsetWhenStartDragging;

-(void)addScrollToHide:(UIScrollView *)aScrollView;
-(void)removeScrollToHide:(UIScrollView *)aScrollView;

@end
