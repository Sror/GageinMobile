//
//  GGFacebookOAuthVC.m
//  Gagein
//
//  Created by dong yiming on 13-5-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGFacebookOAuthVC.h"
#import "GGFacebookOAuth.h"

@interface GGFacebookOAuthVC ()

@end

@implementation GGFacebookOAuthVC

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
    
    if (![self _sharedSession].isOpen)
    {
        [self _doCreateSession];
        
        if ([self _sharedSession].state == FBSessionStateCreatedTokenLoaded)
        {
            [self _doOpenSession];
        }
    }
    
    [self switchSession];
}

-(void)switchSession
{
    
    if ([self _sharedSession].isOpen) {
        
        [[self _sharedSession] closeAndClearTokenInformation];
        
    } else {
        if ([self _sharedSession].state != FBSessionStateCreated) {
            
            [self _doCreateSession];
        }
        
        [self _doOpenSession];
    }
}

-(void)_doCreateSession
{
    [GGFacebookOAuth sharedInstance].session = [[FBSession alloc] init];
}

-(void)_doOpenSession
{
    [[self _sharedSession] openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        [self _updateUI];
    }];
}

-(FBSession *)_sharedSession
{
    return [GGFacebookOAuth sharedInstance].session;
}

-(void)_updateUI
{
    if ([self _sharedSession].isOpen)
    {
        DLog(@"token:%@", [self _sharedSession].accessTokenData.accessToken);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        // not logged in
    }
}


@end
