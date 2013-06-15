//
//  GGSsgrfPanelUpdate.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/14/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfPanelUpdate.h"
#import "GGSsgrfTitledImgScrollView.h"

@implementation GGSsgrfPanelUpdate

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
    self.backgroundColor = PANEL_COLOR;
    
    _viewScroll.backgroundColor = [UIColor clearColor];
}

@end
