//
//  GGSettingMenuCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-12.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSettingMenuCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UIImageView *ivSelected;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblInterval;

+(float)HEIGHT;
-(void)setHightlighted:(BOOL)aHighlighted;
@end
