//
//  GGWelcomePageView.m
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGWelcomePageView.h"

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
    [_getStartedBtn setBackgroundImage:GGSharedImagePool.bgBtnOrange forState:UIControlStateNormal];
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
    CGRect thisRc = [GGUtils frameWithOrientation:toInterfaceOrientation rect:self.frame];
    
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
    _ivPage4.frame = CGRectMake((thisRc.size.width - _ivPage4.frame.size.width) / 2
                                , (thisRc.size.height - _ivPage4.frame.size.height) / 2
                                , _ivPage4.frame.size.width
                                , _ivPage4.frame.size.height);
    
    //
    float offsetY = CGRectGetMaxY(_ivPage4.frame) + 50;
    CGRect getStartedRc = _getStartedBtn.frame;
    getStartedRc.size.width = 409.f;
    getStartedRc.size.height = 44.f;
    _getStartedBtn.frame =  CGRectMake((thisRc.size.width - getStartedRc.size.width) / 2
                                       , offsetY
                                       , getStartedRc.size.width
                                       , getStartedRc.size.height);
}

@end
