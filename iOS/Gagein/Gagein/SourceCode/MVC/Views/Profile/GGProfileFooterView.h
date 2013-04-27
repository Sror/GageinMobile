//
//  GGProfileFooterView.h
//  Gagein
//
//  Created by dong yiming on 13-4-27.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGProfileFooterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentPlan;
@property (weak, nonatomic) IBOutlet UIButton *btnUpgrade;

+(float)HEIGHT;
@end
