//
//  GGHappeningsVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGScrollToHideVC.h"

@interface GGHappeningsVC : GGScrollToHideVC
<UITableViewDelegate, UITableViewDataSource>
@property (strong)   NSMutableArray              *happenings;
@property (assign) long long                      companyID;
@property (assign) long long                      personID;
@property (assign) BOOL                          isPersonHappenings;
@end
