//
//  GGCompanyUpdateDetailVC.h
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface GGCompanyUpdateDetailVC : GGBaseViewController
<UIWebViewDelegate, MFMailComposeViewControllerDelegate>
//@property (assign) long long    newsID;
@property (copy)    NSString    *naviTitleString;
@property (strong)  NSArray     *updates;
@property (assign) NSUInteger   updateIndex;
@end
