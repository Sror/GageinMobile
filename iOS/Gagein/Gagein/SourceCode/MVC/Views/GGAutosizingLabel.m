//
//  GGAutosizingLabel.m
//  Gagein
//
//  Created by Dong Yiming on 5/13/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#define MIN_HEIGHT 10.0f

#import "GGAutosizingLabel.h"

@implementation GGAutosizingLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init {
    if ([super init]) {
        _minHeight = MIN_HEIGHT;
        [self setNumberOfLines:0];
        [self setLineBreakMode:UILineBreakModeWordWrap];
    }
    
    return self;
}

- (void)calculateSize {
    //self.backgroundColor = GGSharedColor.darkRed;
    CGSize constraint = CGSizeMake(self.frame.size.width, 20000.0f);
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:constraint lineBreakMode:self.lineBreakMode];
    
    [self setAdjustsFontSizeToFitWidth:NO];
    
    CGRect newRc = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, MAX(size.height, MIN_HEIGHT));
    self.frame = newRc;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self calculateSize];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    [self calculateSize];
}
@end
