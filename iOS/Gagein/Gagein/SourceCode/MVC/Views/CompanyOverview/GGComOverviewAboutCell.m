//
//  GGComOverviewAboutCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGComOverviewAboutCell.h"

@interface GGComOverviewAboutCell ()

@end

@implementation GGComOverviewAboutCell

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
    self.ivCellBg.image = GGSharedImagePool.stretchShadowBgWite;
    [_lblContent setWidth:[GGComOverviewAboutCell _labelWidth]];
}

//+(float)HEIGHT
//{
//    return 200;
//}

-(float)height
{
    return self.frame.size.height;
//    float contentHeight = self.textView.contentSize.height;
//    return contentHeight + 20;
}

#define CONTENT_MARGIN_X        (10.f)
#define CONTENT_MARGIN_Y        (5.f)
#define CONTENT_PADDING_Y       (10.f)
#define LABEL_MARGIN_X          (15.f)
#define LABEL_MARGIN_Y          (10.f)

+(float)_labelWidth
{
    float cellWidth = ISIPADDEVICE ? IPAD_CONTENT_WIDTH : 320;
    return cellWidth - (LABEL_MARGIN_X + CONTENT_MARGIN_X) * 2;
}

-(void)setTextViewText:(NSString *)aText
{
    _lblContent.text = aText;
    //_lblContent.backgroundColor = GGSharedColor.random;
    [_lblContent sizeToFitFixWidth];
    
    [_viewContent setHeight:CGRectGetMaxY(_lblContent.frame) + CONTENT_PADDING_Y];
    
    [self setHeight:CGRectGetMaxY(_viewContent.frame) + CONTENT_MARGIN_Y];
}

+(float)heightWithContent:(NSString *)aContent
{
    if (aContent.length)
    {
        UIFont *font = [UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE_LIGHT size:14.f];
        CGSize constraintSize = [aContent sizeWithFont:font constrainedToSize:CGSizeMake([self _labelWidth], FLT_MAX) lineBreakMode:UILineBreakModeTailTruncation];
        
        return constraintSize.height + (CONTENT_MARGIN_Y + LABEL_MARGIN_Y) * 2;
    }
    
    return 0.f;
}

@end
