//
//  GGFacebookOAuth.m
//  Gagein
//
//  Created by dong yiming on 13-5-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGFacebookOAuth.h"

@implementation GGFacebookOAuth
DEF_SINGLETON(GGFacebookOAuth)

//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    // attempt to extract a token from the url
//    return [FBAppCall handleOpenURL:url
//                  sourceApplication:sourceApplication
//                        withSession:self.session];
//}

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:sourceApplication
{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    /*
//     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//     */
//    
//    // FBSample logic
//    // We need to properly handle activation of the application with regards to SSO
//    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
//    [FBAppCall handleDidBecomeActiveWithSession:self.session];
//}

-(void)handleBecomeActive
{
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

@end
