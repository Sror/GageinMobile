//
//  GGRootVC.m
//  Gagein
//
//  Created by dong yiming on 13-5-3.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGRootVC.h"

#import "GGAppDelegate.h"

#define SLIDE_TIMING .25
//#define PANEL_WIDTH 60

@interface GGRootVC ()


@end

@implementation GGRootVC
{
    BOOL    _isRevealed;
    UISwipeGestureRecognizer *_revealGest;
    UISwipeGestureRecognizer *_coverGest;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_viewCover addSubview:GGSharedDelegate.tabBarController.view];
    [self addChildViewController:GGSharedDelegate.tabBarController];
    [GGSharedDelegate.tabBarController didMoveToParentViewController:self];
    
    _viewSetting = [[GGSlideSettingView alloc] initWithFrame:_viewBack.bounds];
    [_viewBack addSubview:_viewSetting];
    
    _revealGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(reveal)];
    _revealGest.direction = UISwipeGestureRecognizerDirectionRight;
    
    _coverGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cover)];
    _coverGest.direction = UISwipeGestureRecognizerDirectionLeft;
}

- (void)viewDidUnload {
    [self setViewBack:nil];
    [self setViewCover:nil];
    [super viewDidUnload];
}

-(void)enableGesture:(BOOL)anEnabled
{
    [_viewCover removeGestureRecognizer:_revealGest];
    [_viewBack removeGestureRecognizer:_coverGest];
    
    if (anEnabled)
    {
        [_viewCover addGestureRecognizer:_revealGest];
        [_viewBack addGestureRecognizer:_coverGest];
    }
}

-(void)reveal
{
    [self reveal:nil];
}

- (void)cover
{
    [self cover:nil];
}

-(void)reveal:(void(^)(void))completion
{
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _viewCover.frame = CGRectMake(SLIDE_SETTING_VIEW_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             _isRevealed = YES;
                             _viewSetting.isShowing = YES;
                             
                             if (completion) {
                                 completion();
                             }
                         }
                     }];
}

- (void)cover:(void(^)(void))completion
{
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _viewCover.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             _isRevealed = NO;
                             _viewSetting.isShowing = NO;
                             
                             if (completion) {
                                 completion();
                             }
                         }
                     }];
}

@end
