//
//  GGSettingHeaderView.h
//  Gagein
//
//  Created by dong yiming on 13-4-12.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSettingHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnConfig;

+(float)HEIGHT;

@end
