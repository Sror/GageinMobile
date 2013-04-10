//
//  GGSearchBar.m
//  Gagein
//
//  Created by dong yiming on 13-4-10.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSearchBar.h"

@implementation GGSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _customize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _customize];
    }
    return self;
}

-(UIButton *)cancelButton
{
    NSArray *subviews = self.subviews;
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            return (UIButton *)subview;
        }
    }
    return nil;
}


-(void)_customize
{
    NSArray *subviews = self.subviews;
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
        }
    }
}

@end
