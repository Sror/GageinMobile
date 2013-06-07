//
//  GGBaseViewController.m
//  Gagein
//
//  Created by dong yiming on 13-4-3.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGBaseViewController.h"
#import "GGNaviBackButton.h"
#import "GGSalesforceOAuthVC.h"
#import "GGLinkedInOAuthVC.h"

#import "GGTwitterOAuthVC.h"
#import "GGFacebookOAuther.h"
#import "GGImageVC.h"

#import "GGFollowCompanyVC.h"
#import "GGFollowPeopleVC.h"
#import "GGSelectAgentsVC.h"
#import "GGSelectFuncAreasVC.h"
#import "GGAppDelegate.h"
#import "GGFacebookAuthVC.h"

#define MAX_NAVI_TITLE_LENGTH   20

@interface GGBaseViewController ()

@end

@implementation GGBaseViewController
{
    __weak MBProgressHUD        *hud;
    BOOL                        _isViewFirstAppear;
    UIView                      *_transparentBlockView;
    
    GGLinkedInOAuthVC          *_oAuthLoginView;
    GGFacebookOAuther          *_facebookOAuther;
    
    NSMutableSet              *_apiOperations;
    //GGFacebookAuthVC            *_facebookAuthVC;
    
    BOOL                        _isMenuShowingBeforeLeavePortrait;
}

#pragma mark - api operation management
-(void)registerOperation:(id)anOperation
{    
    if (anOperation)
    {
        NSAssert([anOperation isKindOfClass:[AFHTTPRequestOperation class]], @"an operation should be a AFHTTPRequestOperation");
        
        [_apiOperations addObject:anOperation];
        
        //DLog(@"\n\n api operation registered\n path:%@", ((AFHTTPRequestOperation *)anOperation).request.URL.relativeString);
    }
}

-(void)unregisterOperation:(id)anOperation
{
    if (anOperation)
    {
        NSAssert([anOperation isKindOfClass:[AFHTTPRequestOperation class]], @"an operation should be a AFHTTPRequestOperation");
        
        [_apiOperations removeObject:anOperation];
        
        //DLog(@"\n\n api operation unregistered\n path:%@", ((AFHTTPRequestOperation *)anOperation).request.URL.relativeString);
    }
}

#pragma mark - handle notification
-(void)handleNotification:(NSNotification *)notification
{
    NSString *notiName = notification.name;
    //DLog(@"recieved nitification: %@", notiName);
    
    id notiObj = notification.object;
    
    if ([notiName isEqualToString:GG_NOTIFY_API_OPERATION_SUCCESS]
        || [notiName isEqualToString:GG_NOTIFY_API_OPERATION_FAILED])
    {
        [self unregisterOperation:notiObj];
        //DLog(@"\n\n api operation Success\n path:%@", ((AFHTTPRequestOperation *)notiObj).request.URL.relativeString);
    }
    else if ([notiName isEqualToString:GG_NOTIFY_HIDE_ALL_LOADING_HUD])
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}

#pragma mark - view & memory management
+(id)createInstance
{
    return [[self alloc] init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _apiOperations = [NSMutableSet set];
    }
    return self;
}

- (void)viewDidLoad
{
    [self observeNotification:GG_NOTIFY_API_OPERATION_SUCCESS];
    [self observeNotification:GG_NOTIFY_API_OPERATION_FAILED];
    [self observeNotification:GG_NOTIFY_HIDE_ALL_LOADING_HUD];
    
    [super viewDidLoad];
    _isViewFirstAppear = YES;
    
    self.view.backgroundColor = GGSharedColor.bgGray;
	self.view.frame = [self viewportFrame];
    
    _transparentBlockView = [[UIView alloc] initWithFrame:self.view.bounds];
    _transparentBlockView.backgroundColor = GGSharedColor.clear;
    
    [self _customizeNaviTitleView];
    self.navigationItem.hidesBackButton = YES;
}

