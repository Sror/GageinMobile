//
//  UIButton+GGAddOn.m
//  Gagein
//
//  Created by Dong Yiming on 6/27/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "UIButton+GGAddOn.h"

@implementation UIButton (GGAddOn)

-(void)addAction:(GGTagetActionPair *)anAction
{
    if (anAction && anAction.action)
    {
        [self addTarget:anAction.target action:anAction.action forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
