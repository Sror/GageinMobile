//
//  GGSsgrfFullInfoWidgetView.h
//  SalesGraph
//
//  Created by Dong Yiming on 6/13/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSsgrfBaseWidget.h"

@interface GGSsgrfInfoWidgetView : GGSsgrfBaseWidget

-(void)setTitle:(NSString *)aTitle;
-(void)setSubTitle:(NSString *)aTitle;
-(void)setScrollTitle:(NSString *)aTitle;

-(void)makeMeSimple;
-(void)showScrollBar:(BOOL)aShow;

-(void)setMainImageUrl:(NSString *)aImageUrl placeholder:(UIImage *)aPlaceholder;
-(void)setMainTaget:(id)aTarget action:(SEL)aAction;

-(void)setScrollImageUrls:(NSArray *)aScrollImageUrls placeholder:(UIImage *)aPlaceholder;
-(void)setScrollTaget:(id)aTarget action:(SEL)aAction;



-(void)updateWithCompany:(GGCompany *)aCompany;

@end
