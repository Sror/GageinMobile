//
//  GGSsgrfPanelBase.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/13/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfPanelBase.h"
#import "GGHappening.h"

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
    _happening = aHappening;
    if (aHappening.ID)
    {
        GGHappening *cachedHappening = [GGSharedRuntimeData.happeningCache happeningWithID:aHappening.ID];
        if (cachedHappening == nil)
        {
            // call API to get detail
            GGApiBlock callback = ^(id operation, id aResultObject, NSError *anError) {
                
                [self hideLoadingHUD];
                GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                if (parser.isOK)
                {
                    _happening = [parser parseCompanyEventDetail];
                    [GGSharedRuntimeData.happeningCache add:_happening];
                    [self _doUpdate];
                }
            };
            
            [self showLoadingHUD];
            if ([aHappening isPersonEvent])
            {
                [GGSharedAPI getPeopleEventDetailWithID:aHappening.ID callback:callback];
            }
            else
            {
                [GGSharedAPI getCompanyEventDetailWithID:aHappening.ID callback:callback];
            }
        }
        else
        {
            _happening = cachedHappening;
            [self _doUpdate];
        }
    }
}

-(void)_doUpdate
{
    // leave for sub class to update UI
}

@end
