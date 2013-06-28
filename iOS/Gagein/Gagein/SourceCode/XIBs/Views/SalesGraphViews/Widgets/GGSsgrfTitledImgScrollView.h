//
//  GGSsgrfTitledImgScrollView.h
//  SalesGraph
//
//  Created by Dong Yiming on 6/12/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSsgrfBaseWidget.h"


//
@interface GGTouchScrollView : UIScrollView
@property (readonly)    BOOL    touching;
@end


//
@class GGSsgrfInfoWidgetView;


//
@interface GGSsgrfTitledImgScrollView : GGSsgrfBaseWidget <UIScrollViewDelegate>
{
 @protected
    NSMutableArray              *_imageButtons;
    float                       _gap;
    
}
@property (strong, nonatomic) GGTouchScrollView           *viewScroll;

-(void)setTitle:(NSString *)aTitle;
-(void)setTaget:(id)aTarget action:(SEL)aAction;
-(void)setImageUrls:(NSArray *)imageUrls placeholder:(UIImage *)aPlaceholder;
-(void)setGap:(float)aGap;

-(CGSize)imageSize;

//-(void)reArrangeImagePos;

-(float)scrollViewHeight;
@end


// tap to push away scroll view
@interface GGSsgrfPushAwayScrollView : GGSsgrfTitledImgScrollView
@property (strong, nonatomic) GGSsgrfInfoWidgetView       *infoWidget;
@property (strong, nonatomic) GGCompanyUpdate             *data;

-(void)hideInfoWidget;

@end
