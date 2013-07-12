//
//  GGSsgrfPanelComChart.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/13/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfPanelComChart.h"
#import "GGSsgrfInfoWidgetView.h"
#import <QuartzCore/QuartzCore.h>
#import "GGHappening.h"

@implementation GGSsgrfPanelComChart


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(float)HEIGHT
{
    return 265.f;
}

-(void)awakeFromNib
{
    self.backgroundColor = PANEL_COLOR;
    _viewLeftInfo.backgroundColor = [UIColor clearColor];
    
    _btnChart.layer.borderColor = [UIColor whiteColor].CGColor;
    _btnChart.layer.borderWidth = 3.f;
    _btnChart.layer.shadowOpacity = .8f;
    _btnChart.layer.shadowOffset = CGSizeMake(2, 2);
    _btnChart.layer.shadowColor = [UIColor blackColor].CGColor;
    
    _btnChart.contentMode = UIViewContentModeScaleAspectFill;
    [_btnChart addTarget:self action:@selector(chartTapped:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)_doUpdate
{
    if (_happening)
    {
        switch (_happening.type)
        {
            case kGGHappeningCompanyRevenueChange:
            {
                // left - old company
                [self.viewLeftInfo updateWithCompany:_happening.company];
                
                // right - chart
                NSString *chartUrl = [_happening chartUrlWithSize:_btnChart.frame.size];
                [self.btnChart setBackgroundImageWithURL:[NSURL URLWithString:chartUrl]
                                                forState:UIControlStateNormal
                                        placeholderImage:GGSharedImagePool.placeholder];
            }
                break;
                
                
            default:
                break;
        }
        
        self.blackCurtainView.hidden = YES;
    }
}

#pragma mark - action
-(void)chartTapped:(id)sender
{
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_CHART_IMAGE_URL withObject:_happening.revenueChart];
}

@end
