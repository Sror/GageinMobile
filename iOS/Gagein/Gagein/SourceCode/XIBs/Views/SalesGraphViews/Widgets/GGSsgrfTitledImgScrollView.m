//
//  GGSsgrfTitledImgScrollView.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/12/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfTitledImgScrollView.h"
#import "GGSsgrfInfoWidgetView.h"

#import "GGAutosizingLabel.h"
#import "GGSsgrfRndImgButton.h"
#import <QuartzCore/QuartzCore.h>

#import "GGCompanyUpdate.h"

//#define IMAGE_GAP   5

#define IMAGE_SIZE_WIDTH    31
#define IMAGE_SIZE_HEIGHT   31



#define SCROLL_VIEW_CAP_WIDTH   20

//
@implementation GGTouchScrollView

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    _touching = YES;
//    DLog(@"touches began");
//}
//
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesCancelled:touches withEvent:event];
//    _touching = NO;
//    DLog(@"touches cancelled");
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    _touching = NO;
//    DLog(@"touches ended");
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesMoved:touches withEvent:event];
//    DLog(@"touches moved");
//}

@end

//
@implementation GGSsgrfTitledImgScrollView
{
    GGAutosizingLabel           *_lblTitle;
    
    
    UIImage                     *_placeholder;
    NSArray                     *_imageUrls;
    
    id                          _imageBtnTarget;
    SEL                         _imageBtnAction;
}

-(CGSize)imageSize
{
    return CGSizeMake(IMAGE_SIZE_WIDTH, IMAGE_SIZE_HEIGHT);
}

-(void)_doInit
{
    _gap = 5.f;
    
    CGSize thisSize = self.bounds.size;
    _imageButtons = [NSMutableArray array];
    //self.backgroundColor = [UIColor blackColor];
    
    CGRect titleRc = CGRectMake(0, 0, thisSize.width, 30);
    _lblTitle = [[GGAutosizingLabel alloc] initWithFrame:titleRc];
    _lblTitle.font = [UIFont boldSystemFontOfSize:12.f];
    _lblTitle.textColor = [UIColor lightGrayColor];
    _lblTitle.backgroundColor = [UIColor clearColor];
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    _lblTitle.numberOfLines = 0;
    
    [self addSubview:_lblTitle];
    
    //
    CGRect scrollRc = CGRectMake(SCROLL_VIEW_CAP_WIDTH, CGRectGetMaxY(_lblTitle.frame) + 15, thisSize.width - SCROLL_VIEW_CAP_WIDTH * 2, [self scrollViewHeight]);
    _viewScroll = [[GGTouchScrollView alloc] initWithFrame:scrollRc];
    _viewScroll.showsHorizontalScrollIndicator = NO;
    _viewScroll.alwaysBounceHorizontal = YES;
    _viewScroll.delegate = self;
    //_viewScroll.backgroundColor = [UIColor blackColor];
    [self addSubview:_viewScroll];
    
    CGRect thisRc = self.frame;
    thisRc.size.height = CGRectGetMaxY(_viewScroll.frame) + 10;
    self.frame = thisRc;
    
    [self _reinstallImages];
}

-(float)scrollViewHeight
{
    return IMAGE_SIZE_HEIGHT;
}

-(void)setGap:(float)aGap
{
    _gap = aGap;
    [self _reinstallImages];
}

-(void)_reinstallImages
{
//#warning TEST CODE
    for (UIView *sub in _viewScroll.subviews)
    {
        [sub removeFromSuperview];
    }
    [_imageButtons removeAllObjects];
    
    //int offsetX = 0;
    int count = _imageUrls.count;
    for (int i = 0; i < count; i++)
    {
        GGSsgrfRndImgButton *button = [[GGSsgrfRndImgButton alloc] initWithFrame:CGRectMake(0, ([self scrollViewHeight] - [self imageSize].height) / 2, [self imageSize].width, [self imageSize].height)];
        
        button.tag = i;
        
        NSString *urlStr = _imageUrls[i];
        
        [button setImageUrl:urlStr placeholder:_placeholder];
        button.layer.cornerRadius = 4.f;
        
        [button addTarget:_imageBtnTarget action:_imageBtnAction];
        [_viewScroll addSubview:button];
        [_imageButtons addObject:button];
        
        //offsetX = CGRectGetMaxX(button.frame) + _gap;
    }
    
    [self reArrangeImagePos];
     //[self _setContentWidth:offsetX - _gap];
}


-(void)reArrangeImagePos
{
    [self _reArrangeImagePosWithOffsetX:0];
    float contentWidth = _viewScroll.contentSize.width;
    float scrollWidth = _viewScroll.frame.size.width;
    if (contentWidth < scrollWidth)
    {
        float offsetX = (scrollWidth - contentWidth) / 2;
        [self _reArrangeImagePosWithOffsetX:offsetX];
    }
}

