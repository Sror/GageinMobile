//
//  UILabel+AddOn.m
//  Gagein
//
//  Created by Dong Yiming on 5/23/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "UILabel+AddOn.h"

#define MIN_HEIGHT  10

@implementation UILabel (AddOn)

- (void)calculateSize
{
    CGSize constraint = CGSizeMake(self.frame.size.width, FLT_MAX);
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:constraint lineBreakMode:self.lineBreakMode];
    
    
    //float realHeight = size.height * size.width / constraint.width;
    
    
    CGRect newRc = self.frame;
    newRc.size.height = size.height;
    self.frame = newRc;
}

@end
