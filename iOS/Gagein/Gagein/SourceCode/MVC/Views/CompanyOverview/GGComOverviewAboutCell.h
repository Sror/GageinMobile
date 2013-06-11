//
//  GGComOverviewAboutCell.h
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGComOverviewAboutCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivCellBg;


//+(float)HEIGHT;
//-(void)adjustLayout;
-(float)height;

-(void)setTextViewText:(NSString *)aText;

@end
