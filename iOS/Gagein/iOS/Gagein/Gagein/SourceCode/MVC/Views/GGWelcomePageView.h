//
//  GGWelcomePageView.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGWelcomePageView : UIView
@property (weak, nonatomic) IBOutlet UIView *page1;
@property (weak, nonatomic) IBOutlet UIView *page2;
@property (weak, nonatomic) IBOutlet UIView *page3;
@property (weak, nonatomic) IBOutlet UIView *page4;
@property (weak, nonatomic) IBOutlet UIButton *getStartedBtn;

-(void)showPageWithIndex:(NSUInteger)aIndex;

-(IBAction)getStartedAction:(id)sender;

@end
