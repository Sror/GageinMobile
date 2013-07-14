//
//  GGCompanySearchCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-10.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSearchSuggestionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblWebsite;
@property (weak, nonatomic) IBOutlet UIImageView *ivMark;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;

+(float)HEIGHT;

-(void)showMarkDiscolsure;
-(void)showMarkPlus;
-(void)showMarkCheck;

@end
