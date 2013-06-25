//
//  GGBaseViewController.h
//  Gagein
//
//  Created by dong yiming on 13-4-3.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@class GGLinkedInOAuthVC;

@interface GGBaseViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic)  UILabel                     *customNaviTitle;
@property (copy, nonatomic)    NSString                    *naviTitle;
@property (strong, nonatomic)  UIButton                    *naviButtonLeft;
@property (strong, nonatomic)  UIImageView                 *ivGageinLogo;

@property (assign, nonatomic)   BOOL    isMenuShowingBeforeLeavePortrait;

+(id)createInstance;

-(void)showLoadingHUD;
-(void)hideLoadingHUD;
-(void)showCheckMarkHUDWithText:(NSString *)aText;
//- (void)showHUDWithCustomView:(UIView*)aCustomView text:(NSString *)aText;

-(void)installGageinLogo;
-(void)installGageinLogoTo:(UIView *)aView;
-(void)installTopLine;

-(void)showBackButton;
-(void)hideBackButton;
-(void)pushBackButtonFront;

#pragma mark - screen migration
-(void)enterPersonDetailWithID:(long long)aPersonID;
-(void)enterCompanyDetailWithID:(long long)aCompanyID;
-(void)enterEmployeesListWithID:(long long)aCompanyID;

// for overriding
-(void)naviBackAction:(id)aSender;
-(void)dismissAction:(id)aSender;

//unknown reason cause view a little hide at top, adjust using this method
-(CGRect)viewportAdjsted;

-(void)viewWillAppearNotFirstTimeAction;

-(void)blockUI;
-(void)unblockUI;


#pragma mark -
-(void)connectSalesForce;

-(void)connectLinkedIn;

-(void)connectFacebookRead;
-(void)connectFacebookReadAndPublish;

-(void)connectTwitter;

-(GGLinkedInOAuthVC *)linkedInAuthView;

// operation management
-(void)registerOperation:(id)anOperation;
-(void)unregisterOperation:(id)anOperation;

-(void)presentImageWithURL:(NSString *)anImageURL;

#pragma mark - config & exploring actions
-(void)presentPageFollowCompanies;
-(void)presentPageFollowPeople;
-(void)presentPageSelectAgents;
-(void)presentPageSelectFuncArea;
-(void)presentPageConfigFilters;


#pragma mark - lay out for ipad
-(void)layoutUIForIPadIfNeeded;
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation; // for overwriting

//-(CGRect)frameWithOrientation:(UIInterfaceOrientation)anOrientation;
-(CGRect)frameOrientated;

-(BOOL)isPortrait;
-(BOOL)isIPadLandscape;

-(void)freezeMe:(BOOL)aFreeze;

//-(void)setNeedMenu:(BOOL)aNeedMenu;
//-(BOOL)needMenu;
-(BOOL)doNeedMenu;

#pragma mark - navi or modal
-(BOOL)isTheRootOfNaviStack;
-(BOOL)isTheTopOfNaviStack;
-(BOOL)isPresentedModally;


-(void)popSheetForVC:(UIViewController *)aViewController;
-(void)popSheetInNaviForVC:(UIViewController *)aViewController;
-(void)presentInNaviWithVC:(UIViewController *)aViewController;

@end
