//
//  AppDelegate.h
//  SalesforceOAuth
//
//  Created by dong yiming on 13-3-28.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFOAuthCoordinator.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SFOAuthCoordinatorDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) SFOAuthCoordinator *oauthCoordinator;
@property (nonatomic, retain) SFOAuthInfo *authInfo;
@end
