//
//  GGMenuData.h
//  Gagein
//
//  Created by dong yiming on 13-4-12.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

@interface GGMenuData : GGDataModel
@property (copy)    NSString *name;
@property (copy)    NSString *timeInterval;
@property (assign)  BOOL        checked;
@end
