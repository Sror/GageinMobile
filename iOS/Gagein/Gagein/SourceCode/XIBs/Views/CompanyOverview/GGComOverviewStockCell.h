//
//  GGComOverviewStockCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGComOverviewStockCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivCellBg;
@property (weak, nonatomic) IBOutlet UILabel *lblOwnership;
@property (weak, nonatomic) IBOutlet UILabel *lblStockChange;
@property (weak, nonatomic) IBOutlet UILabel *lblStockSymbol;
@property (weak, nonatomic) IBOutlet UIButton *btnStock;

-(float)height;
@end
