//
//  GGSsgrfPopPanelView.h
//  Gagein
//
//  Created by Dong Yiming on 6/18/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSsgrfPopPanelCompany.h"
#import "GGSsgrfPopPanelPerson.h"

@interface GGSsgrfPopPanelView : UIView
@property (strong, nonatomic)   UIView  *viewContent;

+(void)showInView:(UIView *)aView;

-(void)showMeInView:(UIView *)aView;
-(void)hide;
@end



///////
@interface GGSsgrfPopPanelComInfoView : GGSsgrfPopPanelView
-(GGSsgrfPopPanelCompany *)panel;
@end


///////
@interface GGSsgrfPopPanelPersonInfoView : GGSsgrfPopPanelView
-(GGSsgrfPopPanelPerson *)panel;
@end
