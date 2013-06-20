//
//  GGSsgrfPopPanelView.m
//  Gagein
//
//  Created by Dong Yiming on 6/18/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGSsgrfPopPanelView.h"
#import "GGSsgrfPopPanelCompany.h"
#import "GGSsgrfPopPanelPerson.h"
#import "GGCompany.h"

#define ANIM_DURATION   .3f

@implementation GGSsgrfPopPanelView
{
    UIView  *_viewBg;
    UIView  *_superview;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _doInit];
    }
    return self;
}

-(id)initWithView:(UIView *)aView
{
    self = [self initWithFrame:aView.bounds];
    if (self)
    {
        _superview = aView;
        [self _doInit];
        [self _doInstallContent];
    }
    
    return self;
}

-(void)dealloc
{
    [self unobserveAllNotifications];
}

-(void)_doInit
{
    [self observeNotification:GG_NOTIFY_ORIENTATION_WILL_CHANGE];
    
    _viewBg = [[UIView alloc] initWithFrame:self.bounds];
    _viewBg.backgroundColor = GGSharedColor.black;
    _viewBg.alpha = 0.6f;
    _viewBg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_viewBg];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapped:)];
    [_viewBg addGestureRecognizer:tapGest];
    
    self.alpha = 0.f;
}

+(void)showInView:(UIView *)aView
{
    if (aView)
    {
        GGSsgrfPopPanelView *instance = [[self alloc] initWithFrame:aView.bounds];
        
        //[instance _doInstallContent];
        
        [instance _doShowInView:aView];
    }
}

-(void)_doInstallContent
{
    
}

-(void)showMe
{
    [self _doShowInView:_superview];
}

-(void)_doShowInView:(UIView *)aView
{
    if (aView)
    {
        self.frame = aView.bounds;
        
        [UIView animateWithDuration:ANIM_DURATION animations:^{
            
            [aView addSubview:self];
            //_viewBg.alpha = .8f;
            self.alpha = 1.f;
            
        } completion:^(BOOL finished) {
            //
        }];
    }
}

-(void)hide
{
    [UIView animateWithDuration:ANIM_DURATION animations:^{
        
        //_viewBg.alpha = .5f;
        self.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

-(void)bgTapped:(id)sender
{
    [self hide];
}

#pragma mark - orientation change
-(void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:GG_NOTIFY_ORIENTATION_WILL_CHANGE])
    {
        UIInterfaceOrientation orient = ((UIInterfaceOrientation)([notification.object intValue]));
        CGRect rc = [GGLayout frameWithOrientation:orient rect:self.superview.bounds];
        rc.size.width += 20.f;
        rc.size.height -= 20.f;
        self.frame = rc;
        self.viewContent.center = self.center;
    }
}

@end


///////////////////
@implementation GGSsgrfPopPanelComInfoView
{
    long long   _companyID;
    GGCompany   *_overview;
}

-(GGSsgrfPopPanelCompany *)panel
{
    return ((GGSsgrfPopPanelCompany *)self.viewContent);
}

-(void)_doInstallContent
{
    GGSsgrfPopPanelCompany *content = [GGSsgrfPopPanelCompany viewFromNibWithOwner:self];
    
    [self.viewContent removeFromSuperview];
    self.viewContent = content;
    self.viewContent.center = self.center;
    [self addSubview:self.viewContent];
    
    [content.btnClose addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}

-(void)updateWithCompanyID:(NSNumber *)aCompanyID
{
    _companyID = [aCompanyID longLongValue];
    self.panel.btnMoreEmployees.tagNumber = aCompanyID;
    
    [self showLoadingHUD];
    
    [GGSharedAPI getCompanyOverviewWithID:_companyID needSocialProfile:YES callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        _overview = [parser parseGetCompanyOverview];
        [self _doUpdate];
    }];
}

-(void)_doUpdate
{
    [self.panel.btnLogo setBackgroundImageWithURL:[NSURL URLWithString:_overview.logoPath] forState:UIControlStateNormal placeholderImage:GGSharedImagePool.logoDefaultCompany];
}

@end


///////////////////
@implementation GGSsgrfPopPanelPersonInfoView

-(GGSsgrfPopPanelPerson *)panel
{
    return ((GGSsgrfPopPanelPerson *)self.viewContent);
}

-(void)_doInstallContent
{
    GGSsgrfPopPanelPerson *content = [GGSsgrfPopPanelPerson viewFromNibWithOwner:self];
    
    [self.viewContent removeFromSuperview];
    self.viewContent = content;
    self.viewContent.center = self.center;
    [self addSubview:self.viewContent];
    
    [content.btnClose addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}

-(void)updateWithPersonID:(NSNumber *)aPersonID
{
    self.panel.btnLogo.tagNumber = aPersonID;
    self.panel.btnMoreEmployers.tagNumber = aPersonID;
}

@end
