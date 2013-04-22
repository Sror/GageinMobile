//
//  GGFunctionalArea.m
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGFunctionalArea.h"

@implementation GGFunctionalArea


-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"functional_areaid"] longLongValue];
    self.checked = [[aData objectForKey:@"checked"] boolValue];
    self.name = [aData objectForKey:@"functional_area_name"];
    
}

@end
