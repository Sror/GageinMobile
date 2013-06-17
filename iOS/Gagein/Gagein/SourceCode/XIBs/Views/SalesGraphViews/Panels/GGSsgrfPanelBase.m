//
//  GGSsgrfPanelBase.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/13/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfPanelBase.h"

@implementation GGSsgrfPanelBase

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
    return 0.f;
}

@end


////////////////////
@implementation GGSsgrfPanelHappeningBase

-(void)updateWithHappening:(GGHappening *)aHappening
{
    
}

@end
