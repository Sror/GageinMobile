//
//  GGWelcomeVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXPageControl.h"

@interface GGWelcomeVC : GGBaseViewController
<UIScrollViewDelegate, FXPageControlDelegate>
@property (weak, nonatomic) IBOutlet FXPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (weak, nonatomic) IBOutlet FXPageControl     *customPageControl;
@end
