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
        [GGFacebookOAuth sharedInstance].session = [[FBSession alloc] init];
        
//        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
//            // even though we had a cached token, we need to login to make the session usable
//            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
//                                                             FBSessionState status,
//                                                             NSError *error) {
//                // we recurse here, in order to update buttons and labels
//                [self updateView];
//            }];
//        }
    }
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
    }
    else
    {
        // not logged in
    }
}


@end
