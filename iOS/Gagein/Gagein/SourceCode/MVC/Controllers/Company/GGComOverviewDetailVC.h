//
//  GGComOverviewDetailVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGComOverviewDetailVC : GGBaseViewController
<UITableViewDataSource, UITableViewDelegate>
@property (strong) GGCompany    *overview;
@end
