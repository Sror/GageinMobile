//
//  GGSsgrfTitledImageBtnView.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/12/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfTitledImageBtnView.h"

#import "GGSsgrfDblTitleView.h"
#import "GGSsgrfRndImgButton.h"

#define THIS_WIDTH   200.f
#define THIS_HEIGHT  180.f

#define MAIN_IMAGE_WIDTH    90.f
#define MAIN_IMGAGE_HEIGHT  90.f

#define TITLE_WIDTH     140.f

@implementation GGSsgrfTitledImageBtnView
{
    GGSsgrfDblTitleView     *_viewDblTitle;
    GGSsgrfRndImgButton     *_viewRndImgBtn;
}

-(void)applyCircleEffect:(BOOL)aApplyCircleEffect
{
    if (aApplyCircleEffect)
    {
        [_viewRndImgBtn.imageView applyEffectCircleSilverBorder];
    }
    else
    {
        [_viewRndImgBtn.imageView applyEffectRoundRectSilverBorder];
    }
}

+(float)WIDTH
{
    return THIS_WIDTH;
}

-(void)_doInit
{
    CGRect thisRc = self.frame;
    CGRect fixedFrame = CGRectMake(thisRc.origin.x, thisRc.origin.y, THIS_WIDTH, THIS_HEIGHT);
    self.frame = fixedFrame;
    
    //self.backgroundColor = [UIColor blackColor];
    CGSize thisSize = self.frame.size;
    
    _viewDblTitle = [[GGSsgrfDblTitleView alloc] initWithFrame:CGRectMake((thisSize.width - TITLE_WIDTH) / 2, 10, TITLE_WIDTH, 0)];
    [self addSubview:_viewDblTitle];
    [_viewDblTitle setTitleNumOfLines:1];
    //[_viewDblTitle setTitle:@"Apple Software Inc."];
    //[_viewDblTitle setSubTitle:@"World Wide Developer Conference 2013"];
    
    CGRect rndImgBtnRc = CGRectMake((thisSize.width - MAIN_IMAGE_WIDTH) / 2
                                    , 70
                                    , MAIN_IMAGE_WIDTH, MAIN_IMGAGE_HEIGHT);
    _viewRndImgBtn = [[GGSsgrfRndImgButton alloc] initWithFrame:rndImgBtnRc];
    [self addSubview:_viewRndImgBtn];
    //[roundImgBtn setImage:[UIImage imageNamed:@"picSample.jpg"]];
}

-(void)_adjsutTitlePos
{
    CGRect titleRc = _viewDblTitle.frame;
    CGRect btnRc = _viewRndImgBtn.frame;
    titleRc.origin.y = btnRc.origin.y - titleRc.size.height - 10;
    _viewDblTitle.frame = titleRc;
}

#pragma mark - interface
-(void)setTitle:(NSString *)aTitle
{
    [_viewDblTitle setTitle:aTitle];
    [self _adjsutTitlePos];
}

-(void)setSubTitle:(NSString *)aTitle
{
    [_viewDblTitle setSubTitle:aTitle];
    [self _adjsutTitlePos];
}

-(void)setImage:(UIImage *)aImage
{
    _viewRndImgBtn.imageView.image = aImage;
}

-(void)setImageURL:(NSString *)aImageURL placeholder:(UIImage *)aPlaceholder
{
    [_viewRndImgBtn setImageUrl:aImageURL placeholder:aPlaceholder];
}

-(void)clearActions
{
    [_viewRndImgBtn clearActions];
}

-(void)setTarget:(id)aTarget action:(SEL)aAction
{
    [_viewRndImgBtn addTarget:aTarget action:aAction];
}

-(void)resetTarget:(id)aTarget action:(SEL)aAction
{
    [_viewRndImgBtn clearActions];
    [_viewRndImgBtn addTarget:aTarget action:aAction];
}

@end
