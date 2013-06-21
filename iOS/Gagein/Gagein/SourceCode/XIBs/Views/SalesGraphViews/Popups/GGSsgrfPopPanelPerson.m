//
//  GGSsgrfPopPanelPerson.m
//  TestPanel
//
//  Created by Dong Yiming on 6/17/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfPopPanelPerson.h"

#import "GGPerson.h"
#import "GGSocialProfile.h"

#define SOURCE_BTN_WIDTH    25
#define SOURCE_BTN_HEIGHT    25
#define SOURCE_BTN_GAP      15

@implementation GGSsgrfPopPanelPerson
{
    NSArray                 *_sourceButtons;
    NSMutableArray          *_sourceVisibleButtons;
    CGPoint                 _sourceBtnStartPt;
    
    GGPerson        *_data;
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
    
    //
    _lblTitle.text = _lblSubTitle.text
    = _lblEmp1Title.text = _lblEmp1SubTitle.text
    = _lblEmp2Title.text = _lblEmp2SubTitle.text
    = _lblEmp3Title.text = _lblEmp3SubTitle.text
    = _lblOwnership.text = @"";
    
    //
    [_btnLogo addTarget:self action:@selector(enterPersonDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnMoreEmployers addTarget:self action:@selector(showMoreEmployersAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _sourceButtons = [NSArray arrayWithObjects:_btnFacebook, _btnLinkedIn, _btnTwitter, _btnYoutube, _btnSlideShare, _btnHoover, _btnYahoo, _btnCB, nil];
    for (UIButton *btn in _sourceButtons)
    {
        [btn addTarget:self action:@selector(showWebPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    _sourceBtnStartPt = _btnLinkedIn.frame.origin;
    _sourceVisibleButtons = [NSMutableArray arrayWithCapacity:8];
    
    //
    //
    [_viewEmployer1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterCompanyDetail:)]];
    [_viewEmployer2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterCompanyDetail:)]];
    [_viewEmployer3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterCompanyDetail:)]];
    
    //
    [_btnFollow addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)updateWithPerson:(GGPerson *)aPerson
{
    _data = aPerson;
    
    if (_data)
    {
        
        [_btnLogo setBackgroundImageWithURL:[NSURL URLWithString:_data.photoPath] forState:UIControlStateNormal placeholderImage:GGSharedImagePool.logoDefaultPerson];
        _lblTitle.text = _data.name;
        _lblSubTitle.text = _data.orgTitle;
        
        for (GGSocialProfile *socialProfile in _data.socialProfiles)
        {
            //DLog(@"%@", socialProfile.type);
            [self showSourceButtonWithProfile:socialProfile];
        }
        
#warning NEEDED: API to return the employers data
        
        //
        _lblOwnership.text = _data.address;
        
        //
        [self updateFollowButton];
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
-(void)showMoreEmployersAction:(id)sender
{
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_EMPLOYER_LIST_PAGE withObject:@(_data.ID)];
}

-(void)showWebPage:(id)sender
{
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_WEBPAGE withObject:((UIView *)sender).data];
}

-(void)enterPersonDetail:(id)sender
{
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_PERSON_LANDING_PAGE withObject:@(_data.ID)];
}

-(void)enterCompanyDetail:(id)sender
{
    UITapGestureRecognizer *gest = sender;
    DLog(@"enterPeopleDetail:%@", gest.view.tagNumber);
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_COMPANY_LANDING_PAGE withObject:gest.view.tagNumber];
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
        [GGSharedAPI unfollowPersonWithID:_data.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _data.followed = NO;
                [self updateFollowButton];
            }
        }];
    }
    else
    {
        [GGSharedAPI followPersonWithID:_data.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _data.followed = YES;
                [self updateFollowButton];
            }
        }];
    }
}


@end
