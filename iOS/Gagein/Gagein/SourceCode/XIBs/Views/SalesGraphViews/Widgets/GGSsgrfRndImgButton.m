//
//  GGSsgrfRndImgButton.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/12/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfRndImgButton.h"
#import <QuartzCore/QuartzCore.h>

@interface GGSsgrfRndImgButton ()
@property (strong, nonatomic) UIActivityIndicatorView     *viewLoading;
@end

@implementation GGSsgrfRndImgButton
{
    UIButton                    *_button;
    
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
    if (self)
    {
        [self _doInit];
    }
    
    return self;
}

-(void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    _button.tag = tag;
}

-(void)_doInit
{
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_imageView];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = self.bounds;
    [self addSubview:_button];
    
    
    float radius = _imageView.frame.size.width / 4;
    radius = MIN(4, radius);
    _imageView.layer.cornerRadius = radius;
    _imageView.layer.borderColor = GGSharedColor.silver.CGColor;
    _imageView.layer.borderWidth = 2.f;
    _imageView.clipsToBounds = YES;
    
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _viewLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _viewLoading.hidesWhenStopped = YES;
}

-(void)clearActions
{
    [_button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
}

-(void)addTarget:(id)target action:(SEL)action
{
    //
    [_button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)setImageUrl:(NSString *)aImageURL placeholder:(UIImage *)aPlaceHolder
{
    [_imageView addSubview:_viewLoading];
    _viewLoading.center = _imageView.center;
    [_viewLoading startAnimating];
    
    __weak typeof(self) weakSelf = self;
    NSURL *url = [NSURL URLWithString:aImageURL];
    if (url)
    {
        [_imageView setImageWithURL:url placeholderImage:aPlaceHolder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            [weakSelf.viewLoading stopAnimating];
            [weakSelf.viewLoading removeFromSuperview];
            
        }];
    }
    else
    {
        _imageView.image = aPlaceHolder;
        [weakSelf.viewLoading stopAnimating];
        [weakSelf.viewLoading removeFromSuperview];
    }
}

@end
