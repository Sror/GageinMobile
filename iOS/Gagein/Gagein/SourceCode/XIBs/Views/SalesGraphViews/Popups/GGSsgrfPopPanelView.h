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

-(id)initWithView:(UIView *)aView;

+(void)showInView:(UIView *)aView;

-(void)showMe;
-(void)hide;

-(void)handleOrientChange:(UIInterfaceOrientation)aOrient;

@end



///////




