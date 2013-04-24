//
//  GGComUpdateSearchVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-24.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGComUpdateSearchVC : GGBaseViewController
<UITableViewDataSource, UITableViewDelegate>
@property (copy)    NSString    *keyword;
@end
