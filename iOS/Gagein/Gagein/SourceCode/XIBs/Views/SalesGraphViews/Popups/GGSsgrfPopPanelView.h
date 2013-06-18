//
//  GGSsgrfPopPanelView.h
//  Gagein
//
//  Created by Dong Yiming on 6/18/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSsgrfPopPanelView : UIView
@property (strong, nonatomic)   UIView  *viewContent;

+(void)showInView:(UIView *)aView;

@end



///////
@interface GGSsgrfPopPanelComInfoView : GGSsgrfPopPanelView
@end


///////
@interface GGSsgrfPopPanelPersonInfoView : GGSsgrfPopPanelView
@end
