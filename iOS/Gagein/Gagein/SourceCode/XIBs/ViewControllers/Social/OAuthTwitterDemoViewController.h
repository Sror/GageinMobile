//
//  OAuthTwitterDemoViewController.h
//  OAuthTwitterDemo
//
//  Created by Ben Gottlieb on 7/24/09.
//  Copyright Stand Alone, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"

@class SA_OAuthTwitterEngine;


@interface OAuthTwitterDemoViewController : GGBaseViewController <SA_OAuthTwitterControllerDelegate> {
	SA_OAuthTwitterEngine				*_engine;

}

@end


#define OA_NOTIFY_TWITTER_OAUTH_OK  @"OA_NOTIFY_TWITTER_OAUTH_OK"
