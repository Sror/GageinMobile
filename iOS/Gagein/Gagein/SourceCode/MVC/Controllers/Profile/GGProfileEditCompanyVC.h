//
//  GGProfileEditCompanyVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-27.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGStyledSearchBar.h"

@interface GGProfileEditCompanyVC : GGBaseViewController
<UITableViewDataSource, UITableViewDelegate, GGStyledSearchBarDelegate>
@property (strong) GGUserProfile       *userProfile;
@end
