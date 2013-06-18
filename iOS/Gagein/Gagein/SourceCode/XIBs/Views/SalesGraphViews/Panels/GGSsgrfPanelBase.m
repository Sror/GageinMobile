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
        [self _doInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _doInit];
    }
    return self;
}

-(void)_doInit
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doNothing)];
    [self addGestureRecognizer:tap];
}

-(void)doNothing
{
    
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
