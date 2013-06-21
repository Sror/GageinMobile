//
//  GGSsgrfPopPanelView.m
//  Gagein
//
//  Created by Dong Yiming on 6/18/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGSsgrfPopPanelView.h"





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
    _viewBg.alpha = 0.4f;
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
        [self handleOrientChange:orient];
    }
}

-(void)handleOrientChange:(UIInterfaceOrientation)aOrient
{
    
    CGRect rc = [GGLayout frameWithOrientation:aOrient rect:self.superview.bounds];
    rc.size.width += 20.f;
    rc.size.height -= 20.f;
    self.frame = rc;
    self.viewContent.center = self.center;
}


@end



///////////////////




