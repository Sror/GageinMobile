//
//  GGUpdateInfoHeaderView.h
//  Gagein
//
//  Created by Dong Yiming on 7/1/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGUpdateInfoHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *viewCellBg;
@property (weak, nonatomic) IBOutlet UIImageView *ivCellBg;
@property (weak, nonatomic) IBOutlet UILabel *lblInterval;
@property (weak, nonatomic) IBOutlet UILabel *lblSource;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


-(void)doLayout;

@end
