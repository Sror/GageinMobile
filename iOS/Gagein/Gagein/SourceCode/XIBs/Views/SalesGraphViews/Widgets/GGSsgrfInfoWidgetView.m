//
//  GGSsgrfFullInfoWidgetView.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/13/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfInfoWidgetView.h"

#import "GGSsgrfTitledImageBtnView.h"
#import "GGSsgrfTitledImgScrollView.h"

@interface GGSsgrfInfoWidgetView ()
@property (strong, nonatomic)   GGSsgrfTitledImageBtnView   *viewTitledImage;
@property (strong, nonatomic)   GGSsgrfTitledImgScrollView   *viewTitledScroll;

@end

@implementation GGSsgrfInfoWidgetView

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self _doInit];
//    }
//    return self;
//}

-(void)_doInit
{
    //self.backgroundColor = [UIColor darkGrayColor];
    
    _viewTitledImage = [[GGSsgrfTitledImageBtnView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:_viewTitledImage];
    
    CGRect scrollRc = CGRectMake(0, CGRectGetMaxY(_viewTitledImage.frame), _viewTitledImage.frame.size.width, 0);
    _viewTitledScroll = [[GGSsgrfTitledImgScrollView alloc] initWithFrame:scrollRc];
    [self addSubview:_viewTitledScroll];
    
    CGRect thisRc = self.frame;
    thisRc.size.width = _viewTitledImage.frame.size.width;
    thisRc.size.height = CGRectGetMaxY(_viewTitledScroll.frame);
    self.frame = thisRc;
    
    //
    [self setScrollTitle:@"Competitors"];
}

#pragma mark - interface
-(void)setTitle:(NSString *)aTitle
{
    [_viewTitledImage setTitle:aTitle];
}

-(void)setSubTitle:(NSString *)aTitle
{
    [_viewTitledImage setSubTitle:aTitle];
}

-(void)setScrollTitle:(NSString *)aTitle
{
    [_viewTitledScroll setTitle:aTitle];
}

-(void)showScrollBar:(BOOL)aShow
{
    _viewTitledScroll.hidden = !aShow;
    
    CGRect thisRc = self.frame;
    thisRc.size.height = aShow ? CGRectGetMaxY(_viewTitledScroll.frame) : CGRectGetMaxY(_viewTitledImage.frame);
    self.frame = thisRc;
}


-(void)setMainImageUrl:(NSString *)aImageUrl placeholder:(UIImage *)aPlaceholder
{
    [_viewTitledImage setImageURL:aImageUrl placeholder:aPlaceholder];
}

-(void)setMainTaget:(id)aTarget action:(SEL)aAction
{
    [_viewTitledImage setTarget:aTarget action:aAction];
}


-(void)setScrollImageUrls:(NSArray *)aScrollImageUrls placeholder:(UIImage *)aPlaceholder
{
    [_viewTitledScroll setImageUrls:aScrollImageUrls placeholder:aPlaceholder];
}

-(void)setScrollTaget:(id)aTarget action:(SEL)aAction
{
    [_viewTitledScroll setTaget:aTarget action:aAction];
}

-(void)setData:(id)aData;
{
    
}

@end
