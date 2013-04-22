//
//  GGComOverviewContactCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGComOverviewContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivCellBg;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblTelephone;
@property (weak, nonatomic) IBOutlet UILabel *lblFax;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

-(float)height;
@end
