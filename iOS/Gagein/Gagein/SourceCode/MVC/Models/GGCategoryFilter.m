//
//  GGCategoryFilter.m
//  Gagein
//
//  Created by dong yiming on 13-5-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCategoryFilter.h"

@implementation GGCategoryFilter

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"categoryid"] longLongValue];
    self.name = [aData objectForKey:@"category_name"];
    self.checked = [[aData objectForKey:@"checked"] boolValue];
}

@end
