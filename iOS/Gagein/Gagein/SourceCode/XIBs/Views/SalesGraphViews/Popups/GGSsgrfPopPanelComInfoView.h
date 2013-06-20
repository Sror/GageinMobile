//
//  GGSsgrfPopPanelComInfoView.h
//  Gagein
//
//  Created by Dong Yiming on 6/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGSsgrfPopPanelView.h"
#import "GGSsgrfPopPanelCompany.h"

@interface GGSsgrfPopPanelComInfoView : GGSsgrfPopPanelView
-(GGSsgrfPopPanelCompany *)panel;
-(void)updateWithCompanyID:(NSNumber *)aCompanyID;
@end
