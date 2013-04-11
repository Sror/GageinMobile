//
//  GGNaviBackButton.m
//  Gagein
//
//  Created by dong yiming on 13-4-11.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGNaviBackButton.h"

@implementation GGNaviBackButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _extraInit];
    }
    return self;
}

-(void)_extraInit
{
    UIImage *backBtnImage = [UIImage imageNamed:@"btnBackBg"];
    
    [self setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [self setTitle:@"Back" forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
//    self.titleLabel.frame = CGRectOffset(self.titleLabel.frame, 20, 0);   // no effect
    [self setTitleColor:GGSharedColor.veryLightGray forState:UIControlStateNormal];
    
    //make the buttons content appear in the top-left
//    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    
    //move text 10 pixels down and right
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
}

@end
