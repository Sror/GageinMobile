//
//  GGCompanyUpdateIpadCell.m
//  Gagein
//
//  Created by Dong Yiming on 6/4/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGCompanyUpdateIpadCell.h"
#import "GGSsgrfPanelUpdate.h"
#import "GGSsgrfTitledImgScrollView.h"

@implementation GGCompanyUpdateIpadCell
{
    GGSsgrfPanelUpdate *_panel;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)awakeFromNib
{
    _lblDescription.text = _lblHeadline.text = _lblInterval.text = _lblSource.text = @"";
//    _ivContentBg.image = GGSharedImagePool.stretchShadowBgWite;
//    
//    [GGUtils applyLogoStyleToView:_ivLogo];
    _ivContentBg.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)adjustLayout
{
    //[_lblDescription calculateSize];
    
    CGRect rc = self.frame;
    rc.size.height = [self maxHeightForContent] + 10;
    self.frame = rc;
    //[self adjustHeightToFitContent];
}

-(void)setHasBeenRead:(BOOL)hasRead
{
//    if (hasRead)
//    {
//        _lblHeadline.textColor = GGSharedColor.black;
//    }
//    else
//    {
//        _lblHeadline.textColor = GGSharedColor.orangeGageinDark;
//    }
}

-(void)expand:(BOOL)aExpand
{
    _isExpanded = aExpand;
    
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:[GGSsgrfPanelUpdate class]])
        {
            [subView removeFromSuperview];
        }
    }
    //[_panel removeFromSuperview];
    
    [self adjustLayout];
    
    if (aExpand)
    {
        _panel = [GGSsgrfPanelUpdate viewFromNibWithOwner:self];
        float thisH = self.frame.size.height;
        [_panel setPos:CGPointMake(110, thisH)];
        [self addSubview:_panel];
        
        UIImage *placeholder = [UIImage imageNamed:@"picSample.jpg"];
        NSArray * imageURLs = [NSArray arrayWithObjects:TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, nil];
        
        [_panel.viewScroll setImageUrls:imageURLs placeholder:placeholder];
        
        [self adjustLayout];
    }
}

@end
