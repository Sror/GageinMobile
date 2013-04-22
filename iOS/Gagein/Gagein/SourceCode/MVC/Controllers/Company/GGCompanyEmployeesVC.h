//
//  GGCompanyEmployeesVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGCompanyEmployeesVC : GGBaseViewController
<UITableViewDelegate, UITableViewDataSource>
@property (strong)   NSMutableArray              *employees;
@property (assign) long long                      companyID;
@end
