//
//  GGConfigSwitchView.h
//  Gagein
//
//  Created by Dong Yiming on 5/14/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSwitchButton.h"

@interface GGConfigSwitchView : UIView
@property (weak, nonatomic) IBOutlet GGSwitchButton *btnSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

+(float)HEIGHT;
@end
