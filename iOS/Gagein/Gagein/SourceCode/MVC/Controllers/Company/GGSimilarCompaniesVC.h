//
//  GGSimilarCompaniesVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSimilarCompaniesVC : GGBaseViewController
<UITableViewDelegate, UITableViewDataSource>
@property (strong)   NSMutableArray              *similarCompanies;
@property (assign) long long                      companyID;
@end
