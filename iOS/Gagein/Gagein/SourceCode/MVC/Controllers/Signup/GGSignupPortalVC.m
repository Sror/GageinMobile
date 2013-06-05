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

//-(void)doLayoutUIForIPad
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    CGRect thisRc = [GGUtils frameWithOrientation:toInterfaceOrientation rect:self.view.frame];
    
    float offsetY = CGRectGetMaxY(self.ivGageinLogo.frame) + 50;
    _lblConnect.frame = CGRectMake((thisRc.size.width - _lblConnect.frame.size.width) / 2
                                   , offsetY, _lblConnect.frame.size.width, _lblConnect.frame.size.height);
    
    //
    offsetY = CGRectGetMaxY(_lblConnect.frame) + 10;
    UIImage *salesforceImg = [UIImage imageNamed:@"pad_btnSalesforce"];
    [_btnSalesforce setImage:salesforceImg forState:UIControlStateNormal];
    _btnSalesforce.frame = CGRectMake((thisRc.size.width - salesforceImg.size.width) / 2
                                      , offsetY, salesforceImg.size.width, salesforceImg.size.height);
    
    //
    offsetY = CGRectGetMaxY(_btnSalesforce.frame) + 10;
    UIImage *linkedInImg = [UIImage imageNamed:@"pad_btnLinkedIn"];
    [_btnLinkedIn setImage:linkedInImg forState:UIControlStateNormal];
    _btnLinkedIn.frame = CGRectMake((thisRc.size.width - linkedInImg.size.width) / 2
                                      , offsetY, linkedInImg.size.width, linkedInImg.size.height);
    
    //
    offsetY = CGRectGetMaxY(_btnLinkedIn.frame) + 10;
    UIImage *facebookImg = [UIImage imageNamed:@"pad_btnFacebook"];
    [_btnFacebook setImage:facebookImg forState:UIControlStateNormal];
    _btnFacebook.frame = CGRectMake((thisRc.size.width - facebookImg.size.width) / 2
                                    , offsetY, facebookImg.size.width, facebookImg.size.height);
    
    //
    offsetY = CGRectGetMaxY(_btnFacebook.frame) + 10;
    UIImage *twitterImg = [UIImage imageNamed:@"pad_btnTwitter"];
    [_btnTwitter setImage:twitterImg forState:UIControlStateNormal];
    _btnTwitter.frame = CGRectMake((thisRc.size.width - twitterImg.size.width) / 2
                                    , offsetY, twitterImg.size.width, twitterImg.size.height);
    
    //
    offsetY = CGRectGetMaxY(_btnTwitter.frame) + 10;
    UIImage *signupFreeImg = [UIImage imageNamed:@"pad_btnSignupFree"];
    [_btnSignupFree setImage:signupFreeImg forState:UIControlStateNormal];
    _btnSignupFree.frame = CGRectMake((thisRc.size.width - signupFreeImg.size.width) / 2
                                   , offsetY, signupFreeImg.size.width, signupFreeImg.size.height);
    
    //
    offsetY = CGRectGetMaxY(_btnSignupFree.frame) + 10;
    
    _lblAlreadyMember.frame = CGRectMake((thisRc.size.width - _lblAlreadyMember.frame.size.width) / 2
                                 , offsetY, _lblAlreadyMember.frame.size.width, _lblAlreadyMember.frame.size.height);
    
    //
    offsetY = CGRectGetMaxY(_lblAlreadyMember.frame) + 10;
    UIImage *loginImg = [UIImage imageNamed:@"pad_btnLogin"];
    [_btnLogin setImage:loginImg forState:UIControlStateNormal];
    _btnLogin.frame = CGRectMake((thisRc.size.width - loginImg.size.width) / 2
                                      , offsetY, loginImg.size.width, loginImg.size.height);
    
    //
    offsetY = CGRectGetMaxY(_btnLogin.frame) + 20;
    
    _btnLearnMore.frame = CGRectMake((thisRc.size.width - _btnLearnMore.frame.size.width) / 2
                                         , offsetY, _btnLearnMore.frame.size.width, _btnLearnMore.frame.size.height);
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
        [self.navigationController.view.layer addAnimation:[GGUtils animationTransactionPushed:YES] forKey:nil];
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
        FBSession *session = notification.object;
        NSString *accessToken = session.accessTokenData.accessToken;//[GGFacebookOAuth sharedInstance].session.accessTokenData.accessToken;
        
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
    
    [self.navigationController.view.layer addAnimation:[GGUtils animationTransactionPushed:YES] forKey:nil];
    [self.navigationController pushViewController:vc animated:NO];
}

-(IBAction)loginAction:(id)sender
{
    GGLoginVC *vc = [GGLoginVC createInstance];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.view.window.layer addAnimation:[GGUtils animationTransactionPushed:YES] forKey:nil];
    [self presentViewController:nc animated:NO completion:nil];
}

-(IBAction)signupAction:(id)sender
{
    [self _signupWithUserInfo:nil];
}

-(void)_signupWithUserInfo:(GGSnUserInfo *)aUserInfo
{
    GGSignupVC *vc = [GGSignupVC createInstance];
    vc.userInfo = aUserInfo;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.view.window.layer addAnimation:[GGUtils animationTransactionPushed:YES] forKey:nil];
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
    [self connectFacebookRead];
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
