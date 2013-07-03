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
#import "GGDataPage.h"

#define SALES_GRAPH_API_READY       0

@implementation GGCompanyUpdateIpadCell
{
    GGSsgrfPanelUpdate  *_panel;
    GGUpdateActionBar   *_actionBar;
    
    GGCompanyUpdate     *_detailData;
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
    [self observeNotification:GG_NOTIFY_INFO_WIDGET_SCROLL_TO_END];
    
    _lblDescription.text = _lblHeadline.text = _lblInterval.text = _lblSource.text = @"";
    _ivContentBg.image = GGSharedImagePool.stretchShadowBgWite;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_ivLogo applyEffectShadowAndBorder];
}

-(void)handleNotification:(NSNotification *)notification
{
    id loadResponder = [notification.object objectForKey:@"responder"];
    GGCompanyDigest *company = [notification.object objectForKey:@"company"];
    if ([notification.name isEqualToString:GG_NOTIFY_INFO_WIDGET_SCROLL_TO_END] && loadResponder == self)
    {
        //DLog(@"load more competitors");
        [self loadMoreCompetitorsForCompany:company];
    }
}

-(void)loadMoreCompetitorsForCompany:(GGCompanyDigest *)aCompany
{    
    if (aCompany)
    {
        int index = [_detailData.mentionedCompanies indexOfObject:aCompany];
        if (index != NSNotFound)
        {
            GGDataPage *competitorsPage = aCompany.competitors;
            if (competitorsPage && competitorsPage.hasMore)
            {
                int pageIndex = competitorsPage.pageIndex + 1;
                
                [self.viewContent showLoadingHUD];
                [GGSharedAPI getSimilarCompaniesWithOrgID:aCompany.ID pageNumber:pageIndex callback:^(id operation, id aResultObject, NSError *anError) {
                    [self.viewContent hideLoadingHUD];
                    
                    GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                    if (parser.isOK)
                    {
                        GGDataPage *newPage = [parser parseGetSimilarCompanies];
                        NSMutableArray *totalCompetitors = [NSMutableArray arrayWithArray:aCompany.competitors.items];
                        [totalCompetitors addObjectsFromArray:newPage.items];
                        
                        competitorsPage.items = totalCompetitors;
                        competitorsPage.pageIndex = pageIndex;
                        competitorsPage.hasMore = newPage.hasMore;
                        aCompany.competitors = competitorsPage;
                        
                        [self doUpdateUI];
                    }
                }];
            }
        }
    }
}

-(void)dealloc
{
    [self unobserveAllNotifications];
}

#define MIN_CONTENT_HEIGHT      (80.f)
-(void)adjustLayout
{
    //[_lblDescription sizeToFitFixWidth];
    [_lblHeadline sizeToFitFixWidth];
    //_lblHeadline.backgroundColor = GGSharedColor.random;
    //_btnHeadline.backgroundColor = GGSharedColor.random;
    _btnHeadline.alpha = .5f;
    //_btnHeadline.frame = _lblHeadline.frame;
    
    CGRect contentRc = _viewContent.frame;
    float contentHeight = _expanded ? CGRectGetMaxY(_actionBar.frame) : CGRectGetMaxY(_lblHeadline.frame) + 5;
    contentHeight = MAX(MIN_CONTENT_HEIGHT, contentHeight);
    contentRc.size.height = contentHeight;
    _viewContent.frame = contentRc;
    
    [_ivContentBg setHeight:contentRc.size.height];
    
    CGRect rc = self.frame;
    rc.size.height = CGRectGetMaxY(_viewContent.frame);//[self maxHeightForContent] + 10;
    self.frame = rc;
    
    float arrowAreaHeight = CGRectGetMaxY(_lblHeadline.frame);
    //arrowAreaHeight = MAX(MIN_CONTENT_HEIGHT, arrowAreaHeight);
    float arrowPosY = (arrowAreaHeight - CGRectGetMaxY(_lblInterval.frame) - _ivDblArrow.frame.size.height) / 2 + CGRectGetMaxY(_lblInterval.frame);
    _ivDblArrow.frame = CGRectMake(_ivDblArrow.frame.origin.x, arrowPosY, _ivDblArrow.frame.size.width, _ivDblArrow.frame.size.height);
    
    [self setNeedsDisplay];
}

