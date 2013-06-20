//
//  GGSsgrfPopPanelPersonInfoView.h
//  Gagein
//
//  Created by Dong Yiming on 6/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGSsgrfPopPanelView.h"
#import "GGSsgrfPopPanelPerson.h"

///////
@interface GGSsgrfPopPanelPersonInfoView : GGSsgrfPopPanelView
-(GGSsgrfPopPanelPerson *)panel;
-(void)updateWithPersonID:(NSNumber *)aPersonID;
@end
