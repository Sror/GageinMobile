//
//  GGSimilarCompaniesVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGScrollToHideVC.h"

@interface GGSimilarCompaniesVC : GGScrollToHideVC
<UITableViewDelegate, UITableViewDataSource>
@property (strong)   NSMutableArray              *similarCompanies;
@property (assign) long long                      companyID;
@end
