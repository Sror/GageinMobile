//
//  GGCompanyDetailHeaderView.h
//  Gagein
//
//  Created by dong yiming on 13-4-19.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGCompanyDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *lblAction;

+(float)HEIGHT;
@end
