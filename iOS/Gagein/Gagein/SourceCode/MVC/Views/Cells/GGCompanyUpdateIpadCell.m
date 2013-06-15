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
#import "GGUpdateActionBar.h"

#import "GGCompanyUpdate.h"
#import "GGCompany.h"

#define EXPAND_PANEL_OFFSET_X       110

@implementation GGCompanyUpdateIpadCell
{
    GGSsgrfPanelUpdate  *_panel;
    GGUpdateActionBar   *_actionBar;
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
    _ivContentBg.image = GGSharedImagePool.stretchShadowBgWite;
    
    [GGUtils applyLogoStyleToView:_ivLogo];
}

-(void)adjustLayout
{
    [_lblDescription calculateSize];
    
    CGRect rc = self.frame;
    rc.size.height = [self maxHeightForContent] + 10;
    self.frame = rc;
    //[self adjustHeightToFitContent];
}

-(void)setHasBeenRead:(BOOL)hasRead
{
    if (hasRead)
    {
        _lblHeadline.textColor = GGSharedColor.black;
    }
    else
    {
        _lblHeadline.textColor = GGSharedColor.orangeGageinDark;
    }
}

-(void)setExpanded:(BOOL)expanded
{
    _expanded = expanded;
    [self _doExpand];
}

-(void)_doExpand
{
//    for (UIView *subView in self.subviews)
//    {
//        if ([subView isKindOfClass:[GGSsgrfPanelUpdate class]])
//        {
//            [subView removeFromSuperview];
//        }
//    }
    [_panel removeFromSuperview];
    [_actionBar removeFromSuperview];
    
    [self adjustLayout];
    
    _ivDblArrow.image = _expanded ? [UIImage imageNamed:@"dblUpArrow"] : [UIImage imageNamed:@"dblDownArrow"];
    
    if (_expanded)
    {
        _panel = [GGSsgrfPanelUpdate viewFromNibWithOwner:self];
        float thisH = self.frame.size.height;
        [_panel setPos:CGPointMake(EXPAND_PANEL_OFFSET_X, thisH)];
        [self addSubview:_panel];
        
        _actionBar = [GGUpdateActionBar viewFromNibWithOwner:self];
        float actionOriginY = CGRectGetMaxY(_panel.frame);
        [_actionBar setPos:CGPointMake(EXPAND_PANEL_OFFSET_X, actionOriginY)];
        [self addSubview:_actionBar];
        
        NSMutableArray *imageURLs = [NSMutableArray array];
        
#if 0
        for (GGCompany *company in _data.mentionedCompanies)
        {
            [imageURLs addObjectIfNotNil:company.logoPath];
        }
#else
        imageURLs = [NSMutableArray arrayWithObjects:TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, nil];
#endif
        
        
        [_panel.viewScroll setImageUrls:imageURLs placeholder:GGSharedImagePool.logoDefaultCompany];
        
        [self adjustLayout];
    }
}

@end
