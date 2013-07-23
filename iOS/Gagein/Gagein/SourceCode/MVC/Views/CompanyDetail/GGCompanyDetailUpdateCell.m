//
//  GGCompanyDetailUpdateCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-19.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyDetailUpdateCell.h"

@implementation GGCompanyDetailUpdateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib
{
    self.viewCellBg.backgroundColor = GGSharedColor.silver;
    
    _lblSource.textColor = _lblInterval.textColor = GGSharedColor.grayTopText;
}

#define MIN_CELL_HEIGHT     (65.f)
+(float)HEIGHT
{
    return MIN_CELL_HEIGHT;
    //@throw [NSException exceptionWithName:@"deprecated" reason:@"deprecated, use heightWithHeadLine:" userInfo:nil];
}


#define HEADLINE_Y              (22.f)
#define HEADLINE_WIDTH          (285.f)
#define CONTENT_BOTTOM_PADDING  (5)
-(void)doLayout
{
    [_lblHeadLine sizeToFitFixWidth];
    
    float contentHeight = CGRectGetMaxY(_lblHeadLine.frame) + CONTENT_BOTTOM_PADDING;
    contentHeight = MAX(MIN_CELL_HEIGHT, contentHeight);
    [_viewContent setHeight:contentHeight];
    
    [self.contentView setHeight:CGRectGetMaxY(_viewContent.frame)];
    
    DLog(@"layout height:%f", CGRectGetMaxY(_viewContent.frame));
    //self.viewCellBg.backgroundColor = GGSharedColor.random;
    //_ivContentBg.hidden = YES;
}


+(float)heightWithHeadLine:(NSString *)aHeadLine
{
    if (aHeadLine.length)
    {
        UIFont *font = [UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE size:14.f];
        CGSize constraintSize = CGSizeMake(HEADLINE_WIDTH, FLT_MAX);
        CGSize calculatedSize = [aHeadLine sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByTruncatingTail];
        DLog(@"cal size:%@", NSStringFromCGSize(calculatedSize));
        float height = calculatedSize.height + HEADLINE_Y + CONTENT_BOTTOM_PADDING;
        height = MAX(MIN_CELL_HEIGHT, height);
        
        DLog(@"calc height:%f", height);
        return height;
    }
    
    return 0.f;
}

@end
