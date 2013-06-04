//
//  GGBaseViewController.h
//  Gagein
//
//  Created by dong yiming on 13-4-3.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class GGLinkedInOAuthVC;

@interface GGBaseViewController : UIViewController

@property (strong)  UILabel                     *customNaviTitle;
@property (copy)    NSString                    *naviTitle;
@property (strong)  UIButton                    *naviButtonLeft;
@property (strong)  UIImageView                 *ivGageinLogo;

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
-(void)dismissAction:(id)aSender;

//unknown reason cause view a little hide at top, adjust using this method
-(CGRect)viewportAdjsted;

-(void)viewWillAppearNotFirstTimeAction;

-(void)blockUI;
-(void)unblockUI;


#pragma mark -
-(void)connectSalesForce;

-(void)connectLinkedIn;

-(void)connectFacebook;

-(void)connectTwitter;

-(GGLinkedInOAuthVC *)linkedInAuthView;

// operation management
-(void)registerOperation:(id)anOperation;
-(void)unregisterOperation:(id)anOperation;

-(void)presentImageWithURL:(NSString *)anImageURL;

#pragma mark - config & exploring actions
-(void)enterFollowCompaniesAction;
-(void)enterFollowPeopleAction;
-(void)enterSelectAgentsAction;
-(void)enterSelectFunctionalAreasAction;


#pragma mark - lay out for ipad
//-(void)layoutUIForIPad;     // do not overwrite
//-(void)doLayoutUIForIPad;   // for overwriting
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation; // for overwriting

//-(CGRect)frameWithOrientation:(UIInterfaceOrientation)anOrientation;
@end
