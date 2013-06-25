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
    
//    UISwipeGestureRecognizer *_swipeToLeft;
//    UISwipeGestureRecognizer *_swipeToRight;
    
    float                    _firstX;
    float                    _firstY;

}

#pragma mark -
-(void)setIsRevealed:(BOOL)isRevealed
{
    _isRevealed = isRevealed;
}

#pragma mark -
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
    
    //_viewBack.backgroundColor = [UIColor blueColor];
    //_viewCover.backgroundColor = [UIColor orangeColor];
    
    [_viewCover addSubview:GGSharedDelegate.tabBarController.view];
    [self addChildViewController:GGSharedDelegate.tabBarController];
    [GGSharedDelegate.tabBarController didMoveToParentViewController:self];
    
    //_viewCover.clipsToBounds = YES;
    //_viewCover.layer.cornerRadius = 8.f;
    _viewCover.layer.masksToBounds = NO;
    _viewCover.layer.shadowColor = GGSharedColor.darkGray.CGColor;
    _viewCover.layer.shadowOffset = CGSizeMake(-5, 0);
    _viewCover.layer.shadowOpacity = .6f;
    _viewCover.layer.shadowRadius = 5.f;
    
    if (ISIPADDEVICE)
    {
        _viewCover.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    
    // add setting view to back view
    _viewSetting = [[GGSlideSettingView alloc] initWithFrame:_viewBack.bounds];
    [_viewBack addSubview:_viewSetting];
    
    //
    _tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hadleTap)];
    
    //
    _panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanSwipe:)];
    _panGest.maximumNumberOfTouches = 1;
    _panGest.minimumNumberOfTouches = 1;
    
    //
//    _swipeToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToLeft:)];
//    _swipeToLeft.direction = UISwipeGestureRecognizerDirectionLeft;
//    
//    _swipeToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToRight:)];
//    _swipeToRight.direction = UISwipeGestureRecognizerDirectionRight;

   // _panGest.delegate = _swipeToLeft.delegate = _swipeToRight.delegate = self;
    _panGest.delegate = self;
    
//    [_panGest requireGestureRecognizerToFail:_swipeToRight];
//    [_panGest requireGestureRecognizerToFail:_swipeToLeft];
    
//    [_swipeToRight requireGestureRecognizerToFail:_panGest];
//    [_swipeToLeft requireGestureRecognizerToFail:_panGest];
}



#pragma mark - 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return ![self isIPadLandscape] && _canBeDragged;
}


#define SWIPE_UP_THRESHOLD -1000.0f
#define SWIPE_DOWN_THRESHOLD 1000.0f
#define SWIPE_LEFT_THRESHOLD -1000.0f
#define SWIPE_RIGHT_THRESHOLD 1000.0f

-(void)swipeToLeft:(UISwipeGestureRecognizer *)aSwipeGestureRecognizer
{
    [self cover];
}

-(void)swipeToRight:(UISwipeGestureRecognizer *)aSwipeGestureRecognizer
{
    [self reveal];
}

-(void)hadleTap
{
    if (![self isIPadLandscape])
    {
        [self cover];
    }
}

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
            if (_panGest.view.center.x < (_viewCover.frame.size.width + LEFT_DRAWER_WIDTH) / 2)
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

- (void)viewDidUnload {
    [self setViewBack:nil];
    [self setViewCover:nil];
    [super viewDidUnload];
}

-(void)enableSwipGesture:(BOOL)anEnabled
{
    //[UIView ]
    //[self.view removeGestureRecognizer:_swipeToRight];
    //[self.view removeGestureRecognizer:_swipeToLeft];
    [_viewCover removeGestureRecognizer:_panGest];
    
    if (anEnabled)
    {
//        [self.view addGestureRecognizer:_swipeToLeft];
//        [self.view addGestureRecognizer:_swipeToRight];
        [_viewCover addGestureRecognizer:_panGest];
    }
}

-(void)enableTapGesture:(BOOL)anEnabled
{
    [_viewCover removeGestureRecognizer:_tapGest];
    
    if (anEnabled && ![self isIPadLandscape])
    {
        [_viewCover addGestureRecognizer:_tapGest];
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

-(void)bare
{
    [self bare:nil];
}

-(void)reveal:(void(^)(void))completion
{
    _isRevealed = YES;
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         //CGRect orientRc = [self frameOrientated];
                         CGRect coverRc = CGRectMake(LEFT_DRAWER_WIDTH, 0, _viewCover.frame.size.width, _viewCover.frame.size.height);
                         _viewCover.frame = coverRc;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             
                             //_viewSetting.isShowing = YES;
                             
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
    _isRevealed = NO;
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         //CGRect orientRc = [self frameOrientated];
                         CGRect coverRc = CGRectMake(0, 0, _viewCover.frame.size.width, _viewCover.frame.size.height);
                         _viewCover.frame = coverRc;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             
                             //_viewSetting.isShowing = NO;
                             
                             if (completion) {
                                 completion();
                             }
                             
                             [self enableTapGesture:NO];
                             [self postNotification:GG_NOTIFY_MENU_COVER];
                         }
                     }];
}

- (void)bare:(void(^)(void))completion
{
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGRect orientRc = [self frameOrientated];
                         CGRect coverRc = CGRectMake(orientRc.size.width, 0, _viewCover.frame.size.width, _viewCover.frame.size.height);
                         _viewCover.frame = coverRc;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             if (completion) {
                                 completion();
                             }
                         }
                     }];
}


-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // never call super class's 'doLayoutUIForIPadWithOrientation' method here, or u'll get into trouble. -- Daniel Dong
    
    CGRect coverRc = [GGLayout rootCoverFrameForWithOrient:toInterfaceOrientation];
    _viewCover.frame = CGRectMake(_viewCover.frame.origin.x, _viewCover.frame.origin.y, coverRc.size.width, coverRc.size.height);
    
    [GGSharedDelegate.tabBarController doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
}

-(void)setNeedMenuAndLayout:(BOOL)needMenu orient:(UIInterfaceOrientation)anOrient
{
    _needMenu = needMenu;
    [self doLayoutUIForIPadWithOrientation:anOrient];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self postNotification:GG_NOTIFY_ORIENTATION_WILL_CHANGE withObject:@(toInterfaceOrientation)];
}

@end
