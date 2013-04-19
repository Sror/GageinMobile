//
//  GGComDetailProfileCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-19.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGComDetailProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

+(float)HEIGHT;
@end
