//
//  GGComDetailEmployeeCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-19.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGComDetailEmployeeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewCellBg;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblThirdLine;

@property (weak, nonatomic) IBOutlet UIImageView *ivMark;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;


+(float)HEIGHT;

-(void)grayoutTitle:(BOOL)aGrayoutTitle;


-(void)showMarkDiscolsure;
-(void)showMarkPlus;
-(void)showMarkCheck;

@end
