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

#import "GGCompanyUpdate.h"
#import "GGCompany.h"

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
    
    [self adjustLayout];
    
    if (_expanded)
    {
        _panel = [GGSsgrfPanelUpdate viewFromNibWithOwner:self];
        float thisH = self.frame.size.height;
        [_panel setPos:CGPointMake(110, thisH)];
        [self addSubview:_panel];
        
        NSMutableArray *imageURLs = [NSMutableArray array];
        for (GGCompany *company in _data.mentionedCompanies)
        {
            [imageURLs addObjectIfNotNil:company.logoPath];
        }
        
        [_panel.viewScroll setImageUrls:imageURLs placeholder:GGSharedImagePool.logoDefaultCompany];
        
        [self adjustLayout];
    }
}

@end
