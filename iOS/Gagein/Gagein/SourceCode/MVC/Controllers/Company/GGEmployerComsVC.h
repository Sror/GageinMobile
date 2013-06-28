//
//  GGEmployerComsVC.h
//  Gagein
//
//  Created by Dong Yiming on 6/28/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGScrollToHideVC.h"

@interface GGEmployerComsVC : GGScrollToHideVC
<UITableViewDelegate, UITableViewDataSource>

@property (strong)   NSMutableArray              *companies;

@end
