//
//  GGGroupedCell.h
//  Gagein
//
//  Created by Dong Yiming on 5/15/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kGGGroupCellFirst = 0
    , kGGGroupCellMiddle
    , kGGGroupCellLast
    , kGGGroupCellRound
}EGGGroupedCellStyle;

@interface GGGroupedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ivBg;
@property (weak, nonatomic) IBOutlet UIImageView *ivDot;
@property (assign, nonatomic) EGGGroupedCellStyle  style;
@property (assign, nonatomic) BOOL  checked;

+(float)HEIGHT;
@end
