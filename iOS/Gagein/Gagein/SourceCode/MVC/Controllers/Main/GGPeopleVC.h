//
//  GGPeopleVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSlideSettingView.h"

@interface GGPeopleVC : GGBaseViewController
<UITableViewDelegate
, UITableViewDataSource
, GGStyledSearchBarDelegate
, GGSlideSettingViewDelegate
, UIScrollViewDelegate>

@property (strong)   NSMutableArray              *updates;

@end
