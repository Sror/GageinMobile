//
//  GGTimeZone.h
//  Gagein
//
//  Created by Dong Yiming on 5/16/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

@interface GGTimeZone : GGDataModel
@property (copy) NSString   *idStr;
@property (copy) NSString   *zone;
@property (copy) NSString   *name;
@end
