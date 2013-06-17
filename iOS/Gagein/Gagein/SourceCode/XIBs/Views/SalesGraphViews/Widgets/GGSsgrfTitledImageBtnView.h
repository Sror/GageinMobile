//
//  GGSsgrfTitledImageBtnView.h
//  SalesGraph
//
//  Created by Dong Yiming on 6/12/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSsgrfBaseWidget.h"

@interface GGSsgrfTitledImageBtnView : GGSsgrfBaseWidget

-(void)setTitle:(NSString *)aTitle;
-(void)setSubTitle:(NSString *)aTitle;
-(void)setImageURL:(NSString *)aImageURL placeholder:(UIImage *)aPlaceholder;

-(void)setTarget:(id)aTarget action:(SEL)aAction;
-(void)resetTarget:(id)aTarget action:(SEL)aAction;
-(void)clearActions;
@end
