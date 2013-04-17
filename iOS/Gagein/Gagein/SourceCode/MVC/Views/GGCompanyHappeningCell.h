//
//  GGCompanyHappeningCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-17.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGCompanyHappeningCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblInterval;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

+(float)HEIGHT;
@end
