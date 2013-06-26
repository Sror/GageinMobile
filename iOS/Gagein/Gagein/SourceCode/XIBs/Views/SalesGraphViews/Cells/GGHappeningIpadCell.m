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
    _lblHeadline.text = _lblInterval.text = _lblSource.text = @"";
    _ivContentBg.image = GGSharedImagePool.stretchShadowBgWite;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.contentView.autoresizingMask = UIViewAutoresizingNone;
    
    [GGUtils applyLogoStyleToView:_ivLogo];
}

#define MIN_CONTENT_HEIGHT      (60.f)
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
    
    [self setNeedsLayout];
}

-(void)_doExpand
{
    [_panel removeFromSuperview];
    [_actionBar removeFromSuperview];
    
    [self adjustLayout];
    
    _ivDblArrow.image = _expanded ? [UIImage imageNamed:@"dblUpArrow"] : [UIImage imageNamed:@"dblDownArrow"];
    
    if (_expanded)
    {
        _data.hasBeenRead = YES;
        
        float positionX = 2;
        
        _panel = [self panelForHappening];
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
    
    [panel updateWithHappening:_data];
    return panel;
}



-(void)shareAction:(id)sender
{
    DLog(@"shareAction");
    [self postNotification:GG_NOTIFY_SSGRF_SHARE withObject:_data];
}

@end
