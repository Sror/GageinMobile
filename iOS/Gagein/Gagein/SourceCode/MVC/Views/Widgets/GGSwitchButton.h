//
//  GGSwitchButton.h
//  TestCostomSwitch
//
//  Created by dong yiming on 13-4-23.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GGSwitchButton;

@protocol GGSwitchButtonDelegate
-(void)switchButton:(GGSwitchButton *)aSwitchButton isOn:(BOOL)aIsOn;
@end

@interface GGSwitchButton : UIView
@property (assign, nonatomic) BOOL   isOn;
@property (weak, nonatomic) id<GGSwitchButtonDelegate>  delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnSwitch;

@property (weak, nonatomic) IBOutlet UIView *viewOn;
@property (weak, nonatomic) IBOutlet UIImageView *ivBgOn;
@property (weak, nonatomic) IBOutlet UIImageView *ivKnobOn;
@property (weak, nonatomic) IBOutlet UILabel *lblOn;

@property (weak, nonatomic) IBOutlet UIView *viewOff;
@property (weak, nonatomic) IBOutlet UIImageView *ivBgOff;
@property (weak, nonatomic) IBOutlet UIImageView *ivKnobOff;
@property (weak, nonatomic) IBOutlet UILabel *lblOff;


-(void)switchOn:(BOOL)aIsOn;

+(float)HEIGHT;
-(void)changeSkin:(BOOL)aIsLight;
@end
