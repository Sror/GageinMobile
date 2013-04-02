//
//  GGSocialProfile.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

@interface GGSocialProfile : GGDataModel
@property (copy) NSString   *type;          // salesforce, linkedIn ...
@property (copy) NSString   *url;           // social profile url
@end
