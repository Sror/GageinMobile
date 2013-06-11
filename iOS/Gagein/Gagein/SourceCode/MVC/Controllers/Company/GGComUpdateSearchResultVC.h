//
//  GGComUpdateSearchResultVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-24.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGScrollToHideVC.h"

@interface GGComUpdateSearchResultVC : GGScrollToHideVC
<UITableViewDelegate, UITableViewDataSource>
@property (strong)   NSMutableArray              *updates;
@property (copy)    NSString                    *keyword;
@end
