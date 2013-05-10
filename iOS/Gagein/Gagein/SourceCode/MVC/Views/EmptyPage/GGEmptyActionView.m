//
//  GGEmptyActionView.m
//  Gagein
//
//  Created by dong yiming on 13-5-10.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGEmptyActionView.h"

@implementation GGEmptyActionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.backgroundColor = GGSharedColor.silver;
    [_btnAction setBackgroundImage:GGSharedImagePool.bgBtnOrange forState:UIControlStateNormal];
    //self.hidden = YES;
}

@end
