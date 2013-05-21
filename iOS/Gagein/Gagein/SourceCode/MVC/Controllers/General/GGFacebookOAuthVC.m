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
    self.view.backgroundColor = GGSharedColor.silver;
    
    
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
    NSArray *permisson = [NSArray arrayWithObjects:@"offline_access", @"read_stream", @"publish_stream", @"publish_checkins", @"manage_pages", @"email", nil];
    [GGFacebookOAuth sharedInstance].session = [[FBSession alloc] initWithPermissions:permisson];
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
        [self postNotification:OA_FACEBOOK_OK];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        // not logged in
    }
}


@end




//public static class FACEBOOK {
//    
//    /**
//     * App ID
//     136211636426538
//     API Key
//     8e2bbd413c44517bc080c58c9cb9637a
//     App Secret
//     b33dfea421742b2a626097ef73ccecc9
//     */
//    private static SITE_KEYS localKeys = new SITE_KEYS(
//                                                       "GageInApp.localhost",
//                                                       "http://localhost:8080/",
//                                                       "136211636426538",
//                                                       "8e2bbd413c44517bc080c58c9cb9637a",
//                                                       "b33dfea421742b2a626097ef73ccecc9"
//                                                       );
//    
//    /*
//     * App ID
//     166231010059122
//     API Key
//     de48c6821473fc0b292125ce33e232bc
//     App Secret
//     aeb6f7f56e47ab51a2e4b9f6def17ed8
//     */
//    private static SITE_KEYS qaKeys = new SITE_KEYS(
//                                                    "GageInApp.qa",
//                                                    "http://gagein.dyndns.org:3031/",
//                                                    "166231010059122",
//                                                    "de48c6821473fc0b292125ce33e232bc",
//                                                    "aeb6f7f56e47ab51a2e4b9f6def17ed8"
//                                                    );
//    
//    /**
//     * App ID
//     180436025308014
//     API Key
//     240883bfe2af9b0ce6a004768dda38ac
//     App Secret
//     dd04f371d1c1691e4926164bf3a6ed72
//     Site URL
//     http://gageincn.dyndns.org:3031/webapp?a=1
//     Site Domain
//     dyndns.org
//     */
//    private static SITE_KEYS qacnKeys = new SITE_KEYS(
//                                                      "GageInApp.qacn",
//                                                      "http://gageincn.dyndns.org:3031/",
//                                                      "180436025308014",
//                                                      "240883bfe2af9b0ce6a004768dda38ac",
//                                                      "dd04f371d1c1691e4926164bf3a6ed72"
//                                                      );
//    
//    /**
//     * App ID
//     158281777525249
//     API Key
//     52fa3cbbd89ac579b40348a8a2067dc7
//     App Secret
//     f77a62aa556e0f5bd27fc4797044bd91
//     */
//    private static SITE_KEYS stagingKeys = new SITE_KEYS(
//                                                         "GageInApp.staging",
//                                                         "http://gageinstaging.dyndns.org",
//                                                         "158281777525249",
//                                                         "52fa3cbbd89ac579b40348a8a2067dc7",
//                                                         "f77a62aa556e0f5bd27fc4797044bd91"
//                                                         );
//    
//    /**
//     * App ID
//     159696740721866
//     API Key
//     68150a5a50b230c6a6ea2d13a646d869
//     App Secret
//     b813b378224003ce0981bc7188ff97fd
//     */
//    private static SITE_KEYS productionKeys = new SITE_KEYS(
//                                                            "GageIn",
//                                                            "http://www.gagein.com/",
//                                                            "159696740721866",
//                                                            "68150a5a50b230c6a6ea2d13a646d869",
//                                                            "b813b378224003ce0981bc7188ff97fd"
//                                                            );
//    
//    private static SITE_KEYS demoKeys = new SITE_KEYS(
//                                                      "GageInApp.demo",
//                                                      "http://gageindemo.dyndns.org/",
//                                                      "145327812194205",
//                                                      "7cb21f9a4594361ec9497761eb78de5a",
//                                                      "ca0893a14a9a33987f945fb460b2918c"
//                                                      );
