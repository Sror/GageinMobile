//
//  GGSsgrfPopPanelComInfoView.m
//  Gagein
//
//  Created by Dong Yiming on 6/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGSsgrfPopPanelComInfoView.h"

#import "GGSsgrfPopPanelCompany.h"

#import "GGCompany.h"
#import "GGSocialProfile.h"

@implementation GGSsgrfPopPanelComInfoView
{
    long long   _companyID;
    long long   _relevancePersonID;
    GGCompany   *_overview;
}

-(GGSsgrfPopPanelCompany *)panel
{
    return ((GGSsgrfPopPanelCompany *)self.viewContent);
}

-(void)_doInstallContent
{
    GGSsgrfPopPanelCompany *content = [GGSsgrfPopPanelCompany viewFromNibWithOwner:self];
    
    [self.viewContent removeFromSuperview];
    self.viewContent = content;
    self.viewContent.center = self.center;
    [self addSubview:self.viewContent];
    
    [content.btnClose addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}

-(void)updateWithCompany:(GGCompany *)aCompany
{
    _companyID = aCompany.ID;
    _relevancePersonID = aCompany.relevancePersonID;
    
    [self showLoadingHUD];
    self.panel.viewCover.hidden = NO;
    [GGSharedAPI getCompanyOverviewWithID:_companyID needSocialProfile:YES contactID:_relevancePersonID callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        self.panel.viewCover.hidden = YES;
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        _overview = [parser parseGetCompanyOverview];
        [self.panel updateWithCompany:_overview];
    }];
    
//    [GGSharedAPI getCompanyOverviewWithID:_companyID needSocialProfile:YES callback:^(id operation, id aResultObject, NSError *anError) {
//        [self hideLoadingHUD];
//        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//        _overview = [parser parseGetCompanyOverview];
//        [self.panel updateWithCompany:_overview];
//    }];
}

@end
