//
//  GGGroupedCell.h
//  Gagein
//
//  Created by Dong Yiming on 5/14/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGEditStyleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


+(float)HEIGHT;
@end
