//
//  GGPercentageBar.h
//  TestPercentBar
//
//  Created by Dong Yiming on 5/31/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPercentageBar : UIView
@property (strong, nonatomic)   UIView      *viewBar;
@property (strong, nonatomic)   UIView      *viewBarBg;
@property (strong, nonatomic)   UILabel     *lblPercentage;

@property (readonly, nonatomic)      float               percentage;

-(void)setPercentage:(float)percentage isHot:(BOOL)aIsHot;
-(void)setPercentage:(float)percentage isHot:(BOOL)aIsHot animated:(BOOL)aAnimated;

@end