-(void)setHasBeenRead:(BOOL)hasRead
{
    if (hasRead)
    {
        _lblHeadline.textColor = GGSharedColor.gray;
    }
    else
    {
        _lblHeadline.textColor = GGSharedColor.black;
    }
}

-(void)setExpanded:(BOOL)expanded
{
    [self setExpanded:expanded needDetail:YES];
}

-(void)setExpanded:(BOOL)expanded needDetail:(BOOL)aNeedDetail
{
    _expanded = expanded;
    [self _doExpandNeedGetDetail:aNeedDetail];
}

-(void)updateWithData:(GGCompanyUpdate *)aData
{
    _data = aData;
    [self doUpdateUI];
}

-(void)_getDetail
{
    if (_data.ID)
    {
        GGCompanyUpdate *cachedUpdateDetail = [GGSharedRuntimeData.updateDetailCache updateWithID:_data.ID];
        if (cachedUpdateDetail == nil)
        {
            [self.viewContent showLoadingHUD];
            [GGSharedAPI getCompanyUpdateDetailWithNewsID:_data.ID callback:^(id operation, id aResultObject, NSError *anError) {
                [self.viewContent hideLoadingHUD];
                GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                if (parser.isOK)
                {
                    _detailData = [parser parseGetCompanyUpdateDetail];
                    _panel.data = _detailData;
                    _data.hasBeenRead = _detailData.hasBeenRead = YES;
                    [GGSharedRuntimeData.updateDetailCache add:_detailData];
                    
                    [self doUpdateUI];
                }
                
            }];
        }
        else
        {
            _detailData = cachedUpdateDetail;
            _panel.data = _detailData;
            [self doUpdateUI];
        }
    }
}

-(void)doUpdateUI
{
    if (_data)
    {
        self.lblHeadline.text = _data.headline;//[aData headlineTruncated];
        self.lblSource.text = _data.fromSource;
        self.lblDescription.text = _data.content;
        
        //self.ivLogo.hidden = (_data.newsPicURL.length == 0);
        //if (!self.ivLogo.hidden)
        {
            [self.ivLogo setImageWithURL:[NSURL URLWithString:_data.newsPicURL/*aData.company.logoPath*/] placeholderImage:GGSharedImagePool.logoDefaultNews];
        }
        
        
        self.lblInterval.text = [_data intervalStringWithDate:_data.date];
        self.hasBeenRead = _data.hasBeenRead;
        
        if (_expanded)
        {
            NSMutableArray *imageURLs = [NSMutableArray array];
            
//#if 1
            for (GGCompany *company in _detailData.mentionedCompanies)
            {
                [imageURLs addObjectIfNotNil:company.logoPath];
            }
//#else
//            imageURLs = [NSMutableArray arrayWithObjects:[GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], nil];
//#endif
            [_panel.viewScroll setImageUrls:imageURLs placeholder:GGSharedImagePool.logoDefaultCompany];
        }
    }
}

-(void)_doExpand
{
    [self _doExpandNeedGetDetail:YES];
}

