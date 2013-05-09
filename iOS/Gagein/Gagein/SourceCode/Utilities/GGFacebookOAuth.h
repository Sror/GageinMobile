//
//  GGFacebookOAuth.h
//  Gagein
//
//  Created by dong yiming on 13-5-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface GGFacebookOAuth : NSObject
AS_SINGLETON(GGFacebookOAuth)

@property (strong, nonatomic) FBSession *session;

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:sourceApplication;
-(void)handleBecomeActive;
@end