-(void)_customizeNaviTitleView
{
    CGRect orientRc = [GGLayout frameWithOrientation:[UIApplication sharedApplication].statusBarOrientation rect:[UIScreen mainScreen].bounds];
    
    _customNaviTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, orientRc.size.width, 44)];
	_customNaviTitle.backgroundColor = [UIColor clearColor];
	_customNaviTitle.font = [UIFont boldSystemFontOfSize:16.0];
	_customNaviTitle.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	_customNaviTitle.textAlignment = UITextAlignmentCenter;
	_customNaviTitle.textColor = GGSharedColor.white;
    
    //
    CGRect titleRc = CGRectMake(0, 0, orientRc.size.width, 44);
    UIView *titleView = [[UIView alloc] initWithFrame:titleRc];
    [titleView addSubview:_customNaviTitle];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    self.navigationItem.titleView = titleView;
    
    // for debug...
//    _customNaviTitle.backgroundColor = GGSharedColor.orange;
//    titleView.backgroundColor = GGSharedColor.darkRed;
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
    // custom back button
    if (self.navigationController.viewControllers.count <= 1)
    {
        [self hideBackButton];
    }
    else
    {
        [self showBackButton];
    }
    
    // adjust custom navi title position
    [self _adjustCustomNaviTitlePosition];
    
    // custom left navi button
    if (_naviButtonLeft)
    {
        [self hideBackButton];
        [self.navigationController.navigationBar addSubview:_naviButtonLeft];
    }
    
    
    // first time run judgement
    if (_isViewFirstAppear)
    {
        _isViewFirstAppear = NO;
    }
    else
    {
        [self viewWillAppearNotFirstTimeAction];
    }
    
    [self layoutUIForIPadIfNeeded];
}

-(void)viewWillAppearNotFirstTimeAction
{
    // sub class implementation
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self pushBackButtonFront];
    
    [self _adjustCustomNaviTitlePosition];
}

-(void)dealloc
{
    [self unobserveAllNotifications];
    
    for (AFHTTPRequestOperation *operation in _apiOperations)
    {
        [operation cancel];
        //DLog(@"\n\n api operation cancelled\n path:%@", operation.request.URL.relativeString);
    }
}

-(void)_adjustCustomNaviTitlePosition
{
    CGRect titleViewRc = self.navigationItem.titleView.frame;
    CGRect customNaviRc = _customNaviTitle.frame;
    customNaviRc.origin.x = -titleViewRc.origin.x;
    _customNaviTitle.frame = customNaviRc;
}

#pragma mark - orientation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (ISIPADDEVICE)
    {
        return YES;
    }
    
    return toInterfaceOrientation == UIInterfaceOrientationPortrait; // etc
}

