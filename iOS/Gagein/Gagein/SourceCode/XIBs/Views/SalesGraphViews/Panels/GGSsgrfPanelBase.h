//
//  GGSsgrfPanelBase.h
//  SalesGraph
//
//  Created by Dong Yiming on 6/13/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSsgrfPanelBase : UIView
@property (strong, nonatomic) UIView              *blackCurtainView;

+(float)HEIGHT;

@end



/////////
@interface GGSsgrfPanelHappeningBase : GGSsgrfPanelBase
{
 @protected
    GGHappening         *_happening;
}
-(void)updateWithHappening:(GGHappening *)aHappening;
-(void)update;

@end

#define PANEL_COLOR     [UIColor colorWithRed:39.f/255 green:39.f/255 blue:39.f/255 alpha:1]
