//
//  GGComOverviewAboutCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGComOverviewAboutCell.h"

@interface GGComOverviewAboutCell ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
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
}

//+(float)HEIGHT
//{
//    return 200;
//}

-(float)height
{
    float contentHeight = self.textView.contentSize.height;
    return contentHeight + 20;
}

-(void)setTextViewText:(NSString *)aText
{
    _textView.text = aText;
    
    if (ISIPADDEVICE && aText.length)
    {
        CGSize tightContentSize = [aText sizeWithFont:_textView.font constrainedToSize:CGSizeMake(_textView.bounds.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        
        // i Dont know why, but for ipad need to devide by 2...Daniel Dong
        tightContentSize.height /= 2;
        tightContentSize.height = MAX(tightContentSize.height, 40);
        
        [_textView setContentSize:tightContentSize];
    }
}


//-(void)adjustLayout
//{
//    float height = self.textView.contentSize.height;
//    DLog(@"%f", height);
////    self.textView.frame = [GGUtils setH:height rect:self.textView.frame];
////    self.viewContent.frame = CGRectMake(self.viewContent.frame.origin.x, self.viewContent.frame.origin.y, self.textView.frame.size.width, self.textView.frame.size.height);
//    self.frame = CGRectMake(0, 0, 320, [self height] + 20);
//}

@end
