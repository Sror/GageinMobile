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
#import "GGConfigFiltersVC.h"

#import "WEPopoverController.h"

#import "GGSsgrfActionListener.h"
#import "GGPersonDetailVC.h"
#import "GGCompanyDetailVC.h"

#import "GGSsgrfPopPanelComInfoView.h"
#import "GGSsgrfPopPanelPersonInfoView.h"
#import "GGCompanyEmployeesVC.h"
#import "GGConfigAgentFiltersVC.h"

#import "GGWebVC.h"
#import "CMActionSheet.h"
#import "GGCompanyUpdate.h"
#import "GGSnShareVC.h"
#import "GGHappening.h"

#import "GGEmployerComsVC.h"
#import "GGPerson.h"
#import "GGMember.h"

#import "MMDrawerController.h"

#import <FacebookSDK/FacebookSDK.h>

#define MAX_NAVI_TITLE_LENGTH           20
#define MAX_NAVI_TITLE_LENGTH_IPAD      50

@interface GGBaseViewController () <GGSsgrfActionDelegate>

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
    
    WEPopoverController         *_popoverController;
    
    GGSsgrfPopPanelView         *_viewPopup;
    
    GGCompanyUpdate                          *_dataForSignal;
    GGCompanyUpdate                          *_updateForSharing;
    GGHappening                              *_happeningForSharing;
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
    
    
    //[self _customizeNaviTitleView];
    
    
//    if (!ISIPADDEVICE)
//    {
//        [self _customizeNaviTitleView];
//    }
//    else
//    {
//        self.navigationItem.title
//    }
//    
    self.navigationItem.hidesBackButton = YES;
    
}

