//
//  GGBaseViewController.h
//  Gagein
//
//  Created by dong yiming on 13-4-3.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GGBaseViewController : UIViewController
-(void)showLoadingHUD;
-(void)hideLoadingHUD;

-(void)installGageinLogo;
-(void)installGageinLogoTo:(UIView *)aView;
-(void)installTopLine;

// for overriding
-(void)naviBackAction:(id)aSender;
@end
