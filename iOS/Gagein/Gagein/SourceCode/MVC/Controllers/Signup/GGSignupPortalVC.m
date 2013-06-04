//
//  GGSignupPortalVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSignupPortalVC.h"
#import "GGWelcomeVC.h"
#import "GGLoginVC.h"
#import "GGSignupVC.h"

#import "GGRuntimeData.h"

#import "GGLinkedInOAuthVC.h"
#import "GGSalesforceOAuthVC.h"

#import "GGFacebookOAuth.h"
#import "GGSnUserInfo.h"
#import "OAToken.h"
#import "GGAppDelegate.h"

#define TAG_ALERT_SALESFORCE_OAUTH_FAILED   1000


@interface GGSignupPortalVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblConnect;
@property (weak, nonatomic) IBOutlet UILabel *lblAlreadyMember;

@property (weak, nonatomic) IBOutlet UIButton *btnSalesforce;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnYammer;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSignupFree;
@property (weak, nonatomic) IBOutlet UIButton *btnLearnMore;

@end

@implementation GGSignupPortalVC
{
   // OAuthLoginView *_oAuthLoginView;
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
    
    [self observeNotification:GG_NOTIFY_GET_STARTED];
    [self observeNotification:OA_NOTIFY_SALESFORCE_AUTH_OK];
    [self observeNotification:OA_NOTIFY_FACEBOOK_AUTH_OK];
    [self observeNotification:OA_NOTIFY_TWITTER_OAUTH_OK];
    [self observeNotification:OA_NOTIFY_SALESFORCE_AUTH_OK];
    
    if ([GGRuntimeData sharedInstance].isFirstRun)
    {
        [self learnMoreAction:nil];
    }
    
    [self installGageinLogo];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)dealloc
{
    [self unobserveNotification:GG_NOTIFY_GET_STARTED];
}

-(void)doLayoutUIForIPad
{
    float offsetY = CGRectGetMaxY(self.ivGageinLogo.frame) + 5;
    _lblConnect.frame = CGRectMake((self.view.frame.size.width - _lblConnect.frame.size.width) / 2
                                   , offsetY, _lblConnect.frame.size.width, _lblConnect.frame.size.height);
    
    //
    offsetY = CGRectGetMaxY(_lblConnect.frame) + 5;
    UIImage *salesforceImg = [UIImage imageNamed:@"pad_btnSalesforce"];
    [_btnSalesforce setImage:salesforceImg forState:UIControlStateNormal];
    _btnSalesforce.frame = CGRectMake((self.view.frame.size.width - salesforceImg.size.width) / 2
                                      , offsetY, salesforceImg.size.width, salesforceImg.size.height);
}

