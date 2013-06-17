//
//  GGHappeningIpadCell.h
//  Gagein
//
//  Created by Dong Yiming on 6/15/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGHappening;

@interface GGHappeningIpadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivContentBg;
@property (weak, nonatomic) IBOutlet UILabel *lblSource;
@property (weak, nonatomic) IBOutlet UILabel *lblHeadline;

@property (weak, nonatomic) IBOutlet UILabel *lblInterval;
@property (weak, nonatomic) IBOutlet UIImageView *ivDblArrow;

@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property (weak, nonatomic) IBOutlet UIButton *btnLogo;
@property (weak, nonatomic) IBOutlet UIButton *btnHeadline;

@property (assign, nonatomic)  BOOL             hasBeenRead;

@property (assign, nonatomic) BOOL                  expanded;
@property (strong, nonatomic)   GGHappening     *data;

-(void)adjustLayout;
@end
