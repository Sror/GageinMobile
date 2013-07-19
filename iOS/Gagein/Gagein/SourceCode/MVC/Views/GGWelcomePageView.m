//
//  GGWelcomePageView.m
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGWelcomePageView.h"

#define IPAD_IMAGE_WIDTH            401
#define IPAD_IMAGE_HEIGHT_SHORT     340
#define IPAD_IMAGE_HEIGHT_LONG      370

@implementation GGWelcomePageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.frame = [UIScreen mainScreen].applicationFrame;
    [_getStartedBtn setBackgroundImage:GGSharedImagePool.bgBtnOrangeDarkEdge forState:UIControlStateNormal];
    
    if (ISIPADDEVICE)
    {
        _ivPage1.image = [UIImage imageNamed:@"welcome01Big"];
        _ivPage1.frame = CGRectMake((_page1.frame.size.width - IPAD_IMAGE_WIDTH) / 2
                                    , (_page1.frame.size.height - IPAD_IMAGE_HEIGHT_SHORT) / 2
                                    , IPAD_IMAGE_WIDTH
                                    , IPAD_IMAGE_HEIGHT_SHORT);
        
        _ivPage2.image = [UIImage imageNamed:@"welcome02Big"];
        _ivPage2.frame = CGRectMake((_page2.frame.size.width - IPAD_IMAGE_WIDTH) / 2
                                    , (_page2.frame.size.height - IPAD_IMAGE_HEIGHT_SHORT) / 2
                                    , IPAD_IMAGE_WIDTH
                                    , IPAD_IMAGE_HEIGHT_SHORT);
        
        _ivPage3.image = [UIImage imageNamed:@"welcome03Big"];
        _ivPage3.frame = CGRectMake((_page3.frame.size.width - IPAD_IMAGE_WIDTH) / 2
                                    , (_page3.frame.size.height - IPAD_IMAGE_HEIGHT_LONG) / 2
                                    , IPAD_IMAGE_WIDTH
                                    , IPAD_IMAGE_HEIGHT_LONG);
        
        _ivPage4.image = [UIImage imageNamed:@"welcome04Big"];
        _ivPage4.frame = CGRectMake((_page4.frame.size.width - IPAD_IMAGE_WIDTH) / 2
                                    , (_page4.frame.size.height - IPAD_IMAGE_HEIGHT_LONG) / 2
                                    , IPAD_IMAGE_WIDTH
                                    , IPAD_IMAGE_HEIGHT_LONG);
    }
    
    [self doLayoutUIForIPadWithOrientation:[GGLayout currentOrient]];
}

-(void)showPageWithIndex:(NSUInteger)aIndex
{
    self.page1.hidden =
    self.page2.hidden =
    self.page3.hidden =
    self.page4.hidden = YES;
    
    switch (aIndex) {
        case 0:
        {
            self.page1.hidden = NO;
        }
            break;
            
        case 1:
        {
            self.page2.hidden = NO;
        }
            break;
            
        case 2:
        {
            self.page3.hidden = NO;
        }
            break;
            
        case 3:
        {
            self.page4.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
    for (UIView *view in self.subviews)
    {
        if (view.hidden) {
            [view removeFromSuperview];
        }
    }
}

-(IBAction)getStartedAction:(id)sender
{
    DLog(@"show sign up screen");
    [self postNotification:GG_NOTIFY_GET_STARTED];
}


-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //
    CGRect thisRc = [GGLayout frameWithOrientation:toInterfaceOrientation rect:self.frame];
    
    _ivPage1.frame = CGRectMake((thisRc.size.width - _ivPage1.frame.size.width) / 2
                                , (thisRc.size.height - _ivPage1.frame.size.height) / 2
                                , _ivPage1.frame.size.width
                                , _ivPage1.frame.size.height);
    
    //
    _ivPage2.frame = CGRectMake((thisRc.size.width - _ivPage2.frame.size.width) / 2
                                , (thisRc.size.height - _ivPage2.frame.size.height) / 2
                                , _ivPage2.frame.size.width
                                , _ivPage2.frame.size.height);
    
    //
    _ivPage3.frame = CGRectMake((thisRc.size.width - _ivPage3.frame.size.width) / 2
                                , (thisRc.size.height - _ivPage3.frame.size.height) / 2
                                , _ivPage3.frame.size.width
                                , _ivPage3.frame.size.height);
    
    //
    float offsetY = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) ? 60.f : 30.f;
    _ivPage4.frame = CGRectMake((thisRc.size.width - _ivPage4.frame.size.width) / 2
                                , (thisRc.size.height - _ivPage4.frame.size.height) / 2 - offsetY
                                , _ivPage4.frame.size.width
                                , _ivPage4.frame.size.height);
    
    //
    float ipadOffsetY = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) ? 150.f : 70.f;
    offsetY = CGRectGetMaxY(_ivPage4.frame) + (ISIPADDEVICE ? ipadOffsetY : 10);
    CGRect getStartedRc = _getStartedBtn.frame;
    getStartedRc.size.width = 409.f;
    getStartedRc.size.height = 44.f;
    _getStartedBtn.frame =  CGRectMake((thisRc.size.width - getStartedRc.size.width) / 2
                                       , offsetY
                                       , getStartedRc.size.width
                                       , getStartedRc.size.height);
}

@end
