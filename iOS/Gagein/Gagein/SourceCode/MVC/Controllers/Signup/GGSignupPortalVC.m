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



@interface GGSignupPortalVC ()

@end

@implementation GGSignupPortalVC

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
    if ([notification.name isEqualToString:GG_NOTIFY_GET_STARTED])
    {
        [self.navigationController.view.layer addAnimation:[GGAnimation animationPushFromRight] forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
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
    GGLoginVC *vc = [[GGLoginVC alloc] init];
    
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

@end
