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
    
//    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:_viewScroll action:@selector(hideInfoWidget)];
//    [self addGestureRecognizer:tapGest];
}

-(void)setData:(GGCompanyUpdate *)data
{
    _data = data;
    _viewScroll.data = data;
}

@end
