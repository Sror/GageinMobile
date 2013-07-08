//
//  GGHappeningDetailVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-24.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface GGHappeningDetailVC : GGBaseViewController
<UITableViewDataSource
, UITableViewDelegate
, MFMailComposeViewControllerDelegate
, MFMessageComposeViewControllerDelegate
, UIAlertViewDelegate>

@property (strong) NSMutableArray       *happenings;
@property (assign) NSUInteger           happeningIndex;
@end
