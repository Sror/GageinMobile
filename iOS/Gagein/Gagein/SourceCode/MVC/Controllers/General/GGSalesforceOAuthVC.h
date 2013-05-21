//
//  GGSalesforceOAuthVC.h
//  Gagein
//
//  Created by dong yiming on 13-5-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFOAuthCoordinator.h"

@interface GGSalesforceOAuthVC : GGBaseViewController <SFOAuthCoordinatorDelegate>
@property (nonatomic, retain) SFOAuthCoordinator *oauthCoordinator;
@property (nonatomic, retain) SFOAuthInfo *authInfo;
@end

#define OA_NOTIFY_SALESFORCE_AUTH_OK    @"OA_NOTIFY_SALESFORCE_AUTH_OK"
