//
//  GGBaseViewController.m
//  Gagein
//
//  Created by dong yiming on 13-4-3.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGBaseViewController.h"
#import "GGNaviBackButton.h"

@interface GGBaseViewController ()

@end

@implementation GGBaseViewController
{
    __weak MBProgressHUD *hud;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.frame = [self viewportFrame];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bgNavibar"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backBtnImage = [UIImage imageNamed:@"btnBackBg"];
    GGNaviBackButton *backBtn = [[GGNaviBackButton alloc] initWithFrame:CGRectMake(5, 10, backBtnImage.size.width, backBtnImage.size.height)];
    [backBtn addTarget:self action:@selector(naviBackAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar addSubview:backBtn];
    
    CGRect navibarRc = self.navigationController.navigationBar.frame;
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
}

-(void)naviBackAction:(id)aSender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGRect)viewportFrame
{
    CGRect viewPortFrame = [UIScreen mainScreen].applicationFrame;
    if (self.navigationController && !self.navigationController.navigationBarHidden) {
        viewPortFrame.size.height -= self.navigationController.navigationBar.frame.size.height;
    }
    if (self.tabBarController && !self.tabBarController.tabBar.hidden) {
        viewPortFrame.size.height -= self.tabBarController.tabBar.frame.size.height;
    }
    
    return viewPortFrame;
}

-(void)showLoadingHUD
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
}

-(void)hideLoadingHUD
{
    [hud hide:YES];
}

@end
