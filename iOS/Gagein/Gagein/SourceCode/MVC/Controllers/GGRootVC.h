//
//  GGRootVC.h
//  Gagein
//
//  Created by dong yiming on 13-5-3.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSlideSettingView.h"

@interface GGRootVC : GGBaseViewController
@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (weak, nonatomic) IBOutlet UIView *viewCover;
@property (strong, nonatomic) GGSlideSettingView *viewSetting;

-(void)enableSwipGesture:(BOOL)anEnabled;
-(void)enableTapGesture:(BOOL)anEnabled;
-(void)reveal;
- (void)cover;
-(void)reveal:(void(^)(void))completion;
- (void)cover:(void(^)(void))completion;
@end
