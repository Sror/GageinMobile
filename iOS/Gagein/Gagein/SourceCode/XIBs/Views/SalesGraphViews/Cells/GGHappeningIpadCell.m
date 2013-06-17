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

//#define EXPAND_PANEL_OFFSET_X       110

@implementation GGHappeningIpadCell
{
    GGSsgrfPanelHappeningBase        *_panel;
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
    _lblHeadline.text = _lblInterval.text = _lblSource.text = @"";
    _ivContentBg.image = GGSharedImagePool.stretchShadowBgWite;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [GGUtils applyLogoStyleToView:_ivLogo];
}

-(void)adjustLayout
{
    CGRect rc = self.frame;
    rc.size.height = [self maxHeightForContent] + 10;
    self.frame = rc;
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

-(GGSsgrfPanelHappeningBase *)panelForHappening
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
            //triple info plus
            GGSsgrfPanelTripleInfoPlus *thePanel = [GGSsgrfPanelTripleInfoPlus viewFromNibWithOwner:self];
            
            // set panel
            panel = thePanel;
        }
            break;
            
        default:
            break;
    }
    
    [panel updateWithHappening:_data];
    return panel;
}

-(void)_doExpand
{
    [_panel removeFromSuperview];
    //[_actionBar removeFromSuperview];
    
    [self adjustLayout];
    
    _ivDblArrow.image = _expanded ? [UIImage imageNamed:@"dblUpArrow"] : [UIImage imageNamed:@"dblDownArrow"];
    
    if (_expanded)
    {
        float positionX = self.viewContent.frame.origin.x + 2;
        
        _panel = [self panelForHappening];
        float thisH = self.frame.size.height;
        [_panel setPos:CGPointMake(positionX, thisH)];
        [self addSubview:_panel];
        
//        _actionBar = [GGUpdateActionBar viewFromNibWithOwner:self];
//        float actionOriginY = CGRectGetMaxY(_panel.frame);
//        [_actionBar setPos:CGPointMake(EXPAND_PANEL_OFFSET_X, actionOriginY)];
//        [self addSubview:_actionBar];
        
        NSMutableArray *imageURLs = [NSMutableArray array];
        
#if 0
        for (GGCompany *company in _data.mentionedCompanies)
        {
            [imageURLs addObjectIfNotNil:company.logoPath];
        }
#else
        imageURLs = [NSMutableArray arrayWithObjects:TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, nil];
#endif
        
        
        //[_panel.viewScroll setImageUrls:imageURLs placeholder:GGSharedImagePool.logoDefaultCompany];
        
        [self adjustLayout];
    }
}



@end