-(void)_customizeNaviTitleView
{
    CGRect orientRc = [GGLayout frameWithOrientation:[UIApplication sharedApplication].statusBarOrientation rect:self.navigationController.view.bounds];
    
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

-(BOOL)doNeedMenu
{
    //DLog(@"%@ need menu.", NSStringFromClass([self class]));
    return NO;
}

-(void)_checkNeedMenuAndLayout
{
    //[self setNeedMenu:[self doNeedMenu]];
    
    [self layoutUIForIPadIfNeeded];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self _checkNeedMenuAndLayout];
    
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
    
    _viewPopup.hidden = NO;
    
    if (ISIPADDEVICE && self.presentedViewController == nil)
    {
        [GGSharedDelegate.drawerVC adjustCenterRect];
    }
    
    if (self.presentingViewController == nil)
    {
        [self _decideCanPanToOpenDrawerWithOrient:self.interfaceOrientation];
    }
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
    //DLog(@"%@: viewDidAppear", self.className);
    if ([self canHearAction])
    {
        [GGSsgrfActionListener sharedInstance].delegate = self;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //DLog(@"%@: viewWillDisappear", self.className);
    if ([self canHearAction])
    {
        [GGSsgrfActionListener sharedInstance].delegate = nil;
    }
}

-(BOOL)canHearAction
{
    //DLog(@"%@", self.className);
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _viewPopup.hidden = YES;
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
    return [GGOrientation shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate
{
    return [GGOrientation shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return [GGOrientation supportedInterfaceOrientations];
}

#pragma mark - UI element
-(void)setNaviTitle:(NSString *)aNaviTitle
{
    int maxLength = ISIPADDEVICE ? MAX_NAVI_TITLE_LENGTH_IPAD : MAX_NAVI_TITLE_LENGTH;
    if (aNaviTitle.length > maxLength)
    {
        aNaviTitle = [NSString stringWithFormat:@"%@...", [aNaviTitle substringToIndex:maxLength]];
    }
    self.navigationItem.title = aNaviTitle;
    self.customNaviTitle.text = aNaviTitle;
    _naviStringRecord = aNaviTitle;
}

-(NSString *)naviTitle
{
    return _naviStringRecord; //self.navigationItem.title;//self.customNaviTitle.text;
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

#pragma mark - screen migration

-(void)enterPersonDetailWithSender:(id)sender
{
    long long ID = [((UIView *)sender).tagNumber longLongValue];
    
    [self enterPersonDetailWithID:ID];
}

-(void)enterPersonDetailWithID:(long long)aPersonID
{
    GGPersonDetailVC *vc = [[GGPersonDetailVC alloc] init];
    vc.personID = aPersonID;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)enterCompanyDetailWithID:(long long)aCompanyID
{
    if (aCompanyID > 0)
    {
        GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
        vc.companyID = aCompanyID;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)enterEmployeesListWithID:(long long)aCompanyID
{
    GGCompanyEmployeesVC *vc = [[GGCompanyEmployeesVC alloc] init];
    vc.companyID = aCompanyID;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - actions
-(void)naviBackAction:(id)aSender
{
    if ([self isPresentedModally])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
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
    [hud hide:YES];
    hud = [GGAlert showLoadingHUDInView:self.view];
}

-(void)showLoadingHUDWithOffsetY:(float)aOffsetY
{
    [hud hide:YES];
    hud = [GGAlert showLoadingHUDWithOffsetY:aOffsetY inView:self.view];
}

-(void)showLoadingHUDWithTitle:(NSString *)aTitle
{
    [hud hide:YES];
    hud = [GGAlert showLoadingHUDWithTitle:aTitle inView:self.view];
}

-(void)showLoadingHUDWithText:(NSString *)aText
{
    [hud hide:YES];
    hud = [GGAlert showLoadingHUDWithMessage:aText inView:self.view];
}

-(void)hideLoadingHUD
{
    [hud hide:YES];
}

-(void)showCheckMarkHUDWithText:(NSString *)aText
{
    [GGAlert showCheckMarkHUDWithText:aText inView:self.view];
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
    [self popSheetInNaviForVC:vc];
}

-(void)connectLinkedIn
{
    _oAuthLoginView = [[GGLinkedInOAuthVC alloc] initWithNibName:nil bundle:nil];
    [self observeNotification:OA_NOTIFY_LINKEDIN_AUTH_OK];
    [self popSheetInNaviForVC:_oAuthLoginView];
    //[self.navigationController pushViewController:_oAuthLoginView animated:YES];
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
    [self popSheetInNaviForVC:vc];
}

-(GGLinkedInOAuthVC *)linkedInAuthView
{
    return _oAuthLoginView;
}

#pragma mark - config & exploring actions
-(void)presentPageFollowCompanies
{
    GGFollowCompanyVC *vc = [[GGFollowCompanyVC alloc] init];
    [self popSheetInNaviForVC:vc];
    //[self.navigationController pushViewController:vc animated:YES];
}

-(void)presentPageFollowPeople
{
    GGFollowPeopleVC *vc = [[GGFollowPeopleVC alloc] init];
    [self popSheetInNaviForVC:vc];
}

-(void)presentPageSelectAgents
{
    GGConfigAgentFiltersVC *vc = [[GGConfigAgentFiltersVC alloc] init];
    
    //UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    if (ISIPADDEVICE)
    {
        [self popSheetInNaviForVC:vc];
    }
    else
    {
        [self presentInNaviWithVC:vc];
    }
}

-(void)presentPageConfigFilters
{
    GGConfigFiltersVC *vc = [[GGConfigFiltersVC alloc] init];

    //UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    if (ISIPADDEVICE)
    {
        [self popSheetInNaviForVC:vc];
    }
    else
    {
        [self presentInNaviWithVC:vc];
    }
}

-(void)presentPageSelectFuncArea
{
    GGSelectFuncAreasVC *vc = [[GGSelectFuncAreasVC alloc] init];
    
    //UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    if (ISIPADDEVICE)
    {
        [self popSheetInNaviForVC:vc];
    }
    else
    {
        [self presentInNaviWithVC:vc];
    }
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
    if (self.presentingViewController == nil)
    {
        [GGSharedDelegate.drawerVC _adjustCenterRectWithOrient:toInterfaceOrientation];
        
        [GGSharedDelegate doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    }
    
    
    
    
    CGRect naviRc = [self isPresentedModally] ? self.navigationController.view.frame : [GGLayout frameWithOrientation:toInterfaceOrientation rect:self.navigationController.view.frame];
    _customNaviTitle.frame = CGRectMake(0, 5, naviRc.size.width, 44);
    
    _ivGageinLogo.frame = CGRectMake((naviRc.size.width - _ivGageinLogo.image.size.width) / 2
                                     , 100
                                     , _ivGageinLogo.image.size.width
                                     , _ivGageinLogo.image.size.height);
    
    [_viewPopup handleOrientChange:toInterfaceOrientation];
    
    //
    if (self.presentingViewController == nil)
    {
        if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
        {
            [GGSharedDelegate.drawerVC closeDrawerAnimated:NO completion:nil];
        }
        else //if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
            
            [self freezeMe:NO];
            
            if ([self doNeedMenu])
            {
                [GGSharedDelegate.drawerVC openDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
            }
            else
            {
                [GGSharedDelegate.drawerVC closeDrawerAnimated:NO completion:nil];
            }
        }
        
        [self _decideCanPanToOpenDrawerWithOrient:toInterfaceOrientation];
    }
    
    [GGSsgrfActionListener sharedInstance].delegate = GGSharedDelegate.topMostVC;
}

-(void)_decideCanPanToOpenDrawerWithOrient:(UIInterfaceOrientation)anOrient
{
    if (UIInterfaceOrientationIsPortrait(anOrient) && self.doNeedMenu)
    {
        GGSharedDelegate.drawerVC.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
        GGSharedDelegate.drawerVC.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
        GGSharedDelegate.drawerVC.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeNavigationBarOnly;
    }
    else
    {
        GGSharedDelegate.drawerVC.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
        GGSharedDelegate.drawerVC.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
        GGSharedDelegate.drawerVC.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeFull;
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    DLog(@"will change orientation to: %d", toInterfaceOrientation);
    
    if ([self isPortrait])
    {
        _isMenuShowingBeforeLeavePortrait = (GGSharedDelegate.drawerVC.openSide != MMDrawerSideNone);
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

//-(void)setNeedMenu:(BOOL)aNeedMenu
//{
//    //GGSharedDelegate.rootVC.needMenu = aNeedMenu;
//    
//}

-(BOOL)needMenu
{
    //return GGSharedDelegate.rootVC.needMenu;
    return NO;
}


#pragma mark - navi or modal
-(BOOL)isTheRootOfNaviStack
{
    return self.navigationController.viewControllers.count
    && self.navigationController.viewControllers[0] == self;
}

-(BOOL)isTheTopOfNaviStack
{
    return self.navigationController.viewControllers.count
    && self.navigationController.viewControllers.lastObject == self;
}

-(BOOL)isPresentedModally
{

    UIViewController *modalVC = self.presentingViewController.modalViewController;
    
    return modalVC
    && (modalVC == self ||
        (modalVC == self.navigationController && [self isTheRootOfNaviStack]));
}

#pragma mark -
//-(void)popVC:(UIViewController *)aViewController fromRect:(CGRect)aRect
//{
//#warning XXX:Not Finish Yet
//    if (aViewController)
//    {
//        [_popoverController dismissPopoverAnimated:YES];
//        _popoverController = [[WEPopoverController alloc] initWithContentViewController:aViewController];
//        [_popoverController presentPopoverFromRect:aRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    }
//}


-(void)popSheetInNaviForVC:(UIViewController *)aViewController
{
    if (aViewController)
    {
        GGNavigationController *nv = [[GGNavigationController alloc] initWithRootViewController:aViewController];
        [self popSheetForVC:nv];
    }
}

-(void)presentInNaviWithVC:(UIViewController *)aViewController
{
    if (aViewController)
    {
        GGNavigationController *nv = [[GGNavigationController alloc] initWithRootViewController:aViewController];
        nv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nv animated:YES completion:nil];
    }
}

-(void)popSheetForVC:(UIViewController *)aViewController
{
    if (aViewController)
    {
        if ([aViewController isKindOfClass:[UINavigationController class]])
        {
            [((UINavigationController *)aViewController).navigationBar setBackgroundImage:[UIImage imageNamed:@"bgNavibarNoTop"] forBarMetrics:UIBarMetricsDefault];
        }
        
        aViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        aViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:aViewController animated:YES completion:nil];
    }
}

-(void)presentMapUrl:(NSString *)aMapURL
{
    CGSize chartSize = [UIScreen mainScreen].applicationFrame.size;
    float width = MAX(chartSize.width, chartSize.height);
    float height = MIN(chartSize.width, chartSize.height);
    NSString *chartUrl = [GGUtils stringWithMapUrl:aMapURL width:width height:height];
    
    [self presentImageWithURL:chartUrl];
}

-(void)presentChartUrl:(NSString *)aChartURL
{
    CGSize chartSize = [UIScreen mainScreen].applicationFrame.size;
    float width = MAX(chartSize.width, chartSize.height);
    float height = MIN(chartSize.width, chartSize.height);
    NSString *chartUrl = [GGUtils stringWithChartUrl:aChartURL width:width height:height];
    
    [self presentImageWithURL:chartUrl];
}

-(void)naviWithCurrentUser:(GGMember *)aCurrentUser
{
    if (aCurrentUser)
    {
        GGSharedRuntimeData.currentUser = aCurrentUser;
        [GGSharedRuntimeData saveCurrentUser];
        
        if (aCurrentUser.isSignupOK)
        {
            // go home
            [self dismissViewControllerAnimated:NO completion:nil];
            [GGSharedDelegate popNaviToRoot];
            [GGSharedDelegate showTabIndex:0];
            [self postNotification:GG_NOTIFY_LOG_IN];
        }
        else if (aCurrentUser.signupProcessStatus == kGGSignupProcessAgentsSelect)
        {
            // go to Agents select
            GGSelectAgentsVC *vc = [[GGSelectAgentsVC alloc] init];
            vc.isFromRegistration = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (aCurrentUser.signupProcessStatus == kGGSignupProcessAreasSelect)
        {
            // go to areas select
            GGSelectFuncAreasVC *vc = [[GGSelectFuncAreasVC alloc] init];
            vc.isFromRegistration = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - GGSsgrfActionDelegate

-(void)ssGraphShowPersonPanel:(NSNumber *)aPersonID
{
    DLog(@"ssGraphShowPersonPanel:%@", aPersonID);
    
    GGSsgrfPopPanelPersonInfoView *popUp = [[GGSsgrfPopPanelPersonInfoView alloc] initWithView:GGSharedDelegate.drawerVC.view];
    [popUp updateWithPersonID:aPersonID];
    
    //
    [_viewPopup removeFromSuperview];
    _viewPopup = popUp;
    [_viewPopup showMe];
}

-(void)ssGraphShowCompanyPanel:(GGCompany *)aCompany
{
    DLog(@"ssGraphShowCompanyPanel:%@", aCompany);

    GGSsgrfPopPanelComInfoView *popUp = [[GGSsgrfPopPanelComInfoView alloc] initWithView:GGSharedDelegate.drawerVC.view];
    [popUp updateWithCompany:aCompany];
    //
    [_viewPopup removeFromSuperview];
    _viewPopup = popUp;
    [_viewPopup showMe];
}

-(void)ssGraphShowPersonLandingPage:(NSNumber *)aPersonID
{
    DLog(@"ssGraphShowPersonLandingPage:%@", aPersonID);
    
    [self enterPersonDetailWithID:[aPersonID longLongValue]];
}

-(void)ssGraphShowCompanyLandingPage:(NSNumber *)aCompanyID
{
    DLog(@"ssGraphShowCompanyLandingPage:%@", aCompanyID);
    [self enterCompanyDetailWithID:[aCompanyID longLongValue]];
}

-(void)ssGraphShowEmployeeListPage:(NSNumber *)aCompanyID
{
    DLog(@"ssGraphShowEmployeeListPage:%@", aCompanyID);
    
    [self enterEmployeesListWithID:[aCompanyID longLongValue]];
}

-(void)ssGraphShowEmployerListPage:(GGPerson *)aPerson
{
    DLog(@"ssGraphShowEmployerListPage:%@", aPerson);
    GGEmployerComsVC *vc = [[GGEmployerComsVC alloc] init];
    vc.companies = aPerson.prevCompanies;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)ssGraphShowWebPage:(NSString *)aURL
{
    DLog(@"ssGraphShowWebPage:%@", aURL);
    GGWebVC *vc = [[GGWebVC alloc] init];
    vc.urlStr = aURL;
    GGNavigationController *nc = [[GGNavigationController alloc] initWithRootViewController:vc];
    
    nc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:nc animated:YES completion:nil];
}

-(void)ssGraphFollowPerson:(NSNumber *)aPersonID
{
    DLog(@"ssGraphFollowPerson:%@", aPersonID);
}

-(void)ssGraphUnfollowPerson:(NSNumber *)aPersonID
{
    DLog(@"ssGraphUnfollowPerson:%@", aPersonID);
}

-(void)ssGraphFollowCompany:(NSNumber *)aCompanyID
{
    DLog(@"ssGraphFollowCompany:%@", aCompanyID);
}

-(void)ssGraphUnfollowCompany:(NSNumber *)aCompanyID
{
    DLog(@"ssGraphUnfollowCompany:%@", aCompanyID);
}

-(void)ssGraphSignal:(id)aData
{
    DLog(@"ssGraphSignal:%@", aData);
    _dataForSignal = aData;
    [self _showSheetToSignal];
}

-(void)ssGraphLike:(NSNumber *)aUpdateID
{
    DLog(@"ssGraphLike:%@", aUpdateID);
}

-(void)ssGraphUnLike:(NSNumber *)aUpdateID
{
    DLog(@"ssGraphUnLike:%@", aUpdateID);
}

-(void)ssGraphSave:(NSNumber *)aUpdateID
{
    DLog(@"ssGraphSave:%@", aUpdateID);
}

-(void)ssGraphUnSave:(NSNumber *)aUpdateID
{
    DLog(@"ssGraphUnSave:%@", aUpdateID);
}

-(void)ssGraphShare:(id)aData
{
    DLog(@"ssGraphShare:%@", aData);
    if ([aData isKindOfClass:[GGCompanyUpdate class]])
    {
        _updateForSharing = aData;
        _happeningForSharing = nil;
        [self _showSheetToShare:YES];
    }
    else if ([aData isKindOfClass:[GGHappening class]])
    {
        _happeningForSharing = aData;
        _updateForSharing = nil;
        [self _showSheetToShare:NO];
    }
}

-(void)ssGraphShowImageURL:(NSString *)aImageURL
{
    DLog(@"ssGraphShowImageURL:%@", aImageURL);
    
    [self presentImageWithURL:aImageURL];
}

-(void)ssGraphShowMapImageURL:(NSString *)aImageURL
{
    DLog(@"ssGraphShowImageURL:%@", aImageURL);
    
    [self presentMapUrl:aImageURL];
}

-(void)ssGraphShowChartImageURL:(NSString *)aImageURL
{
    DLog(@"ssGraphShowImageURL:%@", aImageURL);
    
    [self presentChartUrl:aImageURL];
}

#pragma mark - 
-(void)_showSheetToSignal
{
    CMActionSheet *actionSheet = [[CMActionSheet alloc] init];
    actionSheet.title = @"Signal";
    
    UIImage *bgImg = nil;
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];
    [actionSheet addButtonWithTitle:@"Twitter" bgImage:bgImg block:^{
        //DLog(@"Signal to Twitter.");
        [self ssGraphShowWebPage:_dataForSignal.twitterTweets];
    }];
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];
    [actionSheet addButtonWithTitle:@"LinkedIn" bgImage:bgImg block:^{
        //DLog(@"Signal to LinkedIn.");
        [self ssGraphShowWebPage:_dataForSignal.linkedInSignal];
    }];
    
    bgImg = [UIImage imageNamed:@"grayBtnBg"];
    UIButton *cancelBtn = [actionSheet addButtonWithTitle:@"Cancel" bgImage:bgImg block:^{
        
    }];
    [cancelBtn setTitleColor:GGSharedColor.white forState:UIControlStateNormal];
    [cancelBtn setTitleShadowColor:GGSharedColor.black forState:UIControlStateNormal];
    
    
    //    [actionSheet addSeparator];
    //    [actionSheet addButtonWithTitle:@"Cancel" type:CMActionSheetButtonTypeGray block:^{
    //        NSLog(@"Dismiss action sheet with \"Close Button\"");
    //    }];
    
    // Present
    [actionSheet present];
}



//-(void)handleFaceBookAuthOK:(id)anObject
//{
//    FBSession *session = anObject;
//    NSString *accessToken = session.accessTokenData.accessToken;//[GGFacebookOAuth sharedInstance].session.accessTokenData.accessToken;
//    
//    [self showLoadingHUD];
//    id op = [GGSharedAPI snSaveFacebookWithToken:accessToken callback:^(id operation, id aResultObject, NSError *anError) {
//        [self hideLoadingHUD];
//        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//        if (parser.isOK)
//        {
//            [GGUtils addSnType:kGGSnTypeFacebook];
//            
//            if (_updateForSharing)
//            {
//                [self _shareUpdateWithType:kGGSnTypeFacebook];
//            }
//            else if (_happeningForSharing)
//            {
//                [self _shareHappeningWithType:kGGSnTypeFacebook];
//            }
//        }
//    }];
//    
//    [self registerOperation:op];
//}
//
//-(void)handleSalesforceAuthOK:(id)anObject
//{
//    
//}
//
//-(void)handleTwitterAuthOK:(id)anObject
//{
//    
//}

-(void)_shareUpdateWithType:(EGGSnType)aType
{
    GGSnShareVC *vc = [[GGSnShareVC alloc] init];
    vc.comUpdateDetail = _updateForSharing;
    vc.shareType = kGGSnShareTypeUpdate;
    vc.snType = aType;
    vc.snTypesRef = GGSharedRuntimeData.snTypes;
    
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)_shareHappeningWithType:(EGGSnType)aType
{
    GGSnShareVC *vc = [[GGSnShareVC alloc] init];
    vc.happening = _happeningForSharing;
    vc.snType = aType;
    vc.snTypesRef = GGSharedRuntimeData.snTypes;
    vc.shareType = _happeningForSharing.isPersonEvent ? kGGSnShareTypeHappeningPerson : kGGSnShareTypeHappeningCompany;
    
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)_showSheetToShare:(BOOL)aShareUpdate
{
    CMActionSheet *actionSheet = [[CMActionSheet alloc] init];
    actionSheet.title = @"Share";
    
    UIImage *bgImg = nil;
    
    //if ([self _hasLinkedSnType:kGGSnTypeSalesforce])
    {
        // lightGrayBtnBg
        bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"chatterLongBtnBg"];
        [actionSheet addButtonWithTitle:@"Chatter" bgImage:bgImg block:^{
            
            DLog(@"Shared to chatter.");
            aShareUpdate ? [self _shareUpdateWithType:kGGSnTypeSalesforce] : [self _shareHappeningWithType:kGGSnTypeSalesforce];            
        }];
    }
    
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"facebookLongBtnBg"];
    [actionSheet addButtonWithTitle:@"LinkedIn" bgImage:bgImg block:^{
        
        aShareUpdate ? [self _shareUpdateWithType:kGGSnTypeLinkedIn] : [self _shareHappeningWithType:kGGSnTypeLinkedIn];
    
    }];
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"twitterLongBtnBg"];
    [actionSheet addButtonWithTitle:@"Twitter" bgImage:bgImg block:^{
        DLog(@"Shared to Twitter.");
        
        aShareUpdate ? [self _shareUpdateWithType:kGGSnTypeTwitter] : [self _shareHappeningWithType:kGGSnTypeTwitter];
        
    }];
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"facebookLongBtnBg"];
    [actionSheet addButtonWithTitle:@"Facebook" bgImage:bgImg block:^{
        DLog(@"Shared to facebook.");
        
        aShareUpdate ? [self _shareUpdateWithType:kGGSnTypeFacebook] : [self _shareHappeningWithType:kGGSnTypeFacebook];
        
    }];
    
    
    if ([GGUtils hasLinkedSnType:kGGSnTypeYammer])
    {
        bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"chatterLongBtnBg"];
        [actionSheet addButtonWithTitle:@"Yammer" bgImage:bgImg block:^{
            DLog(@"Shared to Yammer.");
            aShareUpdate ? [self _shareUpdateWithType:kGGSnTypeYammer] : [self _shareHappeningWithType:kGGSnTypeYammer];
        }];
    }
    
    [actionSheet addSeparator];
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"facebookLongBtnBg"];
    [actionSheet addButtonWithTitle:@"Email" bgImage:bgImg block:^{
        aShareUpdate ? [self sendMailForUpdate] : [self sendMailForHappening];
    }];
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"facebookLongBtnBg"];
    [actionSheet addButtonWithTitle:@"SMS" bgImage:bgImg block:^{
        aShareUpdate ? [self sendSMSForUpdate] : [self sendSMSForHappening];
    }];
    
    [actionSheet addSeparator];
    
    bgImg = [UIImage imageNamed:@"grayBtnBg"];
    UIButton *cancelBtn = [actionSheet addButtonWithTitle:@"Cancel" bgImage:bgImg block:^{
        
    }];
    [cancelBtn setTitleColor:GGSharedColor.white forState:UIControlStateNormal];
    [cancelBtn setTitleShadowColor:GGSharedColor.black forState:UIControlStateNormal];
    
    
    //    [actionSheet addSeparator];
    //    [actionSheet addButtonWithTitle:@"Cancel" type:CMActionSheetButtonTypeGray block:^{
    //        NSLog(@"Dismiss action sheet with \"Close Button\"");
    //    }];
    
    // Present
    [actionSheet present];
}

-(void)sendSMSForUpdate
{
    NSString *body = [NSString stringWithFormat:@"%@\n\n%@\n\nvia Gagein at www.gagein.com", _updateForSharing.headline, _updateForSharing.url];
    [GGUtils sendSmsTo:nil body:body vcDelegate:self];
    [GGSharedDelegate makeNaviBarCustomed:NO];
}

-(void)sendSMSForHappening
{
    NSString *body = [NSString stringWithFormat:@"%@\n\nvia Gagein at www.gagein.com", [_happeningForSharing headLineText]];
    [GGUtils sendSmsTo:nil body:body vcDelegate:self];
    [GGSharedDelegate makeNaviBarCustomed:NO];
}


-(void)sendMailForUpdate
{
    if (![MFMailComposeViewController canSendMail])
    {
        [GGAlert alertWithMessage:@"Sorry, You can't send email on this device."];
        return;
    }
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:_updateForSharing.headline];
    
    NSString *contentBody = [NSString stringWithFormat:@"<div><p>I want to share this update with you.</p> \
                             <p><a href=\"%@\">%@</a></p> \
                             <p><strong>%@</strong></p> \
                             <p><em>%@</em></p> \
                             Shared from <a href=\"www.gagein.com\">GageIn</a>, %@ </div>"
                             , _updateForSharing.url, _updateForSharing.url
                             , _updateForSharing.headline
                             , _updateForSharing.contentInDetail, GAGEIN_SLOGAN];
    
    
    [controller setMessageBody:contentBody isHTML:YES];
    
    [GGSharedDelegate makeNaviBarCustomed:NO];
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)sendMailForHappening
{
    if (![MFMailComposeViewController canSendMail])
    {
        [GGAlert alertWithMessage:@"Sorry, You can't send email on this device."];
        return;
    }
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:[_happeningForSharing headLineText]];
    
    NSString *contentBody = [NSString stringWithFormat:@"<div><p>I want to share this update with you.</p> \
                             <p><strong>%@</strong></p> \
                             Shared from <a href=\"www.gagein.com\">GageIn</a>, %@ </div>"
                             
                             , [_happeningForSharing headLineText], GAGEIN_SLOGAN];
    
    
    [controller setMessageBody:contentBody isHTML:YES];
    
    [GGSharedDelegate makeNaviBarCustomed:NO];
    [self presentViewController:controller animated:YES completion:nil];
    
}

#pragma mark - message delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            DLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            DLog(@"Failed");
            break;
        case MessageComposeResultSent:
            [self showCheckMarkHUDWithText:@"Sent OK!"];
            break;
        default:
            break;
    }
    
    [GGSharedDelegate makeNaviBarCustomed:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    
    [GGSharedDelegate makeNaviBarCustomed:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
