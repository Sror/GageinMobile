//
//  GGPersonDetailVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-26.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPersonDetailVC : GGBaseViewController
<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (assign) long long    personID;
@property (assign) BOOL         isPresented;
@end
