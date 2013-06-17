//
//  GGSsgrfPanelDoubleInfo.h
//  SalesGraph
//
//  Created by Dong Yiming on 6/13/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSsgrfPanelBase.h"

@class GGSsgrfInfoWidgetView;
@class GGSsgrfDblTitleView;

@interface GGSsgrfPanelDoubleInfo : GGSsgrfPanelBase
@property (weak, nonatomic) IBOutlet GGSsgrfInfoWidgetView *viewLeftInfo;
@property (weak, nonatomic) IBOutlet GGSsgrfInfoWidgetView *viewRightInfo;
@property (weak, nonatomic) IBOutlet GGSsgrfDblTitleView *viewLeftText;
@property (weak, nonatomic) IBOutlet GGSsgrfDblTitleView *viewRightText;
@property (weak, nonatomic) IBOutlet UIImageView *ivArrow;

-(void)setLeftText:(NSString *)aText;
-(void)setLeftSubText:(NSString *)aText;
-(void)setRightText:(NSString *)aText;
-(void)setRightSubText:(NSString *)aText;

-(void)setLeftBigTitle;
-(void)setRightBigTitle;

@end