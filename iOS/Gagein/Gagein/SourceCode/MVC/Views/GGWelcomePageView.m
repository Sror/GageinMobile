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

@end
