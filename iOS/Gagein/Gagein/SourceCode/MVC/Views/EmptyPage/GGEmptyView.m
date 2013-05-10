//
//  GGEmptyView.m
//  Gagein
//
//  Created by dong yiming on 13-5-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGEmptyView.h"

@implementation GGEmptyView

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
}

@end
