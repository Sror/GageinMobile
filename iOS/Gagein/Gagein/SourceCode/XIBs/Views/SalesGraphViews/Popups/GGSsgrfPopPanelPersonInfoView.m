//
//  GGSsgrfPopPanelPersonInfoView.m
//  Gagein
//
//  Created by Dong Yiming on 6/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGSsgrfPopPanelPersonInfoView.h"

#import "GGSsgrfPopPanelPerson.h"
#import "GGPerson.h"

///////////////////
@implementation GGSsgrfPopPanelPersonInfoView
{
    long long   _personID;
    GGPerson    *_overview;
}

-(GGSsgrfPopPanelPerson *)panel
{
    return ((GGSsgrfPopPanelPerson *)self.viewContent);
}

-(void)_doInstallContent
{
    GGSsgrfPopPanelPerson *content = [GGSsgrfPopPanelPerson viewFromNibWithOwner:self];
    
    [self.viewContent removeFromSuperview];
    self.viewContent = content;
    self.viewContent.center = self.center;
    [self addSubview:self.viewContent];
    
    [content.btnClose addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}

-(void)updateWithPersonID:(NSNumber *)aPersonID
{
    _personID = [aPersonID longLongValue];
    
    [self showLoadingHUD];
    
    [GGSharedAPI getPersonOverviewWithID:_personID callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        _overview = [parser parseGetPersonOverview];
        [self.panel updateWithPerson:_overview];
    }];
}

@end
