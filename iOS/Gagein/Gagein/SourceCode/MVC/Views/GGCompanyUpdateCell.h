//
//  GGCompanyUpdateCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-7.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGAutosizingLabel.h"

@interface GGCompanyUpdateCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *logoIV;
@property (strong, nonatomic) IBOutlet UILabel *sourceLbl;
@property (strong, nonatomic) IBOutlet UILabel *intervalLbl;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
//@property (strong, nonatomic) IBOutlet UILabel *descriptionLbl;

@property (strong, nonatomic) IBOutlet UIView *viewCellBg;
@property (strong, nonatomic) IBOutlet UIImageView *ivCellBg;

@property (assign)  long long               ID;
@property (assign, nonatomic)  BOOL         hasBeenRead;

//+(float)HEIGHT;
-(void)showPicture:(BOOL)aShow;

-(float)adjustLayout;

+(float)heightForUpdate:(GGCompanyUpdate *)anUpdate;

@end
