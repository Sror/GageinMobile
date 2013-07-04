//
//  GGWhiteBackgroundImageView.m
//  Gagein
//
//  Created by Dong Yiming on 7/4/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGWhiteBackgroundImageView.h"

@implementation GGWhiteBackgroundImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = GGSharedImagePool.stretchShadowBgWite;
    }
    return self;
}

@end
