//
//  GGSelectAgentsVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSelectAgentsVC : UIViewController
<UITableViewDataSource, UITableViewDelegate>
@property (assign) BOOL isFromRegistration;
@end