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
    if ([notiName isEqualToString:OA_LOGIN_VIEW_DID_FINISH])
    {
        [self unobserveNotification:OA_LOGIN_VIEW_DID_FINISH];
        //DLog(@"oauth {consumner:%@, accesstoken:%@}", _oAuthLoginView.consumer, _oAuthLoginView.accessToken);
#warning GOTO register page
    }
    else if ([notiName isEqualToString:GG_NOTIFY_GET_STARTED])
    {
        [self.navigationController.view.layer addAnimation:[GGAnimation animationPushFromRight] forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if ([notiName isEqualToString:OA_NOTIFY_SALESFORCE_AUTH_OK])
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
    //[GGAlert alert:@"Connect to LinkedIn (TODO)"];
//    _oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:nil bundle:nil];
//    [self observeNotification:OA_LOGIN_VIEW_DID_FINISH];
//    [self.navigationController pushViewController:_oAuthLoginView animated:YES];
}

-(IBAction)connectFacebookAction:(id)sender
{
    [self connectFacebook];
    //[GGAlert alert:@"Connect to Facebook (TODO)"];
//    GGFacebookOAuthVC *vc = [[GGFacebookOAuthVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)connectTwitterAction:(id)sender
{
    [GGAlert alert:@"Connect to Twitter (TODO)"];
}

-(IBAction)connectYammerAction:(id)sender
{
    [GGAlert alert:@"Connect to Yammer (TODO)"];
}



@end
