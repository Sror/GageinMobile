//
//  GGDataPage.h
//  Gagein
//
//  Created by dong yiming on 13-4-7.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

@interface GGDataPage : GGDataModel
@property (assign) BOOL             hasMore;
@property (assign) long long        timestamp;
@property (strong) NSMutableArray   *items;
@end
