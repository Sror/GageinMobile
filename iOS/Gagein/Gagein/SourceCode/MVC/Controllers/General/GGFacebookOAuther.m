//
//  GGFacebookOAuther.m
//  Gagein
//
//  Created by Dong Yiming on 5/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGFacebookOAuther.h"
#import "GGFacebookOAuth.h"

@implementation GGFacebookOAuther
- (id)init
{
    self = [super init];
    if (self)
    {
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
    return self;
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
    NSArray *permisson = [NSArray arrayWithObjects:@"offline_access", @"read_stream", @"publish_stream", @"publish_checkins", @"manage_pages", @"email", nil];
    [GGFacebookOAuth sharedInstance].session = [[FBSession alloc] initWithPermissions:permisson];
}

-(void)_doOpenSession
{
    
    [[self _sharedSession] openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        [self _handleSuccess];
    }];
}

-(FBSession *)_sharedSession
{
    return [GGFacebookOAuth sharedInstance].session;
}

-(void)_handleSuccess
{
    if ([self _sharedSession].isOpen)
    {
        DLog(@"token:%@", [self _sharedSession].accessTokenData.accessToken);
        [self postNotification:OA_NOTIFY_FACEBOOK_AUTH_OK];
        
        //[self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        // not logged in
    }
}

@end
