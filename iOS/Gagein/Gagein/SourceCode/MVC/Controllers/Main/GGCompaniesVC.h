//
//  GGCompaniesVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGScrollingView.h"

@interface GGCompaniesVC : GGBaseViewController
<UITableViewDelegate, UITableViewDataSource, GGScrollingViewDelegate>
@property (strong)   NSMutableArray              *updates;
@end
