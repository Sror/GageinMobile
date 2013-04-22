//
//  GGNApi.h
//  GageinApp
//
//  Created by dong yiming on 13-3-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "GGNDefine.h"


@interface GGNApi : AFHTTPClient

// singleton method to get a shared api all over the app
+ (GGNApi *)sharedApi;

-(void)getCompanyInfoWithID:(long)aCompanyID includeSp:(BOOL)aIsIncludeSp callback:(GGNApiBlock)aCallback;
@end
