//
//  GGCompaniesVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSwitchButton.h"
#import "GGSlideSettingView.h"
#import "GGStyledSearchBar.h"
#import "GGScrollToHideVC.h"

@interface GGCompaniesVC : GGScrollToHideVC
<UITableViewDelegate
, UITableViewDataSource
, GGStyledSearchBarDelegate
//, GGSwitchButtonDelegate
, GGSlideSettingViewDelegate>

@property (strong)   NSMutableArray              *updates;
@property (strong)   NSMutableArray              *happenings;


@end
