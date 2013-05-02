//
//  GGConfigSwitchCell.h
//  Gagein
//
//  Created by dong yiming on 13-5-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSwitchButton.h"

@interface GGConfigSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet GGSwitchButton *btnSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

+(float)HEIGHT;
@end
