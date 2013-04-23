//
//  GGCompaniesVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGScrollingView.h"
#import "GGSlideSettingView.h"

@interface GGCompaniesVC : GGBaseViewController
<UITableViewDelegate, UITableViewDataSource, GGScrollingViewDelegate, GGSlideSettingViewDelegate>
@property (strong)   NSMutableArray              *updates;
@property (strong)   NSMutableArray              *happenings;
@end