#pragma mark - handle notification
- (void)handleNotification:(NSNotification *)notification
{
    NSString *notiName = notification.name;
    if ([notiName isEqualToString:OA_NOTIFY_LINKEDIN_AUTH_OK])    // linkedIn
    {
        [self unobserveNotification:OA_NOTIFY_LINKEDIN_AUTH_OK];
        
        [self showLoadingHUD];
        GGLinkedInOAuthVC *linkedInVC = [self linkedInAuthView];
        id op = [GGSharedAPI snGetUserInfoLinedInWithToken:linkedInVC.accessToken.key secret:linkedInVC.accessToken.secret callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            
            if (parser.isOK)
            {
                GGSnUserInfo *userInfo = [parser parseSnGetUserInfo];
                userInfo.snType = kGGSnTypeLinkedIn;
                [self _signupWithUserInfo:userInfo];
            }
            
        }];
        
        [self registerOperation:op];
    }
    else if ([notiName isEqualToString:GG_NOTIFY_GET_STARTED])
    {
        [self.navigationController.view.layer addAnimation:[GGAnimation animationPushFromRight] forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if ([notiName isEqualToString:OA_NOTIFY_SALESFORCE_AUTH_OK])   // salesforce ok
    {
        SFOAuthCredentials *credential = notification.object;
        
        [self showLoadingHUD];
        id op = [GGSharedAPI snGetUserInfoSalesforceWithToken:credential.accessToken accountID:credential.userId refreshToken:credential.refreshToken instanceURL:credential.instanceUrl.absoluteString callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            
            if (parser.isOK)
            {
                GGSnUserInfo *userInfo = [parser parseSnGetUserInfo];
                userInfo.snType = kGGSnTypeSalesforce;
                [self _signupWithUserInfo:userInfo];
            }
            else if (parser.messageCode == kGGMsgCodeSnSaleforceCantAuth)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[GGStringPool stringWithMessageCode:kGGMsgCodeSnSaleforceCantAuth] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"Learn more", nil];
                alert.tag = TAG_ALERT_SALESFORCE_OAUTH_FAILED;
                [alert show];
            }
            
        }];
        
        [self registerOperation:op];
    }
    else if ([notiName isEqualToString:OA_NOTIFY_FACEBOOK_AUTH_OK]) // facebook ok
    {
        NSString *accessToken = [GGFacebookOAuth sharedInstance].session.accessTokenData.accessToken;
        
        [self showLoadingHUD];
        id op = [GGSharedAPI snGetUserInfoFacebookWithToken:accessToken callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            
            if (parser.isOK)
            {
                GGSnUserInfo *userInfo = [parser parseSnGetUserInfo];
                userInfo.snType = kGGSnTypeFacebook;
                [self _signupWithUserInfo:userInfo];
            }
        }];
        
        [self registerOperation:op];
    }
    else if ([notiName isEqualToString:OA_NOTIFY_TWITTER_OAUTH_OK]) // twitter ok
    {
        OAToken *token = notification.object;
        
        [self showLoadingHUD];
        id op = [GGSharedAPI snGetUserInfoTwitterWithToken:token.key secret:token.secret callback:^(id operation, id aResultObject, NSError *anError) {
            
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            
            if (parser.isOK)
            {
                GGSnUserInfo *userInfo = [parser parseSnGetUserInfo];
                userInfo.snType = kGGSnTypeTwitter;
                [self _signupWithUserInfo:userInfo];
            }
            
        }];
        
        [self registerOperation:op];
    }
}

#pragma mark - actions
-(IBAction)learnMoreAction:(id)sender
{
    GGWelcomeVC *vc = [[GGWelcomeVC alloc] init];
    
    [self.navigationController.view.layer addAnimation:[GGAnimation animationPushFromRight] forKey:nil];
    [self.navigationController pushViewController:vc animated:NO];
}

-(IBAction)loginAction:(id)sender
{
    GGLoginVC *vc = [GGLoginVC createInstance];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.view.window.layer addAnimation:[GGAnimation animationPushFromRight] forKey:nil];
    [self presentViewController:nc animated:NO completion:nil];
}

-(IBAction)signupAction:(id)sender
{
    [self _signupWithUserInfo:nil];
}

-(void)_signupWithUserInfo:(GGSnUserInfo *)aUserInfo
{
    GGSignupVC *vc = [[GGSignupVC alloc] init];
    vc.userInfo = aUserInfo;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.view.window.layer addAnimation:[GGAnimation animationPushFromRight] forKey:nil];
    [self presentViewController:nc animated:NO completion:nil];
}

-(IBAction)connectSalesForceAction:(id)sender
{
    [self connectSalesForce];
}

-(IBAction)connectLinkedInAction:(id)sender
{
    [self connectLinkedIn];
}

-(IBAction)connectFacebookAction:(id)sender
{
    [self connectFacebook];
}

-(IBAction)connectTwitterAction:(id)sender
{
    [self connectTwitter];
}

-(IBAction)connectYammerAction:(id)sender
{
    [GGAlert alertWithMessage:@"Connect to Yammer (TODO)"];
}

#pragma mark - 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TAG_ALERT_SALESFORCE_OAUTH_FAILED)
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.salesforce.com/crm/editions-pricing.jsp"]];
        }
    }
}

- (void)viewDidUnload {
    [self setLblConnect:nil];
    [self setLblAlreadyMember:nil];
    [self setBtnSalesforce:nil];
    [self setBtnLinkedIn:nil];
    [self setBtnFacebook:nil];
    [self setBtnTwitter:nil];
    [self setBtnYammer:nil];
    [self setBtnLogin:nil];
    [self setBtnSignupFree:nil];
    [self setBtnLearnMore:nil];
    [super viewDidUnload];
}
@end
