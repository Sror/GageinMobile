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

@property (assign)  long long               companyID;
@property (assign)  long long               personID;
@property (strong)  GGTagetActionPair       *action;

-(void)setMessageCode:(GGApiParser *)anApiParser;
-(void)setMessageCode:(GGApiParser *)anApiParser vc:(GGBaseViewController *)aVc;
@end
