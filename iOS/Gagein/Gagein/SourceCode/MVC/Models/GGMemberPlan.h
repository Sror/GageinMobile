//
//  GGMemberPlan.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

@interface GGMemberPlan : GGDataModel

@property (copy)    NSString *name;
@property (assign) int followCompanyLimit;
@property (assign) int saveSearchLimit;
@property (assign) int saveUpdateLimit;
@property (assign) int searchResultLimit;
@property (assign) BOOL useCrmFlag;
@end
