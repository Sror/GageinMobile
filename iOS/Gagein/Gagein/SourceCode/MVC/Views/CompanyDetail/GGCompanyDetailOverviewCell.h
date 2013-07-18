//
//  GGCompanyDetailOverviewCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-19.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGCompanyDetailOverviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewCellBg;
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UIImageView *ivBg;
@property (weak, nonatomic) IBOutlet UILabel *lblIndustry;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

+(float)HEIGHT;

-(void)doLayout;

@end
