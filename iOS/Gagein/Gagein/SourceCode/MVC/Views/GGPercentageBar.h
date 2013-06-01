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

@property (assign, nonatomic)      float               percentage;

@end
