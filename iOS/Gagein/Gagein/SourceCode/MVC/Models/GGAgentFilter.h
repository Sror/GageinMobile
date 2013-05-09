//
//  GGAgentGroup.h
//  Gagein
//
//  Created by dong yiming on 13-5-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"



@interface GGAgentFilter : GGDataModel

@property (copy)    NSString        *name;
@property (copy)    NSString        *keywords;
@property (assign)  int             type;
@property (assign)  BOOL            checked;
@end

//@interface GGAgentFiltersGroup : GGDataModel
//@property (copy)    NSString        *name;
//@property (strong)  NSMutableArray   *options;
//@property (assign)  BOOL            enabled;
//@end
