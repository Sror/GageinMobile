//
//  GGConfigSwitchCell.h
//  Gagein
//
//  Created by dong yiming on 13-5-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGConfigSwitchView.h"

@interface GGConfigSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet GGConfigSwitchView *viewContent;


+(float)HEIGHT;
@end
