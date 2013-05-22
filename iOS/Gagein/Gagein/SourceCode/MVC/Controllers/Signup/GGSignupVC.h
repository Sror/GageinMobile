//
//  GGSignupVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGSnUserInfo;

@interface GGSignupVC : GGBaseViewController <UITextFieldDelegate, UIScrollViewDelegate>
@property (strong) GGSnUserInfo *userInfo;
@end
