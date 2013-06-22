//
//  GGTriggerChartCell.h
//  Gagein
//
//  Created by Dong Yiming on 6/12/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPercentageBar;

@interface GGTriggerChartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet GGPercentageBar *viewPercentBar;
@property (weak, nonatomic) IBOutlet UIImageView *ivCheck;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivBg;

-(void)setPercentage:(float)aPercentage isHot:(BOOL)aIsHot;
-(void)setPercentage:(float)aPercentage isHot:(BOOL)aIsHot animated:(BOOL)aAnimated;

-(void)setChecked:(BOOL)aChecked;
-(void)setStyle:(EGGGroupedCellStyle)style;

+(float)HEIGHT;

@end
