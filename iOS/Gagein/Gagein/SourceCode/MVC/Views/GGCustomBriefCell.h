//
//  GGPersonCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kGGCustomBriefCellCompany = 0
    , kGGCustomBriefCellPerson
}EGGCustomBriefCellType;

@interface GGCustomBriefCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivCellBg;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

@property (assign, nonatomic) EGGCustomBriefCellType    type;

+(float)HEIGHT;

-(void)loadLogoWithImageUrl:(NSString *)aImageUrl placeholder:(UIImage *)aPlaceHolder;

-(void)grayoutTitle:(BOOL)aGrayout;

@end
