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

#import "OAuthLoginView.h"
#import "GGSalesforceOAuthVC.h"
#import "GGFacebookOAuthVC.h"

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
        //DLog(@"oauth {consumner:%@, accesstoken:%@}", _oAuthLoginView.consumer, _oAuthLoginView.accessToken);
//#warning GOTO register page
        OAuthLoginView *linkedInVC = [self linkedInAuthView];
        [GGSharedAPI snGetUserInfoLinedInWithToken:linkedInVC.accessToken.key secret:linkedInVC.accessToken.secret callback:^(id operation, id aResultObject, NSError *anError) {
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                
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
        
    }
    else if ([notiName isEqualToString:OA_NOTIFY_TWITTER_OAUTH_OK]) // twitter ok
    {
        
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
    GGSignupVC *vc = [[GGSignupVC alloc] init];
    
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
    [GGAlert alert:@"Connect to Yammer (TODO)"];
}



@end
