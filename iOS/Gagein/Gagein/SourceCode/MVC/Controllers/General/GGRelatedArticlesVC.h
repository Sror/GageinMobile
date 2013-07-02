//
//  GGRelatedArticlesVC.h
//  Gagein
//
//  Created by Dong Yiming on 7/1/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGScrollToHideVC.h"

@interface GGRelatedArticlesVC : GGScrollToHideVC
<UITableViewDelegate, UITableViewDataSource>
@property (assign) long long                      updateID;
@property (assign) long long                      similarID;
@end
