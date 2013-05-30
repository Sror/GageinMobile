//
//  GGEmptyActionView.h
//  Gagein
//
//  Created by dong yiming on 13-5-10.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGEmptyActionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;
@property (weak, nonatomic) IBOutlet UIView *viewSimple;
@property (weak, nonatomic) IBOutlet UILabel *lblSimpleMessage;

-(void)setMessageCode:(EGGMessageCode)aMessageCode;
@end
