//
//  GGWebVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-21.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGWebVC : GGBaseViewController <UIWebViewDelegate>
@property (copy) NSString *urlStr;
@end