- (BOOL)shouldAutorotate {
    
    if (ISIPADDEVICE)
    {
        return YES;
    }
    
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    if (ISIPADDEVICE)
    {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskPortrait; // etc
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
        UIImage *image = (ISIPADDEVICE) ? [UIImage imageNamed:@"pad_gageinLogo"] : [UIImage imageNamed:@"gageinLogo"];
        
        [_ivGageinLogo removeFromSuperview];
        _ivGageinLogo = [[UIImageView alloc] initWithImage:image];
        [aView addSubview:_ivGageinLogo];
        
        _ivGageinLogo.frame = CGRectMake((aView.frame.size.width - _ivGageinLogo.image.size.width) / 2
                                         , 20
                                         , _ivGageinLogo.image.size.width
                                         , _ivGageinLogo.image.size.height);
        
        [self layoutUIForIPadIfNeeded];
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
    NSArray *controllers = self.navigationController.viewControllers;
    NSUInteger thisIndex = controllers.count - 1;
    for (int i = thisIndex; i >= 0; i --)
    {
        if (controllers[i] == self)
        {
            thisIndex = i;
            break;
        }
    }
    
    if (thisIndex > 0)
    {
        UIViewController *vc = controllers[thisIndex - 1];
        [self.navigationController popToViewController:vc animated:YES];
    }
}

-(void)dismissAction:(id)aSender
{
    UIViewController *vc = self.parentViewController;
    [vc dismissViewControllerAnimated:YES completion:nil];
}

-(void)presentImageWithURL:(NSString *)anImageURL
{
    if (anImageURL)
    {
        GGImageVC *vc = [[GGImageVC alloc] init];
        vc.imageUrl = anImageURL;
        // vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //vc.modalInPopover = YES;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
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
    //hud.dimBackground = YES;
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
}

-(void)blockUI
{
    [self.view addSubview:_transparentBlockView];
}

-(void)unblockUI
{
    [_transparentBlockView removeFromSuperview];
}

#pragma mark - 
-(void)connectSalesForce
{
    //[GGAlert alert:@"Connect to Salesforce (TODO)"];
    GGSalesforceOAuthVC *vc = [[GGSalesforceOAuthVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)connectLinkedIn
{
    _oAuthLoginView = [[GGLinkedInOAuthVC alloc] initWithNibName:nil bundle:nil];
    [self observeNotification:OA_NOTIFY_LINKEDIN_AUTH_OK];
    [self.navigationController pushViewController:_oAuthLoginView animated:YES];
}

-(void)connectFacebookRead
{
    _facebookOAuther = [[GGFacebookOAuther alloc] init];
    [_facebookOAuther authReadPermission];
    
    //_facebookAuthVC = [[GGFacebookAuthVC alloc] init];
    //[self presentViewController:_facebookAuthVC animated:NO completion:nil];
}

-(void)connectFacebookReadAndPublish
{
    _facebookOAuther = [[GGFacebookOAuther alloc] init];
    [_facebookOAuther authReadAndPublishPermission];
}

-(void)connectTwitter
{
    GGTwitterOAuthVC *vc = [[GGTwitterOAuthVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(GGLinkedInOAuthVC *)linkedInAuthView
{
    return _oAuthLoginView;
}

#pragma mark - config & exploring actions
-(void)enterFollowCompaniesAction
{
    GGFollowCompanyVC *vc = [[GGFollowCompanyVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)enterFollowPeopleAction
{
    GGFollowPeopleVC *vc = [[GGFollowPeopleVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)enterSelectAgentsAction
{
    GGSelectAgentsVC *vc = [[GGSelectAgentsVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)enterSelectFunctionalAreasAction
{
    GGSelectFuncAreasVC *vc = [[GGSelectFuncAreasVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lay out for ipad
-(void)layoutUIForIPadIfNeeded
{
    [self layoutUIForIPadIfNeededWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

-(void)layoutUIForIPadIfNeededWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // do not overwrite
    if (ISIPADDEVICE)
    {
        [self doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    }
}

-(CGRect)frameOrientated
{
    return [GGLayout frameWithOrientation:[UIApplication sharedApplication].statusBarOrientation rect:self.view.frame];
}

-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [GGSharedDelegate doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    CGRect naviRc = [GGLayout frameWithOrientation:toInterfaceOrientation rect:self.navigationController.view.frame];
    _customNaviTitle.frame = CGRectMake(0, 5, naviRc.size.width, 44);
    
    _ivGageinLogo.frame = CGRectMake((naviRc.size.width - _ivGageinLogo.image.size.width) / 2
                                     , 100
                                     , _ivGageinLogo.image.size.width
                                     , _ivGageinLogo.image.size.height);
    
    //
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
            [GGSharedDelegate.rootVC cover];
    }
    else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        [self freezeMe:NO];
        
        if ([self needMenu])
        {
            [GGSharedDelegate.rootVC reveal];
        }
        else
        {
            [GGSharedDelegate.rootVC cover];
        }
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    DLog(@"will change orientation to: %d", toInterfaceOrientation);
    
    if ([self isPortrait])
    {
        _isMenuShowingBeforeLeavePortrait = GGSharedDelegate.rootVC.isRevealed;
    }
    
    [self layoutUIForIPadIfNeededWithOrientation:toInterfaceOrientation];
}

-(BOOL)isPortrait
{
    return UIInterfaceOrientationIsPortrait(self.interfaceOrientation);
}

-(BOOL)isIPadLandscape
{
    return ISIPADDEVICE && ![self isPortrait];
}

-(void)freezeMe:(BOOL)aFreeze
{
    self.view.userInteractionEnabled = !aFreeze;
}

-(void)setNeedMenu:(BOOL)aNeedMenu
{
    GGSharedDelegate.rootVC.needMenu = aNeedMenu;
}

-(BOOL)needMenu
{
    return GGSharedDelegate.rootVC.needMenu;
}

@end
