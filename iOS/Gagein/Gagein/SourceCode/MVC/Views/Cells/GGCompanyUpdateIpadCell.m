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
#import "GGSsgrfInfoWidgetView.h"

#define SALES_GRAPH_API_READY       0

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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [GGUtils applyLogoStyleToView:_ivLogo];
}

#define MIN_CONTENT_HEIGHT      (80.f)
-(void)adjustLayout
{
    [_lblDescription calculateSize];
    
    CGRect contentRc = _viewContent.frame;
    float contentHeight = _expanded ? CGRectGetMaxY(_actionBar.frame) : CGRectGetMaxY(_lblDescription.frame) + 5;
    contentHeight = MAX(MIN_CONTENT_HEIGHT, contentHeight);
    contentRc.size.height = contentHeight;
    _viewContent.frame = contentRc;
    
    [_ivContentBg setHeight:contentRc.size.height];
    
    CGRect rc = self.frame;
    rc.size.height = CGRectGetMaxY(_viewContent.frame);//[self maxHeightForContent] + 10;
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
    [_panel removeFromSuperview];
    [_actionBar removeFromSuperview];
    
    [self adjustLayout];
    
    _ivDblArrow.image = _expanded ? [UIImage imageNamed:@"dblUpArrow"] : [UIImage imageNamed:@"dblDownArrow"];
    
    if (_expanded)
    {
        float positionX = 2;//self.viewContent.frame.origin.x + 2;
        _panel = [GGSsgrfPanelUpdate viewFromNibWithOwner:self];
        float thisH =  CGRectGetMaxY(_lblDescription.frame) + 5;//self.frame.size.height;
        [_panel setPos:CGPointMake(positionX, thisH)];
        [self.viewContent addSubview:_panel];
        
        _actionBar = [GGUpdateActionBar viewFromNibWithOwner:self];
        [_actionBar.btnSignal addTarget:self action:@selector(signalAction:) forControlEvents:UIControlEventTouchUpInside];
        [_actionBar.btnLike addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_actionBar.btnSave addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        [_actionBar.btnShare addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        
        float actionOriginY = CGRectGetMaxY(_panel.frame);
        [_actionBar setPos:CGPointMake(positionX, actionOriginY)];
        //CGRect actionBarRc = _actionBar.frame;
        [self.viewContent addSubview:_actionBar];
        
        NSMutableArray *imageURLs = [NSMutableArray array];
        
#if SALES_GRAPH_API_READY
        for (GGCompany *company in _data.mentionedCompanies)
        {
            [imageURLs addObjectIfNotNil:company.logoPath];
        }
#else
        imageURLs = [NSMutableArray arrayWithObjects:[GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], nil];
#endif
        [_panel.viewScroll setTaget:self action:@selector(popupCompanyInfo:)];
        
        [_panel.viewScroll setImageUrls:imageURLs placeholder:GGSharedImagePool.logoDefaultCompany];
        
        [self adjustLayout];
    }
}

#pragma mark - actions
-(void)popupCompanyInfo:(id)sender
{
    UIButton *btn = sender;
    DLog(@"pop company index:%d", btn.tag);
    
#if SALES_GRAPH_API_READY
    GGCompany *company = _data.mentionedCompanies[btn.tag];
    [_panel.viewScroll.infoWidget updateWithCompany:company];
#else
    GGCompany *fakeCom = [GGCompany model];
    fakeCom.name = @"Apple Inc.";
    fakeCom.logoPath = [GGUtils testImageURL];
    
    NSMutableArray *competitors = [NSMutableArray array];
    for (int i = 0; i < 10; i++)
    {
        GGCompany *competitor = [GGCompany model];
        competitor.name = @"Google Inc.";
        competitor.logoPath = [GGUtils testImageURL];
        [competitors addObject:competitor];
    }
    fakeCom.competitors = competitors;
    
    //GGCompanyDigest *happeningCom = [GGCompanyDigest instanceFromCompany:fakeCom];
    [_panel.viewScroll.infoWidget updateWithCompany:fakeCom];
#endif
}

-(void)signalAction:(id)sender
{
    DLog(@"signalAction");
}

-(void)likeAction:(id)sender
{
    DLog(@"likeAction");
}

-(void)saveAction:(id)sender
{
    DLog(@"saveAction");
}

-(void)shareAction:(id)sender
{
    DLog(@"shareAction");
}

@end
