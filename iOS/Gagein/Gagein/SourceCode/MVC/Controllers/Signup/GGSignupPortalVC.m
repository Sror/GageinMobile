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

@interface GGSignupPortalVC ()

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

#pragma mark - handle notification
- (void)handleNotification:(NSNotification *)notification
{
    NSString *notiName = notification.name;
    if ([notiName isEqualToString:OA_NOTIFY_LINKEDIN_AUTH_OK])    // linkedIn
    {
        [self unobserveNotification:OA_NOTIFY_LINKEDIN_AUTH_OK];
        
        [self showLoadingHUD];
        GGLinkedInOAuthVC *linkedInVC = [self linkedInAuthView];
        [GGSharedAPI snGetUserInfoLinedInWithToken:linkedInVC.accessToken.key secret:linkedInVC.accessToken.secret callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            
            if (parser.isOK)
            {
                GGSnUserInfo *userInfo = [parser parseSnGetUserInfo];
                userInfo.snType = kGGSnTypeLinkedIn;
                [self _signupWithUserInfo:userInfo];
            }
            
        }];
    }
    else if ([notiName isEqualToString:GG_NOTIFY_GET_STARTED])
    {
        [self.navigationController.view.layer addAnimation:[GGAnimation animationPushFromRight] forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if ([notiName isEqualToString:OA_NOTIFY_SALESFORCE_AUTH_OK])   // salesforce ok
    {
        
    }
    else if ([notiName isEqualToString:OA_NOTIFY_FACEBOOK_AUTH_OK]) // facebook ok
    {
        NSString *accessToken = [GGFacebookOAuth sharedInstance].session.accessTokenData.accessToken;
        
        [self showLoadingHUD];
        [GGSharedAPI snGetUserInfoFacebookWithToken:accessToken callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            
            if (parser.isOK)
            {
                GGSnUserInfo *userInfo = [parser parseSnGetUserInfo];
                userInfo.snType = kGGSnTypeFacebook;
                [self _signupWithUserInfo:userInfo];
            }
        }];
    }
    else if ([notiName isEqualToString:OA_NOTIFY_TWITTER_OAUTH_OK]) // twitter ok
    {
        OAToken *token = notification.object;
        
        [self showLoadingHUD];
        [GGSharedAPI snGetUserInfoTwitterWithToken:token.key secret:token.secret callback:^(id operation, id aResultObject, NSError *anError) {
            
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            
            if (parser.isOK)
            {
                GGSnUserInfo *userInfo = [parser parseSnGetUserInfo];
                userInfo.snType = kGGSnTypeTwitter;
                [self _signupWithUserInfo:userInfo];
            }
            
        }];
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



@end
