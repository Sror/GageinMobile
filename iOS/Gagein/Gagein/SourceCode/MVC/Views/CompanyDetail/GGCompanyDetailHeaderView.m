//
//  GGCompanyDetailHeaderView.m
//  Gagein
//
//  Created by dong yiming on 13-4-19.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyDetailHeaderView.h"

@implementation GGCompanyDetailHeaderView

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

+(float)HEIGHT
{
    return 40.f;
}

-(void)setTitleFontSize:(float)aFontSize
{
    _lblTitle.font = [UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE size:aFontSize];
}

@end