-(void)_reArrangeImagePosWithOffsetX:(float)aOffsetX
{
    int count = _imageButtons.count;
    for (int i = 0; i < count; i++)
    {
        GGSsgrfRndImgButton *btn = _imageButtons[i];
        btn.frame = CGRectMake(aOffsetX, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
        aOffsetX = CGRectGetMaxX(btn.frame) + _gap;
    }
    
    [self _setContentWidth:aOffsetX - _gap];
    
}

-(void)_setContentWidth:(float)aWidth
{
    //aWidth = MAX(_viewScroll.frame.size.width, aWidth);
    _viewScroll.contentSize = CGSizeMake(aWidth, [self imageSize].height);
}


-(void)setTitle:(NSString *)aTitle
{
    _lblTitle.text = aTitle;
}

-(void)setTaget:(id)aTarget action:(SEL)aAction
{
    _imageBtnTarget = aTarget;
    _imageBtnAction = aAction;
    
    for (GGSsgrfRndImgButton *button in _imageButtons)
    {
        [button addTarget:aTarget action:aAction];
    }
}

-(void)setImageUrls:(NSArray *)imageUrls placeholder:(UIImage *)aPlaceholder
{
    _imageUrls = imageUrls;
    _placeholder = aPlaceholder;
    
    [self _reinstallImages];
}

#pragma mark -
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    DLog(@"Beign dragging");
//}


@end

//////////////////////// GGSsgrfPushAwayScrollView/////////////////////////
@implementation GGSsgrfPushAwayScrollView
{
    float                       _pushGap;
    
}

-(CGSize)imageSize
{
    return CGSizeMake(50, 50);
}

-(void)_doInit
{
    [super _doInit];
    
    _gap = 35.f;
    _pushGap = 35.f;
    
    _infoWidget = [[GGSsgrfInfoWidgetView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];

    _infoWidget.hidden = YES;
}

-(float)scrollViewHeight
{
    return 250.f;
}

-(void)_reinstallImages
{
    [super _reinstallImages];
    
    for (GGSsgrfRndImgButton *button in _imageButtons)
    {
        [button addTarget:self action:@selector(pushAwayFromButton:)];
    }
    
    int popIndex = 0;//_imageButtons.count / 2;
    
    if (_imageButtons.count > 0)
    {
        [self showInfoWidgetAnimatedWithPushButton:_imageButtons[popIndex]];
        GGCompany *company = self.data.mentionedCompanies[popIndex];
        [_infoWidget updateWithCompany:company];
        [self pushAwayFromIndex:popIndex];
    }
    
}

#define THIS_ANIM_DURATION  .4f

- (void)showInfoWidgetAnimatedWithPushButton:(UIButton *)pushedButton
{
    _infoWidget.hidden = NO;
    _infoWidget.viewTitledScroll.viewScroll.contentOffset = CGPointZero;
    _infoWidget.center = pushedButton.center;
    [self.viewScroll addSubview:_infoWidget];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue = @(1);
    opacityAnimation.duration = THIS_ANIM_DURATION / 2;
    [_infoWidget.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    CAKeyframeAnimation *alertScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D startingScale = CATransform3DScale(_infoWidget.layer.transform, 0, 0, 0);
    CATransform3D overshootScale = CATransform3DScale(_infoWidget.layer.transform, 1.05, 1.05, 1.0);
    CATransform3D undershootScale = CATransform3DScale(_infoWidget.layer.transform, 0.95, 0.95, 1.0);
    CATransform3D endingScale = _infoWidget.layer.transform;
    
    alertScaleAnimation.values = @[
                                   [NSValue valueWithCATransform3D:startingScale],
                                   [NSValue valueWithCATransform3D:overshootScale],
                                   [NSValue valueWithCATransform3D:undershootScale],
                                   [NSValue valueWithCATransform3D:endingScale]
                                   ];
    
    alertScaleAnimation.keyTimes = @[
                                     @(0.0f),
                                     @(0.3f),
                                     @(0.85f),
                                     @(1.0f)
                                     ];
    
    alertScaleAnimation.timingFunctions = @[
                                            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                                            ];
    alertScaleAnimation.fillMode = kCAFillModeForwards;
    alertScaleAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup *alertAnimation = [CAAnimationGroup animation];
    alertAnimation.animations = @[
                                  alertScaleAnimation,
                                  opacityAnimation
                                  ];
    alertAnimation.duration = THIS_ANIM_DURATION;
    [_infoWidget.layer addAnimation:alertAnimation forKey:@"alertAnimation"];
}

-(void)pushAwayFromButton:(UIButton *)aButton
{
    int index = aButton.tag;
    [self pushAwayFromIndex:index];
}

-(void)pushAwayFromIndex:(NSUInteger)aIndex
{
    //self.viewScroll.backgroundColor = GGSharedColor.random;
    //int index = aButton.tag;
    int count = _imageButtons.count;
    UIButton *pushedButton = _imageButtons[aIndex];
    _infoWidget.hidden = YES;
    
    if (count <= 1)
    {
        [self showInfoWidgetAnimatedWithPushButton:pushedButton];
        return; // dont need
    }
    
    //
    CGRect rects[count];
    CGRect *rectsPtr = rects;
    for (int i = 0; i < count; i++)
    {
        GGSsgrfRndImgButton *theButton = _imageButtons[i];
        rects[i] = theButton.frame;
    }
    
    //
    
    CGRect pushedRc = pushedButton.frame;
    float posRelative = pushedRc.origin.x - self.viewScroll.contentOffset.x;

    [UIView animateWithDuration:THIS_ANIM_DURATION / 4 animations:^{
        
        // push buttons before
        if (aIndex > 0)
        {
            for (int i = aIndex - 1; i >= 0; i--)
            {
                CGRect targetRc = rectsPtr[i + 1];
                
                float distance = (i == aIndex - 1) ? (_gap + _pushGap) : _gap;
                
                rectsPtr[i] = CGRectMake((targetRc.origin.x - distance - [self imageSize].width)
                                             , targetRc.origin.y
                                             , [self imageSize].width
                                             , [self imageSize].height);
            }
        }
        
        // push buttons after
        if (aIndex < count - 1)
        {
            for (int i = aIndex + 1; i < count; i++)
            {
                CGRect targetRc = rectsPtr[i - 1];
                
                float distance = (i == aIndex + 1) ? (_gap + _pushGap) : _gap;
                
                rectsPtr[i] = CGRectMake((targetRc.origin.x + [self imageSize].width + distance)
                                             , targetRc.origin.y
                                             , [self imageSize].width
                                             , [self imageSize].height);
            }
        }
        
        CGRect firstRc = rectsPtr[0];
        
        float minOffsetX = ([GGSsgrfInfoWidgetView WIDTH] - self.imageSize.width) / 2;
        if (firstRc.origin.x < minOffsetX)
        {
            float offsetX = minOffsetX - firstRc.origin.x;
            for (int i = 0; i < count; i++)
            {
                //CGRect theRc = rectsPtr[i];
                rectsPtr[i] = CGRectOffset(rectsPtr[i], offsetX, 0);
            }
        }
        
//        // adjust the offset
//        if (ABS(firstRc.origin.x) > 0.001f )
//        {
//            float offsetX = -firstRc.origin.x;
//            
//            for (int i = 0; i < count; i++)
//            {
//                //CGRect theRc = rectsPtr[i];
//                rectsPtr[i] = CGRectOffset(rectsPtr[i], offsetX, 0);
//            }
//        }
        
        for (int i = 0; i < count; i++)
        {
            CGRect theRc = rectsPtr[i];
            GGSsgrfRndImgButton *theBtn = _imageButtons[i];
            theBtn.frame = theRc;
        }
        
        // set scroll content size
        float contentWidth = CGRectGetMaxX(rectsPtr[count - 1]) - (rectsPtr[0]).origin.x + [GGSsgrfInfoWidgetView WIDTH];
        self.viewScroll.contentSize = CGSizeMake(contentWidth, self.viewScroll.contentSize.height);

        float contentOffsetX = pushedButton.frame.origin.x - posRelative;
        float widgetOriginX = pushedButton.frame.origin.x + (pushedButton.frame.size.width - _infoWidget.frame.size.width) / 2;
        float widgetMaxX = widgetOriginX + _infoWidget.frame.size.width;
        contentOffsetX = MIN(contentOffsetX, widgetOriginX);
        contentOffsetX = MAX(contentOffsetX, widgetMaxX - self.viewScroll.frame.size.width);
        self.viewScroll.contentOffset = CGPointMake(contentOffsetX, self.viewScroll.contentOffset.y);

        self.viewScroll.contentOffset = CGPointMake(contentOffsetX, self.viewScroll.contentOffset.y);
        
    } completion:^(BOOL finished) {
        
        [self showInfoWidgetAnimatedWithPushButton:pushedButton];
    }];
    
}

#pragma mark - 
-(void)hideInfoWidget
{
    CATransform3D transform = CATransform3DScale(_infoWidget.layer.transform, 0, 0, 0);
    CATransform3D endingScale = _infoWidget.layer.transform;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1);
    opacityAnimation.toValue = @(0);
    opacityAnimation.duration = THIS_ANIM_DURATION;
    [_infoWidget.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    [UIView animateWithDuration:THIS_ANIM_DURATION
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         _infoWidget.layer.transform = transform;
                         
                         [self reArrangeImagePos];
                         
                     }
                     completion:^(BOOL finished){
                         
                         [_infoWidget removeFromSuperview];
                         
                         _infoWidget.hidden = YES;
                         
                         _infoWidget.layer.transform = endingScale;
                         
                         
                     }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //[self hideInfoWidget];
}

@end


