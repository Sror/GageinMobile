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



//#define IMAGE_GAP   5

#define IMAGE_SIZE_WIDTH    31
#define IMAGE_SIZE_HEIGHT   31

#define SCROLL_VIEW_CAP_WIDTH   20

@implementation GGSsgrfTitledImgScrollView
{
    GGAutosizingLabel           *_lblTitle;
    
    
    UIImage                     *_placeholder;
    NSArray                     *_imageUrls;
    
    id                          _imageBtnTarget;
    SEL                         _imageBtnAction;
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
    
    //_lblTitle.text = @"Competitor";
    
    //
    CGRect scrollRc = CGRectMake(SCROLL_VIEW_CAP_WIDTH, CGRectGetMaxY(_lblTitle.frame) + 15, thisSize.width - SCROLL_VIEW_CAP_WIDTH * 2, [self scrollViewHeight]);
    _viewScroll = [[UIScrollView alloc] initWithFrame:scrollRc];
    _viewScroll.showsHorizontalScrollIndicator = NO;
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
    
    int offsetX = 0;
    int count = _imageUrls.count;
    for (int i = 0; i < count; i++)
    {
        GGSsgrfRndImgButton *button = [[GGSsgrfRndImgButton alloc] initWithFrame:CGRectMake(offsetX, ([self scrollViewHeight] - IMAGE_SIZE_HEIGHT) / 2, IMAGE_SIZE_WIDTH, IMAGE_SIZE_HEIGHT)];
        
        button.tag = i;
        
        NSString *urlStr = _imageUrls[i];
        [button setImageWithURL:[NSURL URLWithString:urlStr]
                       forState:UIControlStateNormal placeholderImage:_placeholder];
        button.layer.cornerRadius = 4.f;
        
        [button addTarget:_imageBtnTarget action:_imageBtnAction];
        [_viewScroll addSubview:button];
        [_imageButtons addObject:button];
        
        offsetX = CGRectGetMaxX(button.frame) + _gap;
    }
    
    _viewScroll.contentSize = CGSizeMake(offsetX - _gap, IMAGE_SIZE_HEIGHT);
}


-(void)reArrangeImagePos
{
    int count = _imageButtons.count;
    int offsetX = 0;
    for (int i = 0; i < count; i++)
    {
        GGSsgrfRndImgButton *btn = _imageButtons[i];
        btn.frame = CGRectMake(offsetX, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
        offsetX = CGRectGetMaxX(btn.frame) + _gap;
    }
    
    _viewScroll.contentSize = CGSizeMake(offsetX - _gap, IMAGE_SIZE_HEIGHT);
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



@end

//////////////////////// GGSsgrfPushAwayScrollView/////////////////////////
@implementation GGSsgrfPushAwayScrollView
{
    float                       _pushGap;
    
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
        [button addTarget:self action:@selector(pushAwayFromIndex:)];
    }
}

#define THIS_ANIM_DURATION  .4f

-(void)pushAwayFromIndex:(UIButton *)aButton
{
    int index = aButton.tag;
    int count = _imageButtons.count;
    UIButton *pushedButton = _imageButtons[index];
    _infoWidget.hidden = YES;
    
    if (count <= 1)
    {
        _infoWidget.hidden = NO;
        _infoWidget.center = pushedButton.center;
        [_viewScroll addSubview:_infoWidget];
        
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
    float posRelative = pushedRc.origin.x - _viewScroll.contentOffset.x;

    [UIView animateWithDuration:THIS_ANIM_DURATION / 4 animations:^{
        
        // push buttons before
        if (index > 0)
        {
            for (int i = index - 1; i >= 0; i--)
            {
                CGRect targetRc = rectsPtr[i + 1];
                
                float distance = (i == index - 1) ? (_gap + _pushGap) : _gap;
                
                rectsPtr[i] = CGRectMake((targetRc.origin.x - distance - IMAGE_SIZE_WIDTH)
                                             , targetRc.origin.y
                                             , IMAGE_SIZE_WIDTH
                                             , IMAGE_SIZE_HEIGHT);
            }
        }
        
        // push buttons after
        if (index < count - 1)
        {
            for (int i = index + 1; i < count; i++)
            {
                CGRect targetRc = rectsPtr[i - 1];
                
                float distance = (i == index + 1) ? (_gap + _pushGap) : _gap;
                
                rectsPtr[i] = CGRectMake((targetRc.origin.x + IMAGE_SIZE_WIDTH + distance)
                                             , targetRc.origin.y
                                             , IMAGE_SIZE_WIDTH
                                             , IMAGE_SIZE_HEIGHT);
            }
        }
        
        CGRect firstRc = rectsPtr[0];
        
        // adjust the offset
        if (ABS(firstRc.origin.x) > 0.001f )
        {
            float offsetX = -firstRc.origin.x;
            
            for (int i = 0; i < count; i++)
            {
                //CGRect theRc = rectsPtr[i];
                rectsPtr[i] = CGRectOffset(rectsPtr[i], offsetX, 0);
            }
        }
        
        for (int i = 0; i < count; i++)
        {
            CGRect theRc = rectsPtr[i];
            GGSsgrfRndImgButton *theBtn = _imageButtons[i];
            theBtn.frame = theRc;
        }
        
        // set scroll content size
        float contentWidth = CGRectGetMaxX(rectsPtr[count - 1]) - (rectsPtr[0]).origin.x;
        _viewScroll.contentSize = CGSizeMake(contentWidth, _viewScroll.contentSize.height);

        float contentOffsetX = pushedButton.frame.origin.x - posRelative;
        float widgetOriginX = pushedButton.frame.origin.x + (pushedButton.frame.size.width - _infoWidget.frame.size.width) / 2;
        float widgetMaxX = widgetOriginX + _infoWidget.frame.size.width;
        contentOffsetX = MIN(contentOffsetX, widgetOriginX);
        contentOffsetX = MAX(contentOffsetX, widgetMaxX - _viewScroll.frame.size.width);
        _viewScroll.contentOffset = CGPointMake(contentOffsetX, _viewScroll.contentOffset.y);

        _viewScroll.contentOffset = CGPointMake(contentOffsetX, _viewScroll.contentOffset.y);
        
    } completion:^(BOOL finished) {
        
        _infoWidget.hidden = NO;
        CGPoint center = pushedButton.center;
        center.y -= 0;
        _infoWidget.center = center;
        [_viewScroll addSubview:_infoWidget];
        
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
        
    }];
    
}

#pragma mark - 
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
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

@end


