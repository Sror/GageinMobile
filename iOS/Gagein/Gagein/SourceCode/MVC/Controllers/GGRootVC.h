//
//  GGRootVC.h
//  Gagein
//
//  Created by dong yiming on 13-5-3.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSlideSettingView.h"

@interface GGRootVC : GGBaseViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (weak, nonatomic) IBOutlet UIView *viewCover;
@property (strong, nonatomic) GGSlideSettingView *viewSetting;

@property (assign)  BOOL    canBeDragged;
@property (readonly) BOOL    isRevealed;

-(void)enableSwipGesture:(BOOL)anEnabled;
-(void)enableTapGesture:(BOOL)anEnabled;

-(void)reveal;
-(void)cover;
-(void)bare;

-(void)reveal:(void(^)(void))completion;
- (void)cover:(void(^)(void))completion;
- (void)bare:(void(^)(void))completion;
@end
