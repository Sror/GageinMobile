//
//  GGCompanyUpdateCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-7.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGAutosizingLabel.h"

@interface GGCompanyUpdateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *sourceLbl;
@property (weak, nonatomic) IBOutlet UILabel *intervalLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UIButton *logoBtn;

@property (weak, nonatomic) IBOutlet UIView *viewCellBg;
@property (weak, nonatomic) IBOutlet UIImageView *ivCellBg;

@property (assign)  long long               ID;
@property (assign, nonatomic)  BOOL         hasBeenRead;

//+(float)HEIGHT;
-(float)adjustLayout;
@end
