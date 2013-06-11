//
//  GGComOverviewProfileCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGComOverviewProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivCellBg;

@property (weak, nonatomic) IBOutlet UILabel *lblFounded;
@property (weak, nonatomic) IBOutlet UILabel *lblIndustry;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeciality;
@property (weak, nonatomic) IBOutlet UILabel *lblEmployees;
@property (weak, nonatomic) IBOutlet UILabel *lblRevenue;
@property (weak, nonatomic) IBOutlet UILabel *lblFortuneRank;
@property (weak, nonatomic) IBOutlet UILabel *lblFiscalYear;

-(float)height;

-(void)layMeOut;
@end
