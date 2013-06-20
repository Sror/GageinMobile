//
//  GGSsgrfPopPanelPersonInfoView.m
//  Gagein
//
//  Created by Dong Yiming on 6/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGSsgrfPopPanelPersonInfoView.h"

#import "GGSsgrfPopPanelPerson.h"

///////////////////
@implementation GGSsgrfPopPanelPersonInfoView

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
    self.panel.btnLogo.tagNumber = aPersonID;
    self.panel.btnMoreEmployers.tagNumber = aPersonID;
}

@end
