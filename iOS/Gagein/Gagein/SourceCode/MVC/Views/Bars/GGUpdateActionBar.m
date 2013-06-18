//
//  GGUpdateActionBar.m
//  Gagein
//
//  Created by Dong Yiming on 6/15/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGUpdateActionBar.h"

@implementation GGUpdateActionBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)useForHappening
{
    _btnSave.hidden = _btnLike.hidden = _btnSignal.hidden = YES;
}

@end
