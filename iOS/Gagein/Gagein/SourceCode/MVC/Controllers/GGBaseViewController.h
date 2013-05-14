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
@property (strong) UILabel  *customNaviTitle;
@property (copy) NSString *naviTitle;

+(id)createInstance;

-(void)showLoadingHUD;
-(void)hideLoadingHUD;
-(void)showCheckMarkHUDWithText:(NSString *)aText;
- (void)showHUDWithCustomView:(UIView*)aCustomView text:(NSString *)aText;

-(void)installGageinLogo;
-(void)installGageinLogoTo:(UIView *)aView;
-(void)installTopLine;

-(void)showBackButton;
-(void)hideBackButton;
-(void)pushBackButtonFront;

// for overriding
-(void)naviBackAction:(id)aSender;

//unknown reason cause view a little hide at top, adjust using this method
-(CGRect)viewportAdjsted;

-(void)viewWillAppearNotFirstTimeAction;

-(void)blockUI;
-(void)unblockUI;

@end
