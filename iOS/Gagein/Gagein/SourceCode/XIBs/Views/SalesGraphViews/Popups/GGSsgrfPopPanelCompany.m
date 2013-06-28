//
//  GGSsgrfPopPanelCompany.m
//  TestPanel
//
//  Created by Dong Yiming on 6/17/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfPopPanelCompany.h"
#import "GGSocialProfile.h"
#import "GGCompany.h"
#import "GGDataPage.h"

#define SOURCE_BTN_WIDTH    25
#define SOURCE_BTN_HEIGHT    25
#define SOURCE_BTN_GAP      15

@implementation GGSsgrfPopPanelCompany
{
    NSArray                 *_sourceButtons;
    NSMutableArray          *_sourceVisibleButtons;
    CGPoint                 _sourceBtnStartPt;
    GGCompany               *_data;
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
    self.layer.shadowOpacity = .9f;
    self.layer.shadowOffset = CGSizeMake(3.f, 3.f);
    self.layer.shadowRadius = 6.f;
    
    _lblTitle.text = _lblSubTitle.text
    = _lblEmp1Title.text = _lblEmp1SubTitle.text
    = _lblEmp2Title.text = _lblEmp2SubTitle.text
    = _lblEmp3Title.text = _lblEmp3SubTitle.text
    = _lblOwnership.text = _lblEmployees.text
    = _lblRevenue.text = _lblFortuneRank.text
    = _lblFiscalYear.text = _lblEmail.text
    = _lblPhone.text = _lblFax.text = _lblAddress.text = @"";
    
    
    
    //
    [_btnLogo addTarget:self action:@selector(enterCompanyDetail:) forControlEvents:UIControlEventTouchUpInside];
    [_lblTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterCompanyDetail:)]];
    [_lblSubTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showWebSite:)]];
    
    [_btnMoreEmployees addTarget:self action:@selector(showMoreEmployeesAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _sourceButtons = [NSArray arrayWithObjects:_btnFacebook, _btnLinkedIn, _btnTwitter, _btnYoutube, _btnSlideShare, _btnHoover, _btnYahoo, _btnCB, nil];
    for (UIButton *btn in _sourceButtons)
    {
        [btn addTarget:self action:@selector(showWebPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    _sourceBtnStartPt = _btnLinkedIn.frame.origin;
    _sourceVisibleButtons = [NSMutableArray arrayWithCapacity:8];
    
    //
    [_viewEmployee1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterPeopleDetail:)]];
    [_viewEmployee2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterPeopleDetail:)]];
    [_viewEmployee3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterPeopleDetail:)]];
    
    // footer
    [_btnFollow addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnLinkedInFooter addTarget:self action:@selector(showWebPage:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)updateWithCompany:(GGCompany *)aCompany
{
    _data = aCompany;
    if (_data)
    {
        
        [_btnLogo setBackgroundImageWithURL:[NSURL URLWithString:_data.logoPath] forState:UIControlStateNormal placeholderImage:GGSharedImagePool.logoDefaultCompany];
        _lblTitle.text = _data.name;
        _lblSubTitle.text = _data.website;
        
        for (GGSocialProfile *socialProfile in _data.socialProfiles)
        {
            //DLog(@"%@", socialProfile.type);
            [self showSourceButtonWithProfile:socialProfile];
        }
        
#warning NEEDED: API to return the employees data
        DLog(@"%@", aCompany.emplorees.items);
        
        //
        _lblOwnership.text = _data.ownership;
        _lblEmployees.text = _data.employeeSize;
        _lblRevenue.text = _data.revenueSize;
        _lblFortuneRank.text = _data.fortuneRank;
        _lblFiscalYear.text = _data.fiscalYear;
        _lblEmail.text = _data.orgEmail;              // no email
        _lblPhone.text = _data.telephone;
        _lblFax.text = _data.faxNumber;
        _lblAddress.text = _data.address;
        
        //
        [self updateFollowButton];
        
        //
        _btnLinkedInFooter.data = _data.linkedInSearchUrl;
    }
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
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_EMPLOYEE_LIST_PAGE withObject:@(_data.ID)];
}

-(void)showWebPage:(id)sender
{
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_WEBPAGE withObject:((UIView *)sender).data];
}

-(void)enterCompanyDetail:(id)sender
{
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_COMPANY_LANDING_PAGE withObject:@(_data.ID)];
}

-(void)showWebSite:(id)sender
{
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_WEBPAGE withObject:_data.website];
}

-(void)enterPeopleDetail:(id)sender
{
    UITapGestureRecognizer *gest = sender;
    DLog(@"enterPeopleDetail:%@", gest.view.tagNumber);
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_PERSON_LANDING_PAGE withObject:gest.view.tagNumber];
}

-(void)updateFollowButton
{
    if (_data.followed)
    {
        [_btnFollow setBackgroundImage:[UIImage imageNamed:@"ssgrf_bg_btn_unfollow"] forState:UIControlStateNormal];
        [_btnFollow setTitle:@"- Unfollow" forState:UIControlStateNormal];
    }
    else
    {
        [_btnFollow setBackgroundImage:[UIImage imageNamed:@"ssgrf_bg_btn_follow"] forState:UIControlStateNormal];
        [_btnFollow setTitle:@"+ Follow" forState:UIControlStateNormal];
    }
}

-(void)followAction:(id)sender
{
    if (_data.followed)
    {
        [GGSharedAPI unfollowCompanyWithID:_data.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _data.followed = NO;
                
                [self postNotification:GG_NOTIFY_COMPANY_FOLLOW_CHANGED];
                
                [self updateFollowButton];
            }
        }];
    }
    else
    {
        [GGSharedAPI followCompanyWithID:_data.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _data.followed = YES;
                
                [self postNotification:GG_NOTIFY_COMPANY_FOLLOW_CHANGED];
                
                [self updateFollowButton];
            }
        }];
    }
}

@end
