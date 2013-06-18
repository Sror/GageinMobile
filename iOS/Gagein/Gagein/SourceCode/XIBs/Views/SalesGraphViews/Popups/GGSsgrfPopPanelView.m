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

#define ANIM_DURATION   .3f

@implementation GGSsgrfPopPanelView
{
    UIView  *_viewBg;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _doInit];
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
    _viewBg.alpha = 0.7f;
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
        
        [instance _doInstallContent];
        
        [instance _doShowInView:aView];
    }
}

-(void)_doInstallContent
{
    
}

-(void)_doShowInView:(UIView *)aView
{
    if (aView)
    {
        [UIView animateWithDuration:ANIM_DURATION animations:^{
            
            [aView addSubview:self];
            //_viewBg.alpha = .8f;
            self.alpha = 1.f;
            
        } completion:^(BOOL finished) {
            //
        }];
    }
}

-(void)_doHide
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
    [self _doHide];
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

-(void)_doInstallContent
{
    self.viewContent = [GGSsgrfPopPanelCompany viewFromNibWithOwner:self];
    self.viewContent.center = self.center;
    [self addSubview:self.viewContent];
}

@end


///////////////////
@implementation GGSsgrfPopPanelPersonInfoView

-(void)_doInstallContent
{
    self.viewContent = [GGSsgrfPopPanelPerson viewFromNibWithOwner:self];
    self.viewContent.center = self.center;
    [self addSubview:self.viewContent];
}

@end
