//
//  GGSsgrfPopPanelCompany.m
//  TestPanel
//
//  Created by Dong Yiming on 6/17/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfPopPanelCompany.h"
#import "GGSocialProfile.h"

#define SOURCE_BTN_WIDTH    25
#define SOURCE_BTN_HEIGHT    25
#define SOURCE_BTN_GAP      15

@implementation GGSsgrfPopPanelCompany
{
    NSArray                 *_sourceButtons;
    NSMutableArray          *_sourceVisibleButtons;
    CGPoint                 _sourceBtnStartPt;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _doInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _doInit];
    }
    
    return self;
}


-(void)_doInit
{
}

-(void)awakeFromNib
{
    self.layer.cornerRadius = 8.f;
    
    self.viewFooter.layer.cornerRadius = 8.f;
    self.layer.shadowColor = GGSharedColor.black.CGColor;
    self.layer.shadowOpacity = 1.f;
    self.layer.shadowOffset = CGSizeMake(3.f, 3.f);
    self.layer.shadowRadius = 4.f;
    
    _lblTitle.text = _lblSubTitle.text
    = _lblEmp1Title.text = _lblEmp1SubTitle.text
    = _lblEmp2Title.text = _lblEmp2SubTitle.text
    = _lblEmp3Title.text = _lblEmp3SubTitle.text
    = _lblOwnership.text = _lblEmployees.text
    = _lblRevenue.text = _lblFortuneRank.text
    = _lblFiscalYear.text = _lblEmail.text
    = _lblPhone.text = _lblFax.text = _lblAddress.text = @"";
    
    [_btnMoreEmployees addTarget:self action:@selector(showMoreEmployeesAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _sourceButtons = [NSArray arrayWithObjects:_btnFacebook, _btnLinkedIn, _btnTwitter, _btnYoutube, _btnSlideShare, _btnHoover, _btnYahoo, _btnCB, nil];
    for (UIButton *btn in _sourceButtons)
    {
        [btn addTarget:self action:@selector(showWebPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    _sourceBtnStartPt = _btnLinkedIn.frame.origin;
    _sourceVisibleButtons = [NSMutableArray arrayWithCapacity:8];
}

-(void)showSourceButtonWithProfile:(GGSocialProfile *)aSourceProfile
{
    float offsetX = _sourceBtnStartPt.x + _sourceVisibleButtons.count * (SOURCE_BTN_GAP + SOURCE_BTN_WIDTH);
    CGRect btnRc = CGRectMake(offsetX, _sourceBtnStartPt.y, SOURCE_BTN_WIDTH, SOURCE_BTN_HEIGHT);
    UIButton *theBtn = nil;
    
    EGGHappeningSource sourceType = [GGUtils sourceTypeForText:aSourceProfile.type];
    switch (sourceType)
    {
        case kGGHappeningSourceLindedIn:
        {
            theBtn = _btnLinkedIn;
        }
            break;
            
        case kGGHappeningSourceFacebook:
        {
            theBtn = _btnFacebook;
        }
            break;
            
        case kGGHappeningSourceTwitter:
        {
            theBtn = _btnTwitter;
        }
            break;
            
        case kGGHappeningSourceYoutube:
        {
            theBtn = _btnYoutube;
        }
            break;
            
        case kGGHappeningSourceSlideShare:
        {
            theBtn = _btnSlideShare;
        }
            break;
            
        case kGGHappeningSourceHoovers:
        {
            theBtn = _btnHoover;
        }
            break;
            
        case kGGHappeningSourceYahoo:
        {
            theBtn = _btnYahoo;
        }
            break;
            
        case kGGHappeningSourceCrunchBase:
        {
            theBtn = _btnCB;
        }
            break;
            
        default:
            break;
    }
    
    theBtn.frame = btnRc;
    theBtn.hidden = NO;
    theBtn.data = aSourceProfile.url;
    [_sourceVisibleButtons addObject:theBtn];

}

#pragma mark - action
-(void)showMoreEmployeesAction:(id)sender
{
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_EMPLOYEE_LIST_PAGE withObject:((UIView *)sender).tagNumber];
}

-(void)showWebPage:(id)sender
{
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_WEBPAGE withObject:((UIView *)sender).data];
}

@end
