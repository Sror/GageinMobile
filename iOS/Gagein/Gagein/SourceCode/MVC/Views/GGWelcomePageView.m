//
//  GGWelcomePageView.m
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGWelcomePageView.h"

@implementation GGWelcomePageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)showImageWithIndex:(NSUInteger)aIndex
{
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome0%d", aIndex + 1]];
}

@end
