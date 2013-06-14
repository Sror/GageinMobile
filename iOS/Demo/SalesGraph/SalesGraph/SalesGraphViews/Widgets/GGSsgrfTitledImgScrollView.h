//
//  GGSsgrfTitledImgScrollView.h
//  SalesGraph
//
//  Created by Dong Yiming on 6/12/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSsgrfBaseWidget.h"

@interface GGSsgrfTitledImgScrollView : GGSsgrfBaseWidget

-(void)setTitle:(NSString *)aTitle;
-(void)setTaget:(id)aTarget action:(SEL)aAction;
-(void)setImageUrls:(NSArray *)imageUrls placeholder:(UIImage *)aPlaceholder;
@end
