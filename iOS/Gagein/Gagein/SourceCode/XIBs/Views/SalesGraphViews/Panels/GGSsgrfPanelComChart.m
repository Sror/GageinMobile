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
                [self.viewLeftInfo updateWithCompany:_happening.oldCompany];
                
                // right - chart
                [self.btnChart setBackgroundImageWithURL:[NSURL URLWithString:_happening.revenueChart]
                                                forState:UIControlStateNormal
                                        placeholderImage:GGSharedImagePool.placeholder];
            }
                break;
                
                
            default:
                break;
        }
    }
}

@end
