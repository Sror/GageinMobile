//
//  GGSsgrfPanelComChart.h
//  SalesGraph
//
//  Created by Dong Yiming on 6/13/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSsgrfPanelBase.h"

@class GGSsgrfInfoWidgetView;

@interface GGSsgrfPanelComChart : GGSsgrfPanelHappeningBase
@property (weak, nonatomic) IBOutlet GGSsgrfInfoWidgetView *viewLeftInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnChart;

@end
