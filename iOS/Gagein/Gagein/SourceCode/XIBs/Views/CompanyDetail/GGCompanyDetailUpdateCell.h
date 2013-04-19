//
//  GGCompanyDetailUpdateCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-19.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGCompanyDetailUpdateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewCellBg;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *lblSource;
@property (weak, nonatomic) IBOutlet UILabel *lblInterval;
@property (weak, nonatomic) IBOutlet UILabel *lblHeadLine;

+(float)HEIGHT;
@end
