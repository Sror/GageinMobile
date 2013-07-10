//
//  GGHappeningIpadCell.m
//  Gagein
//
//  Created by Dong Yiming on 6/15/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGHappeningIpadCell.h"
#import "GGSsgrfPanelBase.h"
#import "GGHappening.h"

#import "GGSsgrfPanelComChart.h"
#import "GGSsgrfPanelDoubleInfo.h"
#import "GGSsgrfPanelDoubleInfoPlus.h"
#import "GGSsgrfPanelTripleInfo.h"
#import "GGSsgrfPanelTripleInfoPlus.h"
#import "GGSsgrfInfoWidgetView.h"
#import "GGUpdateActionBar.h"
#import "GGDataPage.h"

//#define EXPAND_PANEL_OFFSET_X       110

@implementation GGHappeningIpadCell
{
    GGSsgrfPanelHappeningBase           *_panel;
    GGUpdateActionBar                   *_actionBar;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


-(void)awakeFromNib
{
    [self observeNotification:GG_NOTIFY_INFO_WIDGET_SCROLL_TO_END];
    
    _lblHeadline.text = _lblInterval.text = _lblSource.text = @"";
    _ivContentBg.image = GGSharedImagePool.stretchShadowBgWite;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.contentView.autoresizingMask = UIViewAutoresizingNone;
    
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
                    
                    [_panel update];
                }
            }];
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
    [_lblHeadline sizeToFitFixWidth];
    
    //
    CGRect contentRc = _viewContent.frame;
    float contentHeight = _expanded ? CGRectGetMaxY(_actionBar.frame) : CGRectGetMaxY(_lblHeadline.frame) + 5;
    contentHeight = MAX(MIN_CONTENT_HEIGHT, contentHeight);
    contentRc.size.height = contentHeight;
    _viewContent.frame = contentRc;
    
    [_ivContentBg setHeight:contentRc.size.height];
    
    //
    CGRect rc = self.frame;
    rc.size.height = CGRectGetMaxY(_viewContent.frame);
    self.frame = rc;
    
    float arrowAreaHeight = CGRectGetMaxY(_lblHeadline.frame);
    //arrowAreaHeight = MAX(MIN_CONTENT_HEIGHT, arrowAreaHeight);
    float arrowPosY = (arrowAreaHeight - CGRectGetMaxY(_lblInterval.frame) - _ivDblArrow.frame.size.height) / 2 + CGRectGetMaxY(_lblInterval.frame);
    _ivDblArrow.frame = CGRectMake(_ivDblArrow.frame.origin.x, arrowPosY, _ivDblArrow.frame.size.width, _ivDblArrow.frame.size.height);
    
    [self setNeedsLayout];
}

-(void)_doExpand
{
    [self _doExpandNeedDetail:YES];
}