-(void)_doExpandNeedGetDetail:(BOOL)aNeedGetDetail
{
    [_panel removeFromSuperview];
    [_actionBar removeFromSuperview];
    
    [self adjustLayout];
    
    _ivDblArrow.image = _expanded ? [UIImage imageNamed:@"dblUpArrow"] : [UIImage imageNamed:@"dblDownArrow"];
    
    if (_expanded)
    {
        float positionX = 2;//self.viewContent.frame.origin.x + 2;
        _panel = [GGSsgrfPanelUpdate viewFromNibWithOwner:self];
        _panel.data = _detailData;
        [_panel setLoadingResponder:self];
        
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
        [self _updateLikedButton];
        
        [_panel.viewScroll setTaget:self action:@selector(popupCompanyInfo:)];
        
        [self adjustLayout];
        
        if (aNeedGetDetail)
        {
            [self _getDetail];
        }
    }
}

#pragma mark - actions
-(void)popupCompanyInfo:(id)sender
{
    UIButton *btn = sender;
    DLog(@"pop company index:%d", btn.tag);
    
//#if 1
    GGCompany *company = _detailData.mentionedCompanies[btn.tag];
    [_panel.viewScroll.infoWidget updateWithCompany:company];
//#else
//    GGCompany *fakeCom = [GGCompany model];
//    fakeCom.name = @"Apple Inc.";
//    fakeCom.logoPath = [GGUtils testImageURL];
//    
//    GGDataPage  *competitorPage = [[GGDataPage alloc] init];
//    NSMutableArray *competitors = [NSMutableArray array];
//    for (int i = 0; i < 10; i++)
//    {
//        GGCompany *competitor = [GGCompany model];
//        competitor.name = @"Google Inc.";
//        competitor.logoPath = [GGUtils testImageURL];
//        [competitors addObject:competitor];
//    }
//    competitorPage.items = competitors;
//    fakeCom.competitors = competitorPage;
//    
//    //GGCompanyDigest *happeningCom = [GGCompanyDigest instanceFromCompany:fakeCom];
//    [_panel.viewScroll.infoWidget updateWithCompany:fakeCom];
//#endif
}

-(void)_updateLikedButton
{
    [_actionBar.btnLike setImage:(_data.liked ? [UIImage imageNamed:@"btnLiked"] : [UIImage imageNamed:@"btnLike"]) forState:UIControlStateNormal];
}

-(void)signalAction:(id)sender
{
    DLog(@"signalAction");
    [self postNotification:GG_NOTIFY_SSGRF_SIGNAL withObject:_detailData];
}

-(void)likeAction:(id)sender
{
    if (_detailData.liked)
    {
        [GGSharedAPI unlikeUpdateWithID:_detailData.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _data.liked = _detailData.liked = NO;
                [self _updateLikedButton];
            }
        }];
    }
    else
    {
        [GGSharedAPI likeUpdateWithID:_detailData.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _data.liked = _detailData.liked = YES;
                [self _updateLikedButton];
                [GGAlert showCheckMarkHUDWithText:@"liked" inView:self.viewContent];
            }
        }];
    }
}

-(void)_updateSaveBtnSaved:(BOOL)aSaved
{
    [_actionBar.btnSave setImage:(aSaved ? [UIImage imageNamed:@"btnSaved"] : [UIImage imageNamed:@"btnSave"]) forState:UIControlStateNormal];
}

-(void)saveAction:(id)sender
{
    DLog(@"saveAction");
    
    if (_data.saved)
    {
        [GGSharedAPI unsaveUpdateWithID:_data.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _data.saved = NO;
                [self _updateSaveBtnSaved:NO];
            }
            else
            {
                [GGAlert alertWithApiParser:parser];
            }
        }];
    }
    else
    {
        [GGSharedAPI saveUpdateWithID:_data.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _data.saved = YES;
                //[GGAlert alert:@"saved!"];
                
                [GGAlert showCheckMarkHUDWithText:@"Saved" inView:self];
                
                [self _updateSaveBtnSaved:YES];
            }
            else
            {
                [GGAlert alertWithApiParser:parser];
            }
        }];
    }
}

-(void)shareAction:(id)sender
{
    DLog(@"shareAction");
    [self postNotification:GG_NOTIFY_SSGRF_SHARE withObject:_detailData];
}

@end
