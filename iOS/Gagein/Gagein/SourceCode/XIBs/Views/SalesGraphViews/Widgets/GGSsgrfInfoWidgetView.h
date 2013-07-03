//
//  GGSsgrfFullInfoWidgetView.h
//  SalesGraph
//
//  Created by Dong Yiming on 6/13/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSsgrfBaseWidget.h"
#import "GGHappening.h"

typedef enum {
    kGGSsGrfInfoWidgetCompany = 0
    , kGGSsGrfInfoWidgetPerson
    , kGGSsGrfInfoWidgetAddress
} EGGSsGrfInfoWidgetType;


@class GGSsgrfTitledImgScrollView;

@interface GGSsgrfInfoWidgetView : GGSsgrfBaseWidget <UIScrollViewDelegate>
@property (strong, nonatomic)   GGSsgrfTitledImgScrollView   *viewTitledScroll;

@property (nonatomic, strong)   id      data;
@property (nonatomic, copy) NSString    *mapURL;

@property (assign, nonatomic) EGGSsGrfInfoWidgetType    type;
@property (strong, nonatomic) GGTagetActionPair           *loadingAction;

-(void)setTitle:(NSString *)aTitle;
-(void)setSubTitle:(NSString *)aTitle;
-(void)setScrollTitle:(NSString *)aTitle;

-(void)makeMeSimple;
-(void)showScrollBar:(BOOL)aShow;

-(void)applyCircleEffect:(BOOL)aApplyCircle;
-(void)setMainImageUrl:(NSString *)aImageUrl placeholder:(UIImage *)aPlaceholder;
-(void)setMainTaget:(id)aTarget action:(SEL)aAction;

-(void)setScrollImageUrls:(NSArray *)aScrollImageUrls placeholder:(UIImage *)aPlaceholder;
-(void)setScrollTaget:(id)aTarget action:(SEL)aAction;

-(void)updateWithCompany:(GGCompanyDigest *)aCompany;
-(void)updateWithPerson:(GGHappeningPerson *)aPerson;
-(void)updateWithPerson:(GGHappeningPerson *)aPerson showOldPhoto:(BOOL)showOldPhoto;
-(void)updateWithMapUrl:(NSString *)aMapURL;

@end
