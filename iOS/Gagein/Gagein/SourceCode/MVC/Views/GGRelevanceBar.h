//
//  GGRelevanceBar.h
//  Gagein
//
//  Created by dong yiming on 13-4-27.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GGSwitchButton;

@interface GGRelevanceBar : UIView
@property (weak, nonatomic) IBOutlet GGSwitchButton *btnSwitch;

+(float)HEIGHT;
@end
