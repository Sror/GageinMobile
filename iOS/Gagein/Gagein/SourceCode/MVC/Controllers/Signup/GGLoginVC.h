//
//  GGLoginVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGLoginVC : GGBaseViewController <UITextFieldDelegate, UIScrollViewDelegate>
@property (strong) GGSnUserInfo *userInfo;
@end