-(void)_doExpandNeedDetail:(BOOL)aNeedDetail
{
    [_panel removeFromSuperview];
    [_actionBar removeFromSuperview];
    
    [self adjustLayout];
    
    _ivDblArrow.image = _expanded ? [UIImage imageNamed:@"dblUpArrow"] : [UIImage imageNamed:@"dblDownArrow"];
    
    if (_expanded)
    {
        _data.hasBeenRead = YES;
        
        float positionX = 2;
        
        _panel = [self panelForHappeningNeedDetail:aNeedDetail];
        float thisH = CGRectGetMaxY(_lblHeadline.frame) + 5;
        [_panel setPos:CGPointMake(positionX, thisH)];
        [self.viewContent addSubview:_panel];
        
        _actionBar = [GGUpdateActionBar viewFromNibWithOwner:self];
        [_actionBar useForHappening];
        [_actionBar.btnShare addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        
        float actionOriginY = CGRectGetMaxY(_panel.frame);
        [_actionBar setPos:CGPointMake(positionX, actionOriginY)];
        //_actionBar.backgroundColor = GGSharedColor.darkRed;
        [self.viewContent addSubview:_actionBar];
        
        NSMutableArray *imageURLs = [NSMutableArray array];
        
#if 0
        for (GGCompany *company in _data.mentionedCompanies)
        {
            [imageURLs addObjectIfNotNil:company.logoPath];
        }
#else
        imageURLs = [NSMutableArray arrayWithObjects:[GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], [GGUtils testImageURL], nil];
#endif
        
        [self adjustLayout];
    }
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
    [self _doExpandNeedDetail:aNeedDetail];
}

-(GGSsgrfPanelHappeningBase *)panelForHappening
{
    return [self panelForHappeningNeedDetail:YES];
}

-(GGSsgrfPanelHappeningBase *)panelForHappeningNeedDetail:(BOOL)aNeedDetail
{
    EGGHappeningType happeningType = _data.type;
    GGSsgrfPanelHappeningBase *panel = nil;
    
    switch (happeningType)
    {
        case kGGHappeningCompanyPersonJion:
        {
            // join or leave, or both
            if ([_data isJoin])
            {
                if (_data.oldCompany.name.length)
                {
                    //triple info
                    GGSsgrfPanelTripleInfo *thePanel = [GGSsgrfPanelTripleInfo viewFromNibWithOwner:self];
                    
                    // set panel
                    panel = thePanel;
                }
                else // no old company
                {
                    //double info
                    GGSsgrfPanelDoubleInfo *thePanel = [GGSsgrfPanelDoubleInfo viewFromNibWithOwner:self];
                    
                    // set panel
                    panel = thePanel;
                }
            }
            else
            {
                //double info
                GGSsgrfPanelDoubleInfo *thePanel = [GGSsgrfPanelDoubleInfo viewFromNibWithOwner:self];
                
                // set panel
                panel = thePanel;
            }
        }
            break;
            
        case kGGHappeningCompanyPersonJionDetail:
        {
            // change job title but not company
            
            //triple info plus
            GGSsgrfPanelTripleInfoPlus *thePanel = [GGSsgrfPanelTripleInfoPlus viewFromNibWithOwner:self];
            
            // set panel
            panel = thePanel;
        }
            break;
            
        case kGGHappeningCompanyRevenueChange:
        {
            // revenue increase or decrease
            
            //double info
            GGSsgrfPanelComChart *thePanel = [GGSsgrfPanelComChart viewFromNibWithOwner:self];
            
            // set panel
            panel = thePanel;
        }
            break;
            
        case kGGHappeningCompanyNewFunding:
        {
            // funding
            //double info
            GGSsgrfPanelDoubleInfo *thePanel = [GGSsgrfPanelDoubleInfo viewFromNibWithOwner:self];
            
            
            // set panel
            panel = thePanel;
        }
            break;
            
        case kGGHappeningCompanyNewLocation:
        {
            // company has a new location
            //double info
            GGSsgrfPanelDoubleInfo *thePanel = [GGSsgrfPanelDoubleInfo viewFromNibWithOwner:self];
            
            // set panel
            panel = thePanel;
        }
            break;
            
        case kGGHappeningCompanyEmloyeeSizeIncrease:
        {
            // employee size increase
            //triple info
            GGSsgrfPanelTripleInfo *thePanel = [GGSsgrfPanelTripleInfo viewFromNibWithOwner:self];
            
            // set panel
            panel = thePanel;
        }
            break;
            
        case kGGHappeningCompanyEmloyeeSizeDecrease: // may be merged with the size increase case...
        {
            // employee size decrease
            //triple info
            GGSsgrfPanelTripleInfo *thePanel = [GGSsgrfPanelTripleInfo viewFromNibWithOwner:self];
            
            // set panel
            panel = thePanel;
        }
            break;

///////////////////////////// person happening //////////////////////////////////////////////////
        case kGGHappeningPersonUpdateProfilePic:
        {
            // person profile changed
            
            GGSsgrfPanelDoubleInfoPlus *thePanel = [GGSsgrfPanelDoubleInfoPlus viewFromNibWithOwner:self];
            
            
            // set panel
            panel = thePanel;
        }
            break;
            
        case kGGHappeningPersonJoinOtherCompany:
        {
            // person join other company
            //triple info
            GGSsgrfPanelTripleInfo *thePanel = [GGSsgrfPanelTripleInfo viewFromNibWithOwner:self];
            
            // set panel
            panel = thePanel;
        }
            break;
            
        case kGGHappeningPersonNewLocation:
        {
            // person has a new location
            //triple info plus
            GGSsgrfPanelTripleInfoPlus *thePanel = [GGSsgrfPanelTripleInfoPlus viewFromNibWithOwner:self];
            
            // set panel
            panel = thePanel;
        }
            break;
            
        case kGGHappeningPersonNewJobTitle: // may be merged with the company join detail case...
        {
            // person has a new job title
            
            if (_data.oldJobTitle.length <= 0)
            {
                //triple info plus
                GGSsgrfPanelDoubleInfoPlus *thePanel = [GGSsgrfPanelDoubleInfoPlus viewFromNibWithOwner:self];
                
                // set panel
                panel = thePanel;
            }
            else
            {
                //triple info plus
                GGSsgrfPanelTripleInfoPlus *thePanel = [GGSsgrfPanelTripleInfoPlus viewFromNibWithOwner:self];
                
                // set panel
                panel = thePanel;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    if (aNeedDetail)
    {
        [panel updateWithHappening:_data];
    }
    
    return panel;
}



-(void)shareAction:(id)sender
{
    DLog(@"shareAction");
    [self postNotification:GG_NOTIFY_SSGRF_SHARE withObject:_data];
}

@end
