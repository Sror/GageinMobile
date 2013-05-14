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

    UITapGestureRecognizer  *_tapGest;
    
    UIPanGestureRecognizer  *_panGest;
    
    float                    _firstX;
    float                    _firstY;

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
    
    
    _tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cover)];
    
    _panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanSwipe:)];
    _panGest.maximumNumberOfTouches = 1;
    _panGest.minimumNumberOfTouches = 1;

    _panGest.delegate = self;

}



#pragma mark - 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return _canBeDragged;
}


#define SWIPE_UP_THRESHOLD -1000.0f
#define SWIPE_DOWN_THRESHOLD 1000.0f
#define SWIPE_LEFT_THRESHOLD -1000.0f
#define SWIPE_RIGHT_THRESHOLD 1000.0f

- (void)handlePanSwipe:(UIPanGestureRecognizer*)recognizer
{
    // Get the translation in the view
    CGPoint translatedPoint = [recognizer translationInView:recognizer.view];
    //[recognizer setTranslation:CGPointZero inView:recognizer.view];
    
    if (_panGest.state == UIGestureRecognizerStateBegan)
    {
        _firstX = _panGest.view.center.x;
        _firstY = _panGest.view.center.y;
        
        [self postNotification:GG_NOTIFY_PAN_BEGIN];
        //_panGest.view.userInteractionEnabled = NO;
    }
    else if (_panGest.state == UIGestureRecognizerStateChanged)
    {
        translatedPoint = CGPointMake(_firstX + translatedPoint.x, _firstY);
        if (translatedPoint.x < _panGest.view.frame.size.width / 2)
        {
            translatedPoint.x = _panGest.view.frame.size.width / 2;
        }
        
        [UIView animateWithDuration:.3f animations:^{
            _panGest.view.center = translatedPoint;
        }];
    }
    
    else
    
    // But also, detect the swipe gesture
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self postNotification:GG_NOTIFY_PAN_END];
        //_panGest.view.userInteractionEnabled = YES;
        CGPoint vel = [recognizer velocityInView:recognizer.view];
        
        if (vel.x < SWIPE_LEFT_THRESHOLD)
        {
            DLog(@"Detected a swipe to the left");
            [self cover];
        }
        else if (vel.x > SWIPE_RIGHT_THRESHOLD)
        {
            DLog(@"Detected a swipe to the right");
            [self reveal];
        }
//        else if (vel.y < SWIPE_UP_THRESHOLD)
//        {
//            // TODO: Detected a swipe up
//        }
//        else if (vel.y > SWIPE_DOWN_THRESHOLD)
//        {
//            // TODO: Detected a swipe down
//        }
        else
        {
            DLog(@"Detected a pan end");
            if (_panGest.view.center.x < (_viewCover.frame.size.width + SLIDE_SETTING_VIEW_WIDTH) / 2)
            {
                [self cover:nil];
            }
            else
            {
                [self reveal:nil];
            }
        }
    }
}

//-(void)pan:(UIPanGestureRecognizer *)sender
//{
////#warning NOT FINISHED PAN GESTURE
//
//    
//    CGPoint translatedPoint = [_panGest translationInView:_viewCover];
//    
//    if (_panGest.state == UIGestureRecognizerStateBegan)
//    {
//        _firstX = _panGest.view.center.x;
//        _firstY = _panGest.view.center.y;
//        _panGest.view.userInteractionEnabled = NO;
//    }
//    else if (_panGest.state == UIGestureRecognizerStateChanged)
//    {
//        translatedPoint = CGPointMake(_firstX + translatedPoint.x, _firstY);
//        if (translatedPoint.x < _panGest.view.frame.size.width / 2)
//        {
//            translatedPoint.x = _panGest.view.frame.size.width / 2;
//        }
//        
//        [UIView animateWithDuration:.3f animations:^{
//            _panGest.view.center = translatedPoint;
//        }];
//    }
//    
//    else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
//    {
//        _panGest.view.userInteractionEnabled = NO;
//        if (_panGest.view.center.x < (_viewCover.frame.size.width + SLIDE_SETTING_VIEW_WIDTH) / 2)
//        {
//            [self cover:nil];
//        }
//        else
//        {
//            [self reveal:nil];
//        }
//
//    }
//    
//}

- (void)viewDidUnload {
    [self setViewBack:nil];
    [self setViewCover:nil];
    [super viewDidUnload];
}

-(void)enableSwipGesture:(BOOL)anEnabled
{
    //[self.view removeGestureRecognizer:_revealGest];
    //[self.view removeGestureRecognizer:_coverGest];
    [_viewCover removeGestureRecognizer:_panGest];
    
    if (anEnabled)
    {
        //[self.view addGestureRecognizer:_revealGest];
        //[self.view addGestureRecognizer:_coverGest];
        [_viewCover addGestureRecognizer:_panGest];
    }
}

-(void)enableTapGesture:(BOOL)anEnabled
{
    [_viewCover removeGestureRecognizer:_tapGest];
    
    if (anEnabled)
    {
        [_viewCover addGestureRecognizer:_tapGest];
    }
}

-(void)reveal
{
    [self reveal:nil];
    
//    if (_isSwipping)
//    {
//        [self performSelector:@selector(_revalOrCover:) withObject:__BOOL(YES) afterDelay:0];
//        //[self reveal:nil];
//    }
}

- (void)cover
{
    [self cover:nil];
//    if (_isSwipping)
//    {
//        [self performSelector:@selector(_revalOrCover:) withObject:__BOOL(NO) afterDelay:0];
//    }
}

//-(void)_revalOrCover:(id)aBoolObj
//{
//    if (_isPanning)
//    {
//        return;
//    }
//    
//    DLog(@"swipped");
//    
//    BOOL reval = [aBoolObj boolValue];
//    if (reval)
//    {
//        [self reveal:nil];
//    }
//    else
//    {
//        [self cover:nil];
//    }
//}

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
                             
                             [self enableTapGesture:YES];
                             [self postNotification:GG_NOTIFY_MENU_REVEAL];
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
                             
                             [self enableTapGesture:NO];
                             [self postNotification:GG_NOTIFY_MENU_COVER];
                         }
                     }];
}

@end
