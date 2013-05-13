//
//  GGBaseViewController.m
//  Gagein
//
//  Created by dong yiming on 13-4-3.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGBaseViewController.h"
#import "GGNaviBackButton.h"
//#import "UINavigationBar+Custom.h"

#define MAX_NAVI_TITLE_LENGTH   20

@interface GGBaseViewController ()

@end

@implementation GGBaseViewController
{
    __weak MBProgressHUD *hud;
}

+(id)createInstance
{
    return [[self alloc] init];
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
    self.view.backgroundColor = GGSharedColor.bgGray;
	self.view.frame = [self viewportFrame];
    
    [self _customizeNaviTitleView];
    self.navigationItem.hidesBackButton = YES;
}

-(void)_customizeNaviTitleView
{
    _customNaviTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 310, 44)];
	_customNaviTitle.backgroundColor = [UIColor clearColor];
	_customNaviTitle.font = [UIFont boldSystemFontOfSize:16.0];
	_customNaviTitle.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	_customNaviTitle.textAlignment = UITextAlignmentCenter;
	_customNaviTitle.textColor = GGSharedColor.white;
    
    CGRect titleRc = CGRectMake(0, 0, 320, 44);
    UIView *titleView = [[UIView alloc] initWithFrame:titleRc];
    //titleView.backgroundColor = GGSharedColor.darkRed;
    [titleView addSubview:_customNaviTitle];
    
    self.navigationItem.titleView = titleView;
}

-(GGNaviBackButton *)__globalBackButton
{
    static GGNaviBackButton *__globalBackBtn;
    
    if (__globalBackBtn == nil)
    {
        UIImage *backBtnImage = [UIImage imageNamed:@"btnBackBg"];
        __globalBackBtn = [[GGNaviBackButton alloc] initWithFrame:CGRectMake(5, 10, backBtnImage.size.width, backBtnImage.size.height)];
    }
    
    return __globalBackBtn;
}


-(void)viewWillAppear:(BOOL)animated
{
    if (self.navigationController.viewControllers.count <= 1)
    {
        [self hideBackButton];
    }
    else
    {
        [self showBackButton];
    }
    
    if (self.navigationItem.leftBarButtonItem)
    {
        CGRect rc = _customNaviTitle.frame;
        _customNaviTitle.frame = CGRectMake(-50, rc.origin.y, rc.size.width, rc.size.height);
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self pushBackButtonFront];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (ISIPADDEVICE) {
        return YES;
    }
    
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - UI element
-(void)setNaviTitle:(NSString *)aNaviTitle
{
    if (aNaviTitle.length > MAX_NAVI_TITLE_LENGTH)
    {
        aNaviTitle = [NSString stringWithFormat:@"%@...", [aNaviTitle substringToIndex:MAX_NAVI_TITLE_LENGTH]];
    }
    self.navigationItem.title = aNaviTitle;
    self.customNaviTitle.text = aNaviTitle;
}

-(NSString *)naviTitle
{
    return self.customNaviTitle.text;
}

-(void)hideBackButton
{
    [[self __globalBackButton] removeFromSuperview];
}

-(void)showBackButton
{
    GGNaviBackButton *backBtn = [self __globalBackButton];
    [self.navigationController.navigationBar addSubview:backBtn];
    [backBtn removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(naviBackAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)pushBackButtonFront
{
    [self.navigationController.navigationBar bringSubviewToFront:[self __globalBackButton]];
}

-(void)installGageinLogo
{
    [self installGageinLogoTo:self.view];
}

-(void)installGageinLogoTo:(UIView *)aView
{
    if (aView)
    {
        UIImage *image = [UIImage imageNamed:@"gageinLogo"];
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
//        UIViewAutoresizingNone                 = 0,
//        UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
//        UIViewAutoresizingFlexibleWidth        = 1 << 1,
//        UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
//        UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
//        UIViewAutoresizingFlexibleHeight       = 1 << 4,
//        UIViewAutoresizingFlexibleBottomMargin = 1 << 5
        //iv.autoresizingMask = UIViewAutoresizingNone;
        CGRect rcScreen = [UIScreen mainScreen].applicationFrame;
        iv.frame = CGRectMake((rcScreen.size.width - image.size.width) / 2, 20, image.size.width, image.size.height);
        [aView addSubview:iv];
    }
}

-(void)installTopLine
{
    UIImage *image = [UIImage imageNamed:@"topOrangeLine"];
    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
    iv.contentMode = UIViewContentModeScaleToFill;
    iv.frame = CGRectMake(0, 0, self.view.frame.size.width, 4);
    [self.view addSubview:iv];
}

#pragma mark - actions
-(void)naviBackAction:(id)aSender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - layout
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

#define VIEW_PORT_ADJUSTION_Y   5
//unknown reason cause view a little hide at top, adjust using this method
-(CGRect)viewportAdjsted
{
    CGRect rc = self.view.bounds;
    rc.origin.y += VIEW_PORT_ADJUSTION_Y;
    rc.size.height -= VIEW_PORT_ADJUSTION_Y;
    
    return rc;
}

-(void)showLoadingHUD
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hide:YES];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
}

-(void)hideLoadingHUD
{
    [hud hide:YES];
}

-(void)showCheckMarkHUDWithText:(NSString *)aText
{
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    [self showHUDWithCustomView:iv text:aText];
}

- (void)showHUDWithCustomView:(UIView*)aCustomView text:(NSString *)aText
{
	MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.customView = aCustomView;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = aText;
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
	
	// The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
//	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
//	
//	// Set custom view mode
//	HUD.mode = MBProgressHUDModeCustomView;
//	
//	HUD.delegate = self;
//	HUD.labelText = @"Completed";
//	
//	[HUD show:YES];
//	[HUD hide:YES afterDelay:3];
}

@end
