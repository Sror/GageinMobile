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
    [self calculateSizeConstaintToHeight:FLT_MAX];
}

-(void)calculateSizeConstaintToHeight:(float)aMaxHeight
{
    CGSize size = [self calculatedSize:aMaxHeight];
    
    //float realHeight = size.height * size.width / constraint.width;
    
    
    CGRect newRc = self.frame;
    newRc.size.height = size.height;
    self.frame = newRc;
}

-(CGSize)calculatedSize
{
    return [self calculatedSize:FLT_MAX];
}

-(CGSize)calculatedSize:(float)aMaxHeight
{
    CGSize constraint = CGSizeMake(self.frame.size.width, aMaxHeight);
    return [self.text sizeWithFont:self.font constrainedToSize:constraint lineBreakMode:self.lineBreakMode];
}

@end
