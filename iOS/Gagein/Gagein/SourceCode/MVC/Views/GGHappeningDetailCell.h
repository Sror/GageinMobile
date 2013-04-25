//
//  GGHappeningDetailCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-25.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGHappeningDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewCellBg;
@property (weak, nonatomic) IBOutlet UIImageView *ivCellBg;
@property (weak, nonatomic) IBOutlet UILabel *lblSource;
@property (weak, nonatomic) IBOutlet UILabel *lblInterval;
@property (weak, nonatomic) IBOutlet UILabel *lblHeadline;
@property (weak, nonatomic) IBOutlet UIImageView *ivChart;

@property (weak, nonatomic) IBOutlet UIView *viewChange;

@property (weak, nonatomic) IBOutlet UIView *viewChangeLeft;
@property (weak, nonatomic) IBOutlet UIImageView *ivChangeLeft;
@property (weak, nonatomic) IBOutlet UILabel *lblChangeLeftTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblChangeLeftSubTitle;

@property (weak, nonatomic) IBOutlet UIView *viewChangeRight;
@property (weak, nonatomic) IBOutlet UIImageView *ivChangeRight;
@property (weak, nonatomic) IBOutlet UILabel *lblChangeRightTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblChangeRightSubTitle;

-(float)height;

-(void)showChangeLeftImage:(BOOL)aShow;

-(void)showChangeRightImage:(BOOL)aShow;

-(void)showChangeLeftText:(BOOL)aShow;

-(void)showChangeRightText:(BOOL)aShow;

-(void)showChart:(BOOL)aShow;

-(void)showChangeView:(BOOL)aShow;

@end
