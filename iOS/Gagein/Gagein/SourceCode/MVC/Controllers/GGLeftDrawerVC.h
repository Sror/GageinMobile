//
//  GGLeftDrawerVC.h
//  Gagein
//
//  Created by Dong Yiming on 6/23/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGSlideSettingView.h"

@interface GGLeftDrawerVC : GGBaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong ,nonatomic) GGSlideSettingView    *viewMenu;
@property (strong, nonatomic) UIView                                    *viewContent;

@end
