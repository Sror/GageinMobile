//
//  GGSsgrfRndImgButton.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/12/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfRndImgButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation GGSsgrfRndImgButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _doInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self _doInit];
    }
    
    return self;
}

-(void)_doInit
{
    self.layer.cornerRadius = 8.f;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 2.f;
    self.clipsToBounds = YES;
}

-(void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

-(void)setImageWithURL:(NSString *)aURL
{
    [self setImageWithURL:[NSURL URLWithString:aURL]];
}

-(void)clearActions
{
    [self removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
}

-(void)addTarget:(id)target action:(SEL)action
{
    //
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
